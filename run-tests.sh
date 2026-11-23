#!/usr/bin/env bash
# Quick entrypoint for Recursive Cognition verification and quality gate runner
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

python3 run_tests.py "$@"
