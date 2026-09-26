#!/usr/bin/env bash
# Release the JsBarcode R package.
#
# Usage: scripts/release.sh [current|patch|minor|major|X.Y.Z] [--dry-run] [--yes]
#
#   current  release the version already in DESCRIPTION (default)
#   patch    0.1.0 -> 0.1.1      minor  0.1.0 -> 0.2.0      major  0.1.0 -> 1.0.0
#   X.Y.Z    release exactly this version
#
# Steps: preflight checks -> set Version and NEWS header -> make check ->
# commit + tag vX.Y.Z -> push -> GitHub release (notes from NEWS.md) ->
# bump to X.Y.Z.9000 development version and push.
# The published release triggers .github/workflows/pkgdown.yaml, which
# redeploys the documentation site to gh-pages.

# Re-run under bash when started as `sh script.sh` (dash lacks [[ ]]).
if [ -z "${BASH_VERSION:-}" ]; then exec bash "$0" "$@"; fi

set -euo pipefail

SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
cd "$(dirname "$SELF")/.."

BUMP="current"
DRY_RUN=0
ASSUME_YES=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --yes|-y) ASSUME_YES=1 ;;
    -h|--help) sed -n '2,15p' "$SELF" | sed 's/^# \{0,1\}//'; exit 0 ;;
    current|patch|minor|major) BUMP="$arg" ;;
    [0-9]*.[0-9]*.[0-9]*) BUMP="$arg" ;;
    *) echo "Unknown argument: $arg" >&2; exit 2 ;;
  esac
done

info() { printf '\033[36m==>\033[0m %s\n' "$*"; }
die()  { printf '\033[31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }
run()  {
  if [[ $DRY_RUN -eq 1 ]]; then printf '   [dry-run] %s\n' "$*"; else "$@"; fi
}

PKG=$(sed -n 's/^Package: //p' DESCRIPTION)
CURRENT=$(sed -n 's/^Version: //p' DESCRIPTION)
BASE=${CURRENT%.9000}

IFS=. read -r MAJ MIN PAT _ <<<"$BASE"
case "$BUMP" in
  current) VERSION="$BASE" ;;
  patch)   VERSION="$MAJ.$MIN.$((PAT + 1))" ;;
  minor)   VERSION="$MAJ.$((MIN + 1)).0" ;;
  major)   VERSION="$((MAJ + 1)).0.0" ;;
  *)       VERSION="$BUMP" ;;
esac
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "Invalid version: $VERSION"
TAG="v$VERSION"
DEV_VERSION="$VERSION.9000"

# --- Preflight --------------------------------------------------------------
info "Preflight checks"
command -v gh >/dev/null || die "GitHub CLI 'gh' not found"
gh auth status >/dev/null 2>&1 || die "'gh' is not authenticated (run: gh auth login)"
[[ "$(git rev-parse --abbrev-ref HEAD)" == "main" ]] || die "Not on branch main"
[[ -z "$(git status --porcelain)" ]] || die "Working tree is not clean"
git fetch --quiet --tags origin
[[ "$(git rev-parse HEAD)" == "$(git rev-parse origin/main)" ]] \
  || die "main is not in sync with origin/main"
git rev-parse -q --verify "refs/tags/$TAG" >/dev/null && die "Tag $TAG already exists"

NEWS_TOP=$(grep -m1 '^# ' NEWS.md || true)
case "$NEWS_TOP" in
  "# $PKG (development version)"|"# $PKG $VERSION") ;;
  *) die "NEWS.md must start with '# $PKG (development version)' or '# $PKG $VERSION' (found: '$NEWS_TOP')" ;;
esac

echo "   package:  $PKG"
echo "   current:  $CURRENT"
echo "   release:  $VERSION (tag $TAG)"
echo "   next dev: $DEV_VERSION"
[[ $DRY_RUN -eq 1 ]] && echo "   mode:     DRY RUN (nothing is changed)"

if [[ $ASSUME_YES -eq 0 && $DRY_RUN -eq 0 ]]; then
  read -r -p "Proceed with release $TAG? [y/N] " answer
  [[ "$answer" =~ ^[yY]$ ]] || die "Aborted"
fi

# --- Set release version ----------------------------------------------------
info "Setting version $VERSION"
run sed -i "s/^Version: .*/Version: $VERSION/" DESCRIPTION
run sed -i "1s/^# $PKG (development version)$/# $PKG $VERSION/" NEWS.md

# --- Check --------------------------------------------------------------------
info "Running make check"
run make check

# --- Commit, tag, push ------------------------------------------------------
info "Committing and tagging $TAG"
if [[ -n "$(git status --porcelain)" || $DRY_RUN -eq 1 ]]; then
  run git add DESCRIPTION NEWS.md man NAMESPACE
  run git commit -m "Release $PKG $VERSION"
fi
run git tag -a "$TAG" -m "$PKG $VERSION"
run git push origin main "$TAG"

# --- GitHub release -----------------------------------------------------------
info "Creating GitHub release $TAG"
NOTES=$(awk -v h="# $PKG $VERSION" '
  $0 == h {on = 1; next}
  on && /^# / {exit}
  on {print}' NEWS.md)
[[ $DRY_RUN -eq 1 && -z "$NOTES" ]] && NOTES="(notes from NEWS.md)"
[[ -n "$NOTES" ]] || die "No NEWS.md section found for $VERSION"
if [[ $DRY_RUN -eq 1 ]]; then
  printf '   [dry-run] gh release create %s --title "%s %s" --notes <<EOF\n%s\nEOF\n' \
    "$TAG" "$PKG" "$VERSION" "$NOTES"
else
  gh release create "$TAG" --title "$PKG $VERSION" --notes "$NOTES" --verify-tag
fi

# --- Back to development --------------------------------------------------------
info "Bumping to development version $DEV_VERSION"
run sed -i "s/^Version: .*/Version: $DEV_VERSION/" DESCRIPTION
if [[ $DRY_RUN -eq 1 ]]; then
  echo "   [dry-run] prepend '# $PKG (development version)' to NEWS.md"
else
  printf '# %s (development version)\n\n' "$PKG" | cat - NEWS.md > NEWS.md.tmp
  mv NEWS.md.tmp NEWS.md
fi
run git add DESCRIPTION NEWS.md
run git commit -m "Begin development of $PKG $DEV_VERSION"
run git push origin main

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "<owner>/<repo>")
info "Done: $PKG $VERSION released"
echo "   release: https://github.com/$REPO/releases/tag/$TAG"
echo "   actions: https://github.com/$REPO/actions (pkgdown redeploys gh-pages)"
