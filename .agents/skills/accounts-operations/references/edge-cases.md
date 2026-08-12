# Edge cases

Read this before provider work.

- Unknown account: list accounts; never guess an id.
- Multiple matching accounts: resolve with the user before querying.
- Missing credential, 401, or 403: report the source failure; do not retry with another account.
- New or changed call: research the current official API reference, version, scopes, request shape, response schema, pagination, quotas, and deprecations first.
- Long date range: split by month unless the current provider documentation recommends a stricter window; aggregate only compatible periods.
- Pagination: follow the provider's current cursor, page token, or offset contract until completion; state the stopping condition.
- Rate limit or transient failure: honor provider retry guidance; do not retry writes automatically unless the provider documents idempotency.
- Async job: create or trigger only with explicit approval, poll using the documented status operation, and report incomplete jobs as incomplete.
- Write: confirm target account, operation, scope, and current documentation. Prefer a provider dry run or validation mode when documented.
- Non-JSON or oversized response: confirm support in the Accounts proxy before sending; do not assume binary, multipart, streaming, or file upload behavior.
- Analytics result: report sampling, thresholding, attribution, timezone, currency, retention, data freshness, and comparison-window differences when relevant.
