#!/usr/bin/env bash

set -euo pipefail

# Cursor runs this after pulling the repository. Keep it idempotent: its disk
# state is cached and it may run again whenever the environment starts or changes.
bash .cursor/install.sh
