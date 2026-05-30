# Trusting the Caddy CA on Clients

The Caddy reverse proxy issues vault certs from its own internal root CA.
Each device that talks to the vault needs to trust that CA *once*.

## 1. Export the Caddy root CA from the QNAP

```bash
docker compose cp caddy:/data/caddy/pki/authorities/local/root.crt ./caddy-root.crt
```

`caddy-root.crt` is a small PEM file you can safely send to your own devices
(AirDrop, email to yourself, file manager, etc.). It contains no private key.

## 2. Install on iOS

1. Send `caddy-root.crt` to the phone (AirDrop / email / Files).
2. Open the file → tap **Allow** → **Settings → General → VPN & Device
   Management** → tap the profile → **Install**.
3. **Settings → General → About → Certificate Trust Settings** → toggle the
   Caddy CA **on**.

## 3. Install on Android

1. Send `caddy-root.crt` to the phone.
2. **Settings → Security → Encryption & credentials → Install a certificate
   → CA certificate** → pick the file.
3. Confirm the warning. Some Android versions place it under **More security
   settings**.

## 4. Install on macOS

1. Double-click `caddy-root.crt` → **Keychain Access** opens.
2. Add to **System** keychain.
3. Double-click the imported cert → **Trust** → **Always Trust**.

## 5. Install on Windows

1. Double-click `caddy-root.crt` → **Install Certificate**.
2. Store location: **Local Machine** → **Trusted Root Certification
   Authorities**.

## 6. Point the Bitwarden client at your vault

1. Connect to the VPN.
2. Open the Bitwarden app → **Settings (gear icon on login screen) →
   Self-hosted environment**.
3. Server URL: `https://qnap.local:8443`.
4. Save, then log in normally.

Browser extensions: same — set the self-hosted URL before logging in.

## Troubleshooting

- **"Could not connect"** on the phone: confirm the VPN is up and that
  `qnap.local` resolves on the VPN-tunneled network. If not, replace with the
  QNAP IP in `DOMAIN` *and* the Caddyfile, then rebuild.
- **Cert still untrusted**: iOS Trust Settings toggle is the step people skip
  most often.
