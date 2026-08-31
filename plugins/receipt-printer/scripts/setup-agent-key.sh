#!/bin/bash

set -u

KEYCHAIN_SERVICE="engineering.felt.receipt-printer.agent-key"
KEYCHAIN_LABEL="Felt Receipt Printer Agent Key"
MCP_ENDPOINT="https://felt.engineering/api/mcp"

usage() {
  /usr/bin/printf '%s\n' \
    "Store a print-only Felt Receipt Printer Agent key in macOS Keychain." \
    "" \
    "Usage:" \
    "  setup-agent-key.sh          securely prompt for and verify an Agent key" \
    "  setup-agent-key.sh --status report whether a valid-looking key is stored" \
    "  setup-agent-key.sh --help   show this help"
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi
if [[ "$(/usr/bin/uname -s)" != "Darwin" ]]; then
  /usr/bin/printf '%s\n' "This setup helper currently supports macOS only." >&2
  exit 78
fi

keychain_account="$(/usr/bin/id -un)"

if [[ "${1:-}" == "--status" ]]; then
  if stored_key="$(/usr/bin/security find-generic-password \
      -a "$keychain_account" -s "$KEYCHAIN_SERVICE" -w 2>/dev/null)" &&
      [[ "$stored_key" =~ ^apk_[0-9a-f]{48}$ ]]; then
    /usr/bin/printf '%s\n' "A valid-looking Receipt Printer Agent key is stored in macOS Keychain."
    exit 0
  fi
  /usr/bin/printf '%s\n' "No valid Receipt Printer Agent key is stored in macOS Keychain."
  exit 1
fi
if [[ $# -ne 0 ]]; then
  usage >&2
  exit 64
fi

/usr/bin/printf '%s\n' \
  "Paste the apk_… Agent key when macOS prompts for the new Keychain password." \
  "The key will not be echoed or written to shell history."

# Leaving -w as the final option makes the security tool prompt securely instead
# of placing the secret in this process's command-line arguments.
if ! /usr/bin/security add-generic-password \
    -a "$keychain_account" \
    -s "$KEYCHAIN_SERVICE" \
    -l "$KEYCHAIN_LABEL" \
    -D "application password" \
    -U -w; then
  /usr/bin/printf '%s\n' "The Agent key was not saved." >&2
  exit 1
fi

agent_key="$(/usr/bin/security find-generic-password \
  -a "$keychain_account" -s "$KEYCHAIN_SERVICE" -w 2>/dev/null)"
if [[ ! "$agent_key" =~ ^apk_[0-9a-f]{48}$ ]]; then
  /usr/bin/printf '%s\n' \
    "The saved value is not an Agent key. It must start with apk_ and contain 48 hexadecimal characters." \
    "Run this setup command again and paste the Agent key created in the admin page." >&2
  exit 1
fi

probe='{"jsonrpc":"2.0","id":"setup-check","method":"tools/list"}'
if ! /usr/bin/printf '%s' "$probe" |
    /usr/bin/curl --silent --show-error --fail \
      --request POST \
      --header 'Content-Type: application/json' \
      --header 'Accept: application/json' \
      --header @/dev/fd/3 \
      --data-binary @- \
      --output /dev/null \
      "$MCP_ENDPOINT" \
      3<<<"Authorization: Bearer ${agent_key}"; then
  /usr/bin/printf '%s\n' \
    "The key was saved, but the print service could not verify it." \
    "Confirm that it is an active Agent key, then run this command again if needed." >&2
  exit 1
fi

unset agent_key
/usr/bin/printf '%s\n' \
  "Receipt Printer Agent key saved and verified." \
  "Restart Codex and begin a new task before testing the plugin."
