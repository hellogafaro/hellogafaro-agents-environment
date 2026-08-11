#!/bin/sh

# T3 probes PATH with `-ilc`. Containers have no controlling TTY, so Bash
# emits job-control warnings. A login shell is sufficient for this probe.
if [ "${1:-}" = "-ilc" ]; then
  shift
  exec /bin/bash -lc "$@"
fi

exec /bin/bash "$@"
