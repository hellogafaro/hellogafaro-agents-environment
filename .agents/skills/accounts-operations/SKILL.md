---
description: Use when work needs connected client account data or provider-native reads and confirmed writes through Hello Gafaro Accounts for Shopify, Klaviyo, Meta Ads, Google Ads, TikTok Ads, PostHog, GA4, or Search Console.
metadata:
    github-path: skills/accounts-operations
    github-ref: refs/heads/main
    github-repo: https://github.com/hellogafaro/hellogafaro-skills
    github-tree-sha: ed61dfa44684792a6fb8f51a41d8a1451d2ec1e1
name: accounts-operations
---
# accounts-operations

Use the live authenticated Accounts API. This skill is self-contained and does not require an implementation repository checkout. Do not invent provider endpoints, fields, API versions, or limits.

## Workflow

1. Identify the client, account id, provider, operation, date window, and whether a write is requested.
2. Read [references/api.md](references/api.md), [references/edge-cases.md](references/edge-cases.md), and the needed provider reference below.
3. Browse the linked official provider documentation before constructing every new or changed operation. Treat checked-in references as routing and safety guidance, not an API catalog.
4. List accounts when the account id is unknown. Use any available HTTP client. Read `HELLOGAFARO_ACCOUNTS_BEARER_TOKEN` from the environment, host secrets, or an uncommitted `.env` without printing it. `HELLOGAFARO_ACCOUNTS_URL` is optional and defaults to the live API.
5. Send provider-native calls through `POST /accounts/{account_id}/{provider}` with `{ method, url, params, body }`. Put no provider credentials, provider authorization headers, or absolute upstream URLs inside that request envelope.
6. Run the smallest read that answers the question. Perform a write only when the user explicitly asks and the operation is supported by the current official documentation.
7. Return provider, account id, official source, endpoint, date window, metric definition, result, and limitations.

## Provider references

- [references/api.md](references/api.md)
- [references/edge-cases.md](references/edge-cases.md)
- [references/shopify.md](references/shopify.md)
- [references/klaviyo.md](references/klaviyo.md)
- [references/meta-ads.md](references/meta-ads.md)
- [references/google-ads.md](references/google-ads.md)
- [references/tiktok-ads.md](references/tiktok-ads.md)
- [references/posthog.md](references/posthog.md)
- [references/google-analytics.md](references/google-analytics.md)
- [references/search-console.md](references/search-console.md)

## Hard rules

- Never call a provider directly with stored credentials or expose tokens, secrets, authorization headers, or account secrets.
- Reject unknown account ids, unsupported providers, absolute URLs, path traversal, and requests that attempt to supply provider authentication.
- Preserve upstream response semantics. Label sampling, thresholding, partial pages, stale data, and inferences.
- Prefer sparse fields, server-side filtering, cursor pagination, and month-by-month aggregation for long windows.
- Stop on authentication, authorization, missing credential, quota, or provider errors. Do not represent partial provider data as complete.
- Never clone or locate the Accounts implementation repository to operate the live API.
