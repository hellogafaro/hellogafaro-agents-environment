# Accounts API

The live API is `https://accounts.ongafaro.com`. Override it only when explicitly targeting another deployed environment.

## Authentication

Set the bearer token in the host environment, secret store, or consumer project's uncommitted `.env`:

```env
HELLOGAFARO_ACCOUNTS_BEARER_TOKEN=...
```

Optional overrides:

```env
HELLOGAFARO_ACCOUNTS_URL=https://accounts.ongafaro.com
HELLOGAFARO_ACCOUNTS_ENV_FILE=/absolute/path/to/.env
```

Never print, commit, or send the token to a provider. Use any available HTTP client and send it only to the Accounts API:

```http
Authorization: Bearer {HELLOGAFARO_ACCOUNTS_BEARER_TOKEN}
```

## Accounts

List accounts when the account id is unknown:

```http
GET /accounts
```

Read one account:

```http
GET /accounts/{account_id}
```

## Provider requests

Send provider-native operations through the proxy endpoint:

```text
POST /accounts/{account_id}/{provider}
```

Request envelope:

```json
{
  "method": "GET",
  "url": "/provider-relative/path",
  "params": {},
  "body": {}
}
```

Example:

```http
POST /accounts/{account_id}/shopify
Content-Type: application/json

{"method":"POST","url":"/admin/api/{api_version}/graphql.json","body":{"query":"query { shop { name } }"}}
```

Supported provider ids are `shopify`, `klaviyo`, `meta-ads`, `google-ads`, `tiktok-ads`, `posthog`, `google-analytics`, and `google-search-console`.

Use only provider-relative URLs. The Accounts API owns provider credentials, authentication headers, token refresh, request validation, retries, and response redaction.

Successful provider responses use this envelope:

```json
{
  "account": "account-id",
  "platform": "provider",
  "method": "GET",
  "url": "/provider-relative/path",
  "response": {}
}
```

Treat `401`, `403`, `404`, `429`, and provider `502` responses as source failures. Do not bypass the API with provider credentials.
