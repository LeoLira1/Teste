#!/usr/bin/env bash
set -euo pipefail

# The repository keeps Flutter source files small and reproducible. This helper
# creates the generated Android host project whenever the android/ directory is
# absent, which is useful for a fresh clone and for GitHub Actions runners.
if [ ! -d android ]; then
  flutter create . \
    --platforms=android \
    --org com.mapa.prateleiras \
    --project-name mapa_prateleiras
fi
