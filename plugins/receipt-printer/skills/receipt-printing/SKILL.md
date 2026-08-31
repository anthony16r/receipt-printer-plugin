---
name: receipt-printing
description: Create a physical receipt-printer job from text, notes, lists, or receipt Markdown. Use when the user asks to print, make a receipt, send a note to the receipt printer, or format content for the thermal printer.
---

# Receipt printing

Use the `receipt-printer` MCP tools for this workflow.

## Print workflow

1. If exact formatting limits matter, call `get_receipt_capabilities` before composing.
2. Convert the user's content to the supported receipt Markdown dialect. Preserve their wording and intent; make only formatting changes unless they asked for editing.
3. Create a fresh, opaque `idempotency_key` for each intended physical copy. Reuse the same key only when retrying the exact same intended print after an uncertain result.
4. Call `print_receipt` once the request is concrete. A direct request to print is authorization to create the physical job; do not add a redundant confirmation.
5. Report the returned job ID and queue position. Do not claim the receipt has physically printed; the tool confirms only that the job was accepted.

## Safety and scope

- Printing is a physical side effect. If the user is only drafting, previewing, or asking how something would look, do not call `print_receipt`.
- Never print a second copy merely because a response was slow. Retry only with the original idempotency key.
- This plugin is print-only. Do not seek job history, saved receipts, personal templates, print keys, printer settings, or administrator data.
- Never request, display, store, or place printer credentials in receipt content, prompts, URLs, or files.
