# Schema and scheduling

## Routine fields

- `id`: Incrementing routine identifier.
- `name`: Human-readable label.
- `prompt`: Exact instruction sent to T3 Code.
- `dtstart`: Local date and time without a timezone suffix.
- `timezone`: IANA timezone such as `Europe/Berlin`.
- `rrule`: RFC 5545 recurrence rule without `RRULE:`. Null means one-time.
- `provider`: T3 Code provider identifier for this routine.
- `model`: T3 Code model identifier for this routine.
- `project_id`: Project override used when creating a thread. Null uses the configured default.
- `thread_id`: Existing T3 Code thread. Null creates a new thread for each run.
- `status`: `enabled` or `disabled`.

## Run fields

Runs use `pending`, `in_progress`, `completed`, or `failed`. `retries` counts retry attempts after the initial attempt. `error` contains the latest dispatch error when present.

`completed` means T3 Code accepted the turn. It does not guarantee that the model completed its work successfully. Verify the T3 thread when end-to-end completion matters.

## Schedule behavior

- A null RRULE produces one occurrence at `dtstart`.
- A new thread uses the routine project override or `default_project_id` from `config.toml`.
- An existing thread determines its own project, so project routing is ignored.
- Continuing an archived thread unarchives it before dispatch. Turn activity automatically clears snooze and settlement state so the work returns to the active inbox.
- An RRULE is evaluated from `dtstart` in `timezone` and follows local daylight-saving transitions.
- Disabled routines create no scheduled runs and receive no automatic retries.
- Manual runs are allowed independently of the recurrence cursor.
- The scheduler calculates the earliest due occurrence and sleeps until it, with a periodic safety wake. It does not use a five-minute polling loop.
- On restart, the scheduler derives due occurrences from durable SQLite state and resumes pending or interrupted work.
- Dispatch identifiers are deterministic per run so retries do not intentionally create duplicate T3 turns.

SQLite uses WAL mode, full synchronous writes, foreign keys, and a busy timeout. The service runs continuously under systemd and restarts after failure.

Delivery is at-least-once at the scheduler boundary. A crash at an external acknowledgement boundary can still require inspecting the T3 thread before deciding whether to run again.
