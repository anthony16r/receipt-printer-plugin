# Receipt Printer plugin

Public Codex marketplace package for the Felt Engineering receipt printer. It gives
local Codex clients print-only tools plus receipt-formatting guidance. This repository
contains no printer credentials or private site source.

Each Mac uses its own revocable `apk_…` Agent key. The setup helper stores that key in
macOS Keychain; it is never written to Codex configuration, a URL, or this repository.

## Install on macOS

1. Create an **Agent** key at `https://admin.felt.engineering/print/` and copy the value
   shown once.
2. Store and verify it securely:

   ```sh
   /bin/bash <(/usr/bin/curl -fsSL https://raw.githubusercontent.com/anthony16r/receipt-printer-plugin/main/plugins/receipt-printer/scripts/setup-agent-key.sh)
   ```

3. Install the marketplace and plugin:

   ```sh
   codex plugin marketplace add anthony16r/receipt-printer-plugin --ref main
   codex plugin add receipt-printer@felt-engineering
   ```

4. Restart Codex and begin a new task.

For an existing installation, refresh and reinstall it with:

```sh
codex plugin marketplace upgrade felt-engineering
codex plugin add receipt-printer@felt-engineering
```

See [the plugin README](plugins/receipt-printer/README.md) for setup, update, and security
details. Browser-hosted ChatGPT/Codex and OAuth are intentionally unsupported.
