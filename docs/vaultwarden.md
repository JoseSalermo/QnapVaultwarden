# Vaultwarden Setup Notes

## Prerequisites

- HomelabInfra `homelab` docker network is up.
- HashiCorp Vault is running and unsealed.
- VPN access to the QNAP is configured (no public exposure).

## Vault secret layout

Store deployment secrets in the homelab Vault at `secret/vaultwarden/config`:

| Key             | Source / how to generate                                    |
|-----------------|-------------------------------------------------------------|
| `admin_token`   | `docker run --rm -it vaultwarden/server /vaultwarden hash`  |
| `smtp_host`     | e.g. `smtp.gmail.com`                                       |
| `smtp_from`     | sending address                                             |
| `smtp_username` | SMTP user                                                   |
| `smtp_password` | app password (not your account password)                    |

Read them into the deployment `.env`:

```bash
vault kv get -format=json secret/vaultwarden/config \
  | jq -r '.data.data | to_entries[] | "\(.key | ascii_upcase)=\(.value)"'
```

## Admin panel

Once the stack is up, the admin UI is at:

```text
https://qnap.local:8443/admin
```

Paste the **plaintext** admin password you hashed for `ADMIN_TOKEN`.
Use the admin panel for diagnostics, invitations, and user management.

## First-account / lockdown sequence

1. Start with `SIGNUPS_ALLOWED=true` in `.env`.
2. `docker compose up -d`.
3. Create your account at `https://qnap.local:8443`.
4. Set `SIGNUPS_ALLOWED=false`.
5. `docker compose up -d` again.
6. Invite additional users (family) via the admin panel.

## Healthcheck

Vaultwarden exposes `/alive` which the compose healthcheck pings every minute.

## Updating

```bash
docker compose pull
docker compose up -d
```

Restore data from `backups/` if anything goes sideways.
