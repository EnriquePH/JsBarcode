#!/usr/bin/env bash
# Launch the JsBarcode Shiny demo app.
#
# Usage: scripts/run-app.sh [--dev] [--port N] [--host H] [--browser]
#
#   --dev        run from the source tree (pkgload::load_all), no install
#   --port N     port to listen on (default 3838, or $PORT)
#   --host H     interface to bind (default 127.0.0.1; 0.0.0.0 for the LAN)
#   --browser    open the app in the default browser
#
# Without --dev, the app runs from the installed package. The package is
# (re)installed first when it is missing or older than the source version.
# Stop the app with Ctrl+C.

set -euo pipefail

cd "$(dirname "$0")/.."

DEV=0
PORT="${PORT:-3838}"
HOST="127.0.0.1"
BROWSER="FALSE"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dev) DEV=1 ;;
    --port) PORT="${2:?--port needs a value}"; shift ;;
    --host) HOST="${2:?--host needs a value}"; shift ;;
    --browser) BROWSER="TRUE" ;;
    -h|--help) sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown argument: $1 (see --help)" >&2; exit 2 ;;
  esac
  shift
done

info() { printf '\033[36m==>\033[0m %s\n' "$*"; }
die()  { printf '\033[31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

command -v Rscript >/dev/null || die "Rscript not found"
[[ "$PORT" =~ ^[0-9]+$ ]] || die "Invalid port: $PORT"

if command -v ss >/dev/null && ss -ltn "sport = :$PORT" | grep -q LISTEN; then
  die "Port $PORT is already in use (try --port $((PORT + 1)))"
fi

PKG=$(sed -n 's/^Package: //p' DESCRIPTION)
SRC_VERSION=$(sed -n 's/^Version: //p' DESCRIPTION)

if [[ $DEV -eq 1 ]]; then
  info "Running $PKG $SRC_VERSION from source"
  LOAD="pkgload::load_all('.', quiet = TRUE)"
else
  INSTALLED=$(Rscript -e "cat(tryCatch(as.character(packageVersion('$PKG')), error = function(e) ''))")
  # Exit status 1 from R means the installed version is older than the source
  if [[ -z "$INSTALLED" ]] || ! Rscript -e "quit(status = as.integer(package_version('$INSTALLED') < package_version('$SRC_VERSION')))"; then
    info "Installing $PKG $SRC_VERSION (installed: ${INSTALLED:-none})"
    Rscript -e "devtools::install(quiet = TRUE, upgrade = FALSE)"
  else
    info "Using installed $PKG $INSTALLED"
  fi
  LOAD="invisible(NULL)"
fi

info "Starting app on http://$HOST:$PORT (Ctrl+C to stop)"
exec Rscript -e "
$LOAD
app_dir <- system.file('examples/shiny', package = '$PKG')
if (!nzchar(app_dir)) stop('Demo app not found in package $PKG')
shiny::runApp(app_dir, port = $PORT, host = '$HOST', launch.browser = $BROWSER)
"
