# Receipt Printer plugin

Public Codex marketplace package for the Felt Engineering receipt printer.
It gives ChatGPT and Codex print-only tools plus receipt-formatting guidance.
The repository contains no printer credentials or private site source.

## Install in Codex

```sh
codex plugin marketplace add anthony16r/receipt-printer-plugin --ref main
codex plugin add receipt-printer@felt-engineering
```

Restart or reload Codex if prompted, then complete the browser sign-in for the
Receipt Printer MCP connection.

## Connect without the package

ChatGPT developer mode can connect the remote MCP URL directly:

```text
https://mcp.felt.engineering/api/mcp
```

Codex can connect the same endpoint without installing the bundled skill:

```sh
codex mcp add receipt-printer --url https://mcp.felt.engineering/api/mcp
codex mcp login receipt-printer
```

## Authentication

Interactive plugin installs use OAuth. The resulting identity can create print
jobs but cannot access job history, saved receipts, personal templates, print
keys, printer settings, or administrator data.

Non-interactive agents can instead receive a separate revocable `apk_…` Agent
key and use the public print MCP endpoint with a bearer authorization header.
Each friend or automation should receive its own key.

See [the plugin README](plugins/receipt-printer/README.md) for deployment and
security details.
