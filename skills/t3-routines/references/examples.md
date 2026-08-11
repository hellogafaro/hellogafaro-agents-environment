# Common examples

Run `bun run index.ts examples` for compact CLI examples. Use the patterns below when translating a request into a complete routine.

## Routing examples

### One time in the default project

Omit both routing flags. This stores both IDs as null. At run time the dispatcher reads `default_project_id` from the routines project's `config.toml`, creates a new chat there, and uses the routine name as its title.

```bash
bun run index.ts create \
  --name "Prepare launch brief" \
  --prompt "Prepare the launch brief from the current project files. Do not publish or message anyone. Report the completed file path and unresolved questions." \
  --dtstart "2026-08-08T09:00:00" \
  --timezone "Europe/Berlin" \
  --provider "PROVIDER" \
  --model "MODEL"
```

### One time in a specific project

Verify `PROJECT_ID` with `targets --project-id PROJECT_ID`. Omit the thread flag so the run creates a new titled chat.

```bash
bun run index.ts create \
  --name "Audit checkout errors" \
  --prompt "Audit recent checkout errors using the project context. Make no production changes. Report evidence, likely causes, and recommended next steps." \
  --dtstart "2026-08-08T10:00:00" \
  --timezone "Europe/Berlin" \
  --provider "PROVIDER" \
  --model "MODEL" \
  --project-id "PROJECT_ID"
```

### One time in an existing thread

Verify `THREAD_ID` with `targets --thread-id THREAD_ID`. Omit the project flag. The existing thread keeps its title and project. If archived, it is unarchived first. Turn activity unsnoozes and unsettles it.

```bash
bun run index.ts create \
  --name "Follow up on checkout audit" \
  --prompt "Continue the checkout audit. Recheck the previously identified failures and report what changed. Make no production changes." \
  --dtstart "2026-08-08T11:00:00" \
  --timezone "Europe/Berlin" \
  --provider "PROVIDER" \
  --model "MODEL" \
  --thread-id "THREAD_ID"
```

## Common recurrence rules

Add one of these `--rrule` values to a complete create command. `dtstart` supplies the local start time and anchors interval schedules.

| Request | RRULE |
| --- | --- |
| Every day | `FREQ=DAILY` |
| Every other day | `FREQ=DAILY;INTERVAL=2` |
| Every weekday | `FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR` |
| Monday, Wednesday, and Friday | `FREQ=WEEKLY;BYDAY=MO,WE,FR` |
| Every Monday | `FREQ=WEEKLY;BYDAY=MO` |
| Every two weeks on Monday | `FREQ=WEEKLY;INTERVAL=2;BYDAY=MO` |
| First day of every month | `FREQ=MONTHLY;BYMONTHDAY=1` |
| Last day of every month | `FREQ=MONTHLY;BYMONTHDAY=-1` |
| Last weekday of every month | `FREQ=MONTHLY;BYDAY=MO,TU,WE,TH,FR;BYSETPOS=-1` |
| Every three months on day 1 | `FREQ=MONTHLY;INTERVAL=3;BYMONTHDAY=1` |
| Every six hours | `FREQ=HOURLY;INTERVAL=6` |
| Every 30 minutes | `FREQ=MINUTELY;INTERVAL=30` |

Append `;COUNT=10` to stop after ten occurrences. Use an explicit UTC `UNTIL` only after converting the requested local deadline correctly.

## Title and prompt checklist

For a new thread, use a short title that distinguishes the result in the inbox. `Daily report` is vague. `Daily checkout failure summary` is specific.

The prompt is sent verbatim. Include:

- the exact objective;
- relevant project, account, URL, or file context;
- permitted tools and sources when important;
- explicit safety and mutation limits;
- what evidence to verify;
- the expected completion report.

Do not invent context, credentials, authority, recipients, or side effects while improving the prompt.

## Verification

After dispatch:

```bash
bun run index.ts runs ROUTINE_ID
bun run index.ts targets --thread-id THREAD_ID
```

Confirm the returned thread belongs to the expected project. For active inbox work, `archivedAt`, `settledAt`, and `snoozedUntil` should be null. A completed routine run proves dispatch acceptance, so inspect the thread or provider outcome when full task completion matters.

In every report, show `threadId` together with its owning `projectId`. Keep the output to those two identifiers unless more detail is needed for discovery or troubleshooting. The project value is verification metadata when continuing a thread, not an additional routing flag.
