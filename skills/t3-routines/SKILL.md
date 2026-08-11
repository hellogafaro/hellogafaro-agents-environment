---
description: Use when creating, changing, running, inspecting, or troubleshooting reliable scheduled T3 Code routines, including one-time and recurring work, retries, existing threads, and service recovery.
metadata:
    environment-scope: t3-code
name: t3-routines
---
# t3-routines

Manage scheduled T3 Code work through the routines CLI.

This skill requires the routines runtime and its `index.ts` CLI to be installed
separately. If no routines project is present, report that the scheduler runtime
is not configured instead of inventing commands or state.

## Hard rules

- Find the routines project and run its `index.ts` CLI from that project root.
- Use the CLI for every mutation. Never edit `db.sqlite3` directly.
- Read the routine before changing, deleting, disabling, or manually running it.
- Use only a provider and model currently available in the target T3 Code service.
- Discover live project and thread IDs with `targets`. Never guess, copy an unverified ID from unrelated context, or ask the user to find an ID the CLI can resolve.
- Whenever a thread ID is printed or reported, print its live owning project ID beside it. Do not add project title, workspace root, or other routing metadata unless needed for discovery or troubleshooting.
- Treat omitted `thread-id` as a request for a new thread in `project-id` or the configured default project. A supplied `thread-id` always continues that thread in its owning project; do not also supply `project-id`.
- Treat the routine name as the exact new-thread title and the prompt as exact dispatched text. Optimize both before creation; neither is automatically rewritten by the scheduler.
- Preserve inbox visibility. Before continuing an archived thread, the dispatcher must unarchive it. Starting the turn must unsnooze and unsettle it through T3's native activity behavior.
- Treat T3 acceptance as dispatch completion, not proof that the agent finished its work.
- Never print, copy, or expose the T3 bearer token.
- Do not edit the systemd unit, auth environment, or database unless troubleshooting proves it necessary and the user approves the change.

## Workflow

1. Locate the routines project by finding the `index.ts` whose help identifies the routines commands.
2. Read [references/commands.md](references/commands.md) before constructing a command.
3. For schedule semantics, read [references/schema-and-scheduling.md](references/schema-and-scheduling.md).
   Read [common examples](references/examples.md) when translating natural-language timing or routing into a command.
4. Run `bun run index.ts get` and inspect the current state before a mutation.
5. Run `bun run index.ts targets` with the narrowest known project or thread filter. Match projects by title and workspace root, then verify every selected ID from the live result.
6. Choose exactly one routing mode: new thread in an explicit project, new thread in the default project, or an existing thread. Use the routing matrix in [commands](references/commands.md).
7. Write a concise, specific outcome title. Write a self-contained prompt with objective, relevant context, permitted tools, constraints, and observable completion criteria. Do not add facts or permissions the user did not provide.
8. Validate the local start time, IANA timezone, RRULE, provider, model, and selected route.
9. Execute the smallest CLI mutation that satisfies the request.
10. Read the resulting routine and relevant runs to verify persisted state. Never report a thread ID alone: include its live owning project ID. For a new thread, use the run's returned thread ID with `targets` after dispatch. Confirm lifecycle fields only when inbox visibility is relevant.
11. If execution or service health fails, follow [references/troubleshooting.md](references/troubleshooting.md).

## Safety boundary

Creating, updating, deleting, enabling, disabling, or manually running a routine changes durable local state. Make the requested change only when the target and schedule are explicit. Ask one precise question when either is ambiguous.
