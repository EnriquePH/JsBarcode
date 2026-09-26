# Development and CI/CD

This article is for contributors. It describes the local workflow, the
continuous integration (CI) checks, and how the documentation site is
deployed.

## Local workflow

Every common task has a `make` target. Run `make help` to list them.

| Command | What it does |
|----|----|
| `make document` | Regenerate `man/` and `NAMESPACE` from roxygen comments |
| `make test` | Run the testthat suite |
| `make check` | Full `R CMD check`; fails on any warning |
| `make install` | Install the package into your local R library |
| `make run` | Install and launch the Shiny demo on `PORT` (default 3838) |
| `make site` | Build this pkgdown site into `docs/` |
| `make site-preview` | Open the built site in a browser |
| `make update-js` | Vendor the latest JsBarcode from npm (`JSVER=x.y.z` to pin) |
| `make clean` | Remove `docs/`, tarballs and check folders |

Before opening a pull request, run `make check`. It must end with 0
errors and 0 warnings.

## Continuous integration

Two GitHub Actions workflows live in `.github/workflows/`.

### `R-CMD-check.yaml`

- **Runs on:** every push to `main`/`master` and every pull request.
- **Matrix:** R release on Ubuntu, macOS and Windows, plus R devel and R
  oldrel-1 on Ubuntu.
- **Does:** installs dependencies with
  `r-lib/actions/setup-r-dependencies` and runs
  `R CMD check --no-manual`, which includes the test suite and the
  vignette.
- **Fails when:** check reports an error or warning in any job.

### `pkgdown.yaml`

- **Runs on:** pushes to `main`/`master`, published releases, pull
  requests and manual runs (“Run workflow” in the Actions tab).
- **Does:** installs the package and builds the site with
  [`pkgdown::build_site_github_pages()`](https://pkgdown.r-lib.org/reference/build_site_github_pages.html).
- **Deploys:** on everything except pull requests, it pushes the built
  `docs/` folder to the `gh-pages` branch with
  `JamesIves/github-pages-deploy-action`. Pull requests only build the
  site, so a broken site fails the PR before it reaches `main`.

## Continuous deployment of the documentation

The site at `https://EnriquePH.github.io/JsBarcode/` is served from the
`gh-pages` branch. `docs/` is git-ignored on `main`; the only copy of
the built site is on `gh-pages`, and only the workflow writes to it.

One-time setup after the repository is on GitHub:

1.  Push to `main`. The first `pkgdown` run creates the `gh-pages`
    branch.
2.  In **Settings → Pages**, set **Source** to “Deploy from a branch”,
    branch `gh-pages`, folder `/ (root)`.
3.  In **Settings → Actions → General → Workflow permissions**, make
    sure workflows may write to the repository (the workflow requests
    `contents: write`).

After that, every merge to `main` republishes the site within a few
minutes. Publishing a GitHub release also rebuilds it, so the News page
and version number stay in sync.

## Releasing

Releases are made with `scripts/release.sh` (also available as
`make release`).

``` sh
make release ARGS=--dry-run        # preview every step, change nothing
make release                       # release the version in DESCRIPTION
make release BUMP=patch            # 0.1.0 -> 0.1.1 (also minor, major, X.Y.Z)
```

Between releases, `DESCRIPTION` holds a development version
(`X.Y.Z.9000`) and `NEWS.md` starts with
`# JsBarcode (development version)`. Add a bullet there for every
user-visible change.

The script:

1.  **Preflight:** requires branch `main`, a clean working tree, `main`
    in sync with `origin/main`, an authenticated `gh`, a tag that does
    not exist yet, and a NEWS.md that starts with the development or
    release header.
2.  **Versions:** sets `Version:` and turns the NEWS header into
    `# JsBarcode X.Y.Z`.
3.  **Checks:** runs `make check`. Any error or warning stops the
    release.
4.  **Tag:** commits, creates an annotated tag `vX.Y.Z` and pushes both.
5.  **GitHub release:** runs `gh release create`, using that version’s
    NEWS section as the release notes. Publishing the release triggers
    `pkgdown.yaml`, which redeploys the site to `gh-pages`.
6.  **Next cycle:** bumps to `X.Y.Z.9000`, adds a new development header
    to NEWS.md, commits and pushes.

The script asks for confirmation before changing anything; pass `--yes`
to skip the prompt (for example `make release ARGS=--yes`).

## Updating the bundled JavaScript library

``` sh
make update-js            # latest version from npm
make update-js JSVER=3.12.3
```

The target replaces `inst/htmlwidgets/lib/jsbarcode-*`, updates
`inst/htmlwidgets/JsBarcode.yaml` and the version expected by the tests.
Afterwards, update `README.md` and `NEWS.md`, check whether the library
added formats that belong in `barcode_formats`, and run `make check`.
