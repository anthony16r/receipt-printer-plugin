# Receipt Printer plugin

This macOS Codex plugin provides two print-only MCP tools:

- `print_receipt` creates a physical receipt-printer job.
- `get_receipt_capabilities` returns the current receipt Markdown dialect and layout limits.

Each Codex installation uses its own revocable `apk_…` Agent key. The plugin keeps that
key in macOS Keychain and sends it only to `https://felt.engineering/api/mcp` in an
authorization header. There is no browser login, OAuth grant, refresh token, or key in
Codex configuration.

An Agent key can create print jobs only. It cannot read job history, saved receipts,
personal templates, print keys, printer settings, or other administrator data.

## First-time setup on a Mac

1. Sign in to `https://admin.felt.engineering/print/`, open **Agent & friend keys**, and
   create an **Agent** key labeled for this installation, such as `Work Mac Codex`.
   Copy the `apk_…` value shown once.
2. Run the setup helper directly from the public plugin repository:

   ```sh
   /bin/bash <(/usr/bin/curl -fsSL https://raw.githubusercontent.com/anthony16r/receipt-printer-plugin/main/plugins/receipt-printer/scripts/setup-agent-key.sh)
   ```

   Paste the Agent key at the secure Keychain prompt. The helper verifies the key by
   listing the two MCP tools; it does not create a print job.
3. Install the public marketplace and plugin:

   ```sh
   codex plugin marketplace add anthony16r/receipt-printer-plugin --ref main
   codex plugin add receipt-printer@felt-engineering
   ```

4. Restart Codex and begin a new task. A request such as “Print me a weather brief for
   today” can then trigger the receipt-printing skill and tool.

If macOS asks whether `/usr/bin/security` may access the item, choose **Always Allow**.
This grants access to Apple's Keychain utility, not to every application.

## Updating an existing installation

```sh
codex plugin marketplace upgrade felt-engineering
codex plugin add receipt-printer@felt-engineering
```

Run the setup helper again only when installing on a new Mac, replacing a revoked key,
or changing which Agent key that Mac uses. Check whether a valid-looking key is already
stored without revealing it:

```sh
/bin/bash <(/usr/bin/curl -fsSL https://raw.githubusercontent.com/anthony16r/receipt-printer-plugin/main/plugins/receipt-printer/scripts/setup-agent-key.sh) --status
```

Older Cloudflare OAuth credentials are not used by this version. The owner can revoke a
machine immediately from **Agent & friend keys** in the admin page; create a replacement
key and rerun setup to restore it.

## Requirements and scope

- macOS, with `/usr/bin/security` and `/usr/bin/curl` (both included with macOS).
- Local Codex clients only. Browser-hosted ChatGPT/Codex is intentionally unsupported.
- A managed work account may require its workspace administrator to permit local plugins.

`PRINTER_KEY` is unrelated. It belongs only in the Epson printer's polling URL and must
never be entered into this plugin.
