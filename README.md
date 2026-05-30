# QnapVaultwarden

Self-hosted [Vaultwarden](https://github.com/dani-garcia/vaultwarden)
(Bitwarden-compatible) password vault on QNAP. VPN-only access.

## Stack

- `vaultwarden`: Bitwarden-compatible server, SQLite backed.
- `caddy`: TLS reverse proxy with an internal self-signed CA.

Reachable at `https://qnap.local:8443` once your devices trust the Caddy CA
(see [docs/mobile-setup.md](docs/mobile-setup.md)).

## Quick Start

```bash
cp -n .env.example .env

# Generate an Argon2 admin token (paste output into .env as ADMIN_TOKEN):
docker run --rm -it vaultwarden/server /vaultwarden hash

docker compose up -d
```

Then:

1. Open `https://qnap.local:8443` and accept the cert warning *once* on the
   QNAP host (it will be replaced after you install the Caddy root CA).
2. Create your account.
3. Set `SIGNUPS_ALLOWED=false` in `.env` and `docker compose up -d` to
   re-apply.
4. Follow [docs/mobile-setup.md](docs/mobile-setup.md) on each device.

Configuration and Vault-stored secrets layout: [docs/vaultwarden.md](docs/vaultwarden.md).

## Backups

```bash
./scripts/backup.sh
```

Snapshots the SQLite DB hot and tars the `data/` directory into
`backups/vaultwarden-YYYYMMDD-HHMMSS.tar.gz`. Keeps 30 days.
