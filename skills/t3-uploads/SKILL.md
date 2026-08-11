---
name: t3-uploads
description: Use when a user explicitly asks for an agent-generated local file to be shared through a temporary direct-download link from T3 Code.
metadata:
  environment-scope: t3-code
---

# T3 uploads

Publish a local file through tmpfiles.org and return a temporary direct-download
link.

Run:

```bash
bun run <skill-dir>/scripts/t3-uploads.ts --file /absolute/path/to/file
```

Share the returned `directUrl`, not a landing-page URL. The service is external:
anyone with the URL can download the file until it expires.

Use this only when the user explicitly requests a downloadable link. Never upload
secrets, credentials, private keys, or personal data without explicit permission
for that exact file. Do not retry an uncertain upload automatically because the
first request may already have published it.
