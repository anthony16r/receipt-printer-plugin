# Receipt Printer plugin

This plugin gives ChatGPT and Codex two print-only MCP tools:

- `print_receipt` creates a physical receipt-printer job.
- `get_receipt_capabilities` returns the current receipt Markdown dialect and layout limits.

The plugin connects to `https://mcp.felt.engineering/api/mcp` using Cloudflare Access
Managed OAuth. Installation never asks for or stores a printer key. The OAuth identity
can create print jobs only; it cannot read job history, saved receipts, personal
templates, print keys, printer settings, or other administrator data.

## Install from the source marketplace

The plugin is published in a dedicated public repository. No access to the private
`felt.engineering` source repository is required:

```sh
codex plugin marketplace add anthony16r/receipt-printer-plugin --ref main
codex plugin add receipt-printer@felt-engineering
```

Restart or reload ChatGPT/Codex if prompted, then connect the Receipt Printer MCP
server. A browser window opens for the owner's Cloudflare Access login. Each computer
and ChatGPT account receives its own revocable OAuth grant; no secret is copied between
machines.

ChatGPT on the web can also connect `https://mcp.felt.engineering/api/mcp` directly as
a custom MCP plugin in developer mode. Codex can connect the same endpoint without
installing the bundled receipt-formatting skill:

```sh
codex mcp add receipt-printer --url https://mcp.felt.engineering/api/mcp
codex mcp login receipt-printer
```

A managed work account may require its workspace administrator to allow custom plugins.

## Owner deployment

1. In Cloudflare Zero Trust, create a self-hosted Access application for
   `mcp.felt.engineering`. Allow only the personal and work email addresses that should
   be able to create print jobs.
2. Under the application's Advanced settings, enable Managed OAuth and Dynamic Client
   Registration. Allow localhost and loopback redirect URIs for Codex. Add the exact
   HTTPS redirect URI shown by ChatGPT when connecting the custom MCP plugin.
3. Use a 5–15 minute access-token lifetime and a one- or two-week grant session.
4. Copy the application's Access audience tag. From the site repository, run
   `npx wrangler secret put MCP_POLICY_AUD` and paste the tag.
5. Run `npx wrangler secret put MCP_EMAILS` and enter the allowed email addresses as a
   comma-separated value. This is deliberately separate from `ADMIN_EMAIL`: an allowed
   work login receives print-only access, never administrator access.
6. Deploy the Worker route for `mcp.felt.engineering`, then connect the plugin and finish
   the browser login. The Worker fails closed if the audience or email secret is absent.

## Non-interactive agents

Automations that cannot complete a browser login should not use the plugin's OAuth
connection. Give each automation its own revocable `apk_…` Agent key and use
`https://felt.engineering/api/mcp` with `Authorization: Bearer <agent-key>`, or call the
print REST API. Agent keys are also print-only.
