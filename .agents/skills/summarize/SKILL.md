---
description: Use when the user asks for a summary, wrap-up, recap, completion note, PM handoff summary, or what was done after an agent task across engineering, marketing, operations, analysis, documentation, or any other work.
metadata:
    github-path: skills/summarize
    github-ref: refs/heads/main
    github-repo: https://github.com/hellogafaro/hellogafaro-skills
    github-tree-sha: 7812624f85a501a44fd1ab53d40ba903b67bb118
name: summarize
---
# summarize

Create a concise natural-text completion summary the user can forward to a project manager without cleanup.

## Core rules

- Do not add a title or heading.
- Write in natural prose, not a report template.
- Keep the layout tight: usually two to four short paragraphs, or compact bullets only when many repos, commits, PRs, or deliverables must be listed.
- Include only meaningful work completed, delivered, or verified.
- Include all commits, PRs, repositories, deliverables, and QA that matter.
- Include every commit with short hash and message when commits were made.
- Include every PR with number or URL when PRs were opened or updated.
- Mention GitHub repositories by owner/name, not local filesystem paths, unless the local path is the deliverable.
- Put the temporary handoff task Markdown file or URL near the end in its own sentence when one was created.
- Name temporary handoff files in kebab case with the task slug and timestamp so they are unique, such as `/tmp/task-id-short-task-slug-20260616-1430.md`.
- End with a concise tracked-time sentence, rounded to 15-minute increments, such as `Add 1 hour of tracked time for this work.` Follow the tracked-time calibration below.
- Do not pad the time estimate with generic phrases like `capable human doing this end to end`, hypothetical wording like `would have taken`, or a repeated list of the work.
- Use only generic placeholder content in examples, filenames, and sample wording. Do not include real client names, task ids, repositories, URLs, people, or project details in the skill itself.
- Do not mention irrelevant dirty files, generated metadata, local cache files, or files intentionally left untouched unless they affect the handoff.
- Do not include tool noise, command transcripts, process narration, or generic caveats.
- Do not say what was not done unless it changes the project manager's next step.
- Do not bury the actual deliverable under diagnosis detail. Summarize the finding only as much as needed for the PM to understand what changed and what remains open.

## Tracked-time calibration

Estimate active, billable hands-on time for a competent senior who is already familiar with the client, repository, tooling, and established patterns.

- Estimate the incremental work completed, not the cost of rebuilding the deliverable from scratch.
- Do not infer time from lines changed, files touched, test count, validation breadth, conversation length, or the number of agent steps.
- Do not count agent exploration, retries, tool latency, regenerated previews, or repeated feedback turns as full human labor. Count only the equivalent focused human work that was necessary.
- Credit reuse of existing architecture, helpers, fixtures, conventions, and prior context instead of pricing the work as greenfield implementation.
- Internally sanity-check the estimate across orientation, implementation, QA, and handoff, but output only the final total unless the user asks for the breakdown.
- Do not add speculative contingency, project-management overhead, or replacement-cost padding.
- Treat a user-provided or user-corrected estimate as the strongest calibration for the current task and similar future work unless the scope materially differs.

## Source review

Before writing, review the live state that can change the summary:

- Git status, recent commits, pushed branch, and PR state for code work.
- Created or updated Notion tasks, docs, reports, dashboards, decks, spreadsheets, or other deliverables.
- QA actually run, including tests, builds, lint, screenshots, previews, data checks, or review steps.
- Any temporary handoff task Markdown file created for the user or next agent.
- The final URL or filesystem path of any handoff/time document, if one exists.

If a source is blocked, say only the blocked source and why it matters.

## Output shape

Default order:

1. What was delivered.
2. Where it landed, including repository, branch, commits, PRs, or durable artifact links.
3. QA or verification run.
4. Handoff task Markdown file path if created.
5. Any real blocker or next project-manager action.
6. Tracked-time estimate as the final sentence.

Keep the answer compact. The goal is accurate handoff, not a diary.
