---
description: Use when the user wants a concise context-rich handoff they can copy and send to a human or AI, with a separate file only when the required context is too large for a practical message.
metadata:
    github-path: skills/handoff
    github-ref: refs/heads/main
    github-repo: https://github.com/hellogafaro/hellogafaro-skills
    github-tree-sha: 6a9e263426a3a20c8d14b2f7cd1abaabfd198bb4
name: handoff
---
# handoff

Create one concise text handoff that lets someone else act without rediscovering the important context.

## Gather context

- Resolve the real outcome behind the ask.
- Inspect every available relevant live source before writing. This may include the canonical Notion task and its relations, project documents, repositories, issues, pull requests, communication threads, meetings, attachments, prior decisions, and current work state.
- Follow links to canonical sources and prefer current source state over summaries or memory.
- Include the canonical Notion task URL when one exists, plus any source URL needed to understand, continue, or complete the work.
- Keep only context that prevents rediscovery or wrong work: why the request exists, current state, prior work, decisions, constraints, required assets, expected result, and what meaningful completion looks like.
- Verify uncertain facts instead of presenting guesses as context. Ask one concise question only when missing information materially changes the handoff.
- Never include credentials, secrets, unrelated private context, tool noise, or a dump of every source inspected.

## Write the handoff

- Write one universal handoff. Do not create separate human, AI, or agent variants or ask who will receive it.
- Lead with the desired outcome, then provide the minimum context and links needed to act well.
- Use natural prose rather than a rigid template. Keep simple handoffs as short as two sentences and use a few short paragraphs only when needed.
- Include constraints, deliverables, current state, and completion conditions only when they clarify the work. Do not pad with generic instructions or obvious process.
- Use raw URLs and no Markdown formatting inside the handoff.
- Return exactly one fenced `text` code block and nothing else.
- Do not execute or send the handoff, create a task, or change source records unless separately asked.

## Overflow

- Keep the handoff text-based by default. Do not create a file merely because the work is complex.
- Create a short Markdown file in the OS temp directory only when the material context cannot fit into a practical message without losing execution-critical detail and the host can provide a usable file.
- Put detailed continuation state in the file, reference existing artifacts instead of duplicating them, and keep secrets out.
- Return a compact `text` code block with the actionable summary and the file path so the user can send or attach it.

Use `summarize` instead when the goal is to report completed work rather than ask someone to act or continue.
