# Publication review

Reviewed on 2026-10-26 against the single workflow attachment available from the referenced conversation. The previously mentioned sanitized GitHub starter files were not accessible and are not covered by this review. This repository scaffold was prepared anew.

## Findings and changes

- No embedded API keys, access tokens, passwords, or actual customer records were identified in the inspected export. Credential references are not credential secrets, but were removed from both public copies.
- Replaced the Google spreadsheet URL/ID and cached sheet URL with a setup placeholder.
- Replaced the Telegram recipient chat ID and Slack channel name with placeholders.
- Removed workflow ID, version ID, instance metadata, and webhook IDs.
- Pinned execution data is empty and both templates remain inactive.
- Internal node IDs remain to preserve structure; these are not account or customer identifiers.

The preserved variant retains all 11 nodes, connections, prompts, expressions, model choice, parser configuration, and node versions. A local comparison restored only the sanitized fields and confirmed equality with the source. The source file hash remained unchanged.

The default variant removes only the Slack node and its outgoing connection, then connects Gmail directly to the existing priority check. It retains 10 nodes. This is an explicitly requested additional variant, not an edit to the working original.

## Runtime review still required

The parser uses manual schema mode with an example-shaped JSON object. It was preserved as supplied; confirm it actually enforces the six intended fields in your n8n version. Do not interpret static validation as proof of parser correctness.

Verify the agent performs the order-reference lookup, correctly handles missing or duplicate references, and does not reveal unrelated case data. The matching order reference alone is not customer authentication. Verify spreadsheet output fields feed Gmail and the priority branch correctly. In the Slack variant, a Slack failure may prevent the downstream priority check from running.

No connected n8n execution, external account access, or GitHub publication was performed during this review. Static inspection and pattern checks reduce publication risk but are not an exhaustive guarantee against every possible sensitive value.
