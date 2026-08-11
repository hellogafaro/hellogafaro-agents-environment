# Troubleshooting

Start with read-only checks:

```bash
systemctl --user status t3-routines.service --no-pager
journalctl --user -u t3-routines.service -n 100 --no-pager
bun run index.ts get
bun run index.ts runs ROUTINE_ID
sqlite3 db.sqlite3 'PRAGMA integrity_check;'
sqlite3 db.sqlite3 'PRAGMA foreign_key_check;'
```

Interpret failures in this order:

1. Confirm the routine is enabled and its schedule is still due.
2. Read the latest run status, retries, and error.
3. Confirm the provider and model remain available in T3 Code.
4. For a new thread, run `targets --project-id PROJECT_ID` and confirm the routine project override or configured default project by title and workspace root.
5. If using an existing thread, run `targets --thread-id THREAD_ID`; confirm that it exists in the merged active/archived target result and note its actual owning project, title, `archivedAt`, `settledAt`, and `snoozedUntil`. Any stored routine project ID is ignored in this mode. An archived thread must remain discoverable even though it is absent from T3's active inbox snapshot.
6. Check the service and recent structured logs.
7. Check database integrity without modifying it.

If authentication is explicitly the failure, run:

```bash
bun run index.ts auth
```

Do not display the auth environment file or token. Do not delete failed runs, rewrite timestamps, or edit database rows to force recovery. Use the CLI to update the routine or trigger a manual run after the cause is understood.

Restarting the service is safe after diagnosis:

```bash
systemctl --user restart t3-routines.service
```

After recovery, verify the service is active and inspect the latest run. Remember that `completed` confirms dispatch acceptance only.

If a completed run seems invisible, do not immediately rerun it. Inspect the run's `threadId` with `targets --thread-id THREAD_ID`. Confirm the owning project and lifecycle fields. The usual causes are looking in the wrong project, confusing the routine name with an existing thread title, assuming a stored project override applies when a thread ID is also present, or targeting a thread that was archived before lifecycle revival was supported.
