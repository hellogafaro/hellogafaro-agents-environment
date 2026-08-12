# Shopify

Research the current [Shopify Admin API documentation](https://shopify.dev/docs/api/admin-graphql) and [versioning guidance](https://shopify.dev/docs/api/usage/versioning) before every new request.

Prefer Admin GraphQL unless the official documentation specifically requires REST. Verify API version, required access scope, resource availability, GraphQL cost or REST rate limit, pagination cursor, and deprecation status. For writes, inspect the mutation's `userErrors` and confirm idempotency guidance.
