# System Information Updates

## Grid Editing

This applies to every container, external systems, personas, and relationships grid in the information gathering process. 
The user may edit a grid in any of the following ways:

### Inline corrections

The user may describe a change in plain language:
- "Change the technology for Orders API to Java"
- "Remove the Dead Letter Queue row"
- "Add a row: Notification Service, Node.js"

Apply the described change, re-present the full updated grid, and wait for
confirmation.

### Paste from Markdown or pipe-separated text

The user may paste pipe-separated rows directly — for example, copied from a
Markdown table or typed manually:

```
Orders API        | Node.js
Customer Database | PostgreSQL
Event Bus         | Apache Kafka
```

Parse each row using `|` as the delimiter. Map columns positionally against
the current grid's column order. If the column count doesn't match or the
order is ambiguous, show the inferred mapping and ask the user to confirm
before applying.

### Paste from Excel or Google Sheets

The user may copy a cell range from Excel or Google Sheets and paste it. The
content arrives as tab-separated values. Parse each row using tabs as the
delimiter. If the pasted content includes a header row, use header names to
map columns (case-insensitive) rather than position. If no header row is
present, map positionally and confirm the mapping before applying.

### Paste an image

The user may upload a screenshot or photo of a spreadsheet, table, or
handwritten list. Extract all visible rows and columns. Map columns by header
name if headers are present; otherwise map positionally and confirm the
mapping before applying. Flag any cells that are illegible or ambiguous.

### Merge behaviour (all input methods)

After parsing any bulk input:

- If a row's name matches an existing grid entry (case-insensitive), treat it
  as an **update** — replace the existing row's values with the new ones.
- If the name does not match any existing entry, treat it as an **add**.
- Rows already in the grid that are not present in the pasted input are
  **left unchanged** — bulk input is additive/updating, not a full replace,
  unless the user explicitly says "replace everything".

### Value Stream inference on paste

When pasted or uploaded rows do not include a Value Stream column, infer the
Value Stream automatically for each row using the **Value Stream Reference**
table. Default to `External` when no alias matches. Show the inferred values
in the re-presented grid so the user can verify them before confirming.

### After any edit

Re-present the complete updated grid. Do not proceed to the next step until
the user explicitly confirms.

---