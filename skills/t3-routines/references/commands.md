# Commands

Run commands from the routines project root.

```bash
bun run index.ts get
bun run index.ts get ROUTINE_ID
bun run index.ts runs ROUTINE_ID
bun run index.ts targets
bun run index.ts targets --project-id PROJECT_ID
bun run index.ts targets --thread-id THREAD_ID
bun run index.ts examples
```

Use `targets` before constructing a mutation. It merges T3's active and archived shell snapshots and returns project IDs with titles and workspace roots, plus thread IDs with titles, owning projects, turn state, archive state, settlement state, snooze state, and update time. Match a project by both human title and workspace root. A thread filter also returns its owning project, including when that thread is archived and absent from the active inbox. A failed filtered result is a hard stop; never invent an ID.

Never present a thread ID by itself in an operator-facing result. Print only its live owning project ID beside it unless more detail is needed for discovery or troubleshooting. Do not copy that project ID into `--project-id` when `--thread-id` is the route.

Routine output always includes both fields for a stable JSON schema. Null values mean no stored override:

```json
{ "projectId": null, "threadId": null }
```

In that case, the dispatcher reads `default_project_id` from the routines project's `config.toml` at run time and creates a new chat there.

An explicit new-chat project prints:

```json
{ "projectId": "PROJECT_ID", "threadId": null }
```

For an existing thread it adds only the thread ID:

```json
{ "projectId": "PROJECT_ID", "threadId": "THREAD_ID" }
```

The presence of a non-null `threadId`, not `projectId`, distinguishes an existing chat. Two nulls mean the configured default project, not a missing destination. There is no routing wrapper.

Use `examples` for ready-to-adapt commands and RRULEs covering common schedules. See [common examples](examples.md) for the same material with authoring guidance.

## Routing matrix

| Thread ID | Project ID | Result |
| --- | --- | --- |
| omitted | supplied | Create a new chat in that project on every run. |
| omitted | omitted | Create a new chat in `default_project_id` on every run. |
| supplied | omitted | Continue that existing chat and preserve its project and title. |
| supplied | supplied | Rejected by create/update. For a legacy row, the thread wins at runtime; clear the project ID. |

For a new chat, `--name` becomes its exact title. For an existing chat, `--name` labels only the routine and does not rename the chat. The scheduler sends `--prompt` verbatim in both modes.

Before an existing-thread turn, the dispatcher reads live thread state. It explicitly unarchives an archived thread. T3 turn activity automatically unsnoozes and unsettles the thread. After dispatch, verify all three lifecycle fields with `targets --thread-id THREAD_ID`. Projects have existence and workspace identity, but no thread-style archive lifecycle.

Before saving, make the title short, distinctive, and outcome-oriented. Make the prompt self-contained: state the objective, relevant context and identifiers, allowed tools or sources, safety constraints, and a verifiable completion report. Preserve the user's intent and authority; optimization is clarification, not scope expansion.

Create a one-time routine by omitting `--rrule`:

```bash
bun run index.ts create \
  --name "NAME" \
  --prompt "PROMPT" \
  --dtstart "2026-08-07T09:00:00" \
  --timezone "Europe/Berlin" \
  --provider "PROVIDER" \
  --model "MODEL" \
  --project-id "PROJECT_ID"
```

Create a recurring routine with an RFC 5545 RRULE:

```bash
bun run index.ts create \
  --name "NAME" \
  --prompt "PROMPT" \
  --dtstart "2026-08-07T09:00:00" \
  --timezone "Europe/Berlin" \
  --rrule "FREQ=WEEKLY;BYDAY=MO,WE,FR" \
  --provider "PROVIDER" \
  --model "MODEL" \
  --thread-id "THREAD_ID"
```

Update only supplied fields:

```bash
bun run index.ts update ROUTINE_ID --status disabled
bun run index.ts update ROUTINE_ID --status enabled
bun run index.ts update ROUTINE_ID --dtstart "2026-08-08T10:00:00" --timezone "Europe/Berlin"
bun run index.ts update ROUTINE_ID --rrule "FREQ=DAILY"
bun run index.ts update ROUTINE_ID --rrule ""
bun run index.ts update ROUTINE_ID --project-id "PROJECT_ID"
bun run index.ts update ROUTINE_ID --project-id ""
bun run index.ts update ROUTINE_ID --thread-id ""
```

Run immediately or delete:

```bash
bun run index.ts run ROUTINE_ID
bun run index.ts delete ROUTINE_ID
```

`run` creates a manual run without moving the recurring schedule cursor. Mutations notify the running scheduler to recalculate immediately.

When `thread-id` is present, T3 uses that existing thread and ignores project routing. Without `thread-id`, each run creates a new thread in `project-id` or the `default_project_id` from `config.toml`.

After a manual or scheduled dispatch, take the run's `threadId` and run `targets --thread-id THREAD_ID`. This verifies the visible chat title and actual project placement. A completed run means T3 accepted the turn; it does not prove the model finished.

Use `bun run index.ts auth` only to issue or replace the scheduler token. It restarts the service and must never be followed by printing the environment file.
