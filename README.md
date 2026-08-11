# Hello Gafaro agent environment

Persistent T3 Code server for Hello Gafaro, deployed on Railway and exposed only through T3 Connect.

## Architecture

- Railway builds the root `Dockerfile`.
- T3 binds to loopback; the Railway service has no public or custom domain.
- T3 Connect creates the authenticated outbound managed tunnel.
- One Railway volume mounted at `/data` preserves server state and workspaces.
- Infisical Universal Auth provides repository secrets through short-lived tokens.

## Persistent data

| Path | Contents |
| --- | --- |
| `/data/.t3` | T3 Code and T3 Connect state |
| `/data/.codex` | Codex authentication and configuration |
| `/data/workspaces` | Checked-out repositories |

## Railway variables

| Name | Value |
| --- | --- |
| `HOME` | `/data` |
| `T3CODE_HOME` | `/data/.t3` |
| `CODEX_HOME` | `/data/.codex` |
| `INFISICAL_DOMAIN` | `https://secrets.ongafaro.com` |
| `INFISICAL_API_URL` | `https://secrets.ongafaro.com` |
| `INFISICAL_DISABLE_UPDATE_CHECK` | `true` |
| `INFISICAL_CLIENT_ID` | Machine Identity client ID |
| `INFISICAL_CLIENT_SECRET` | Machine Identity client secret |

Add credentials directly in Railway. Never commit them.

## Initial authorization

Run these once through `railway ssh`:

```bash
t3 connect login --headless
t3 connect link
codex login
```

Check the connection without exposing credentials:

```bash
t3 connect status --json
codex login status
```

## Infisical

Exchange the Machine Identity credentials for a short-lived token in each shell that needs secrets:

```bash
export INFISICAL_TOKEN="$(infisical login \
  --method=universal-auth \
  --client-id="$INFISICAL_CLIENT_ID" \
  --client-secret="$INFISICAL_CLIENT_SECRET" \
  --silent \
  --plain)"
```

Each product repository owns its `.infisical.json` project mapping. Run `infisical run -- <command>` from that repository.
