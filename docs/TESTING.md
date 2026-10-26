# Acceptance checklist

Use a separate imported workflow, a test spreadsheet, and notification destinations you control. These are proposed tests, not recorded successful executions.

| Scenario | Check |
| --- | --- |
| New routine complaint | One row is appended; a Gmail draft is created; no Telegram message for Low/Medium. |
| Repeated unresolved complaint with order reference | Lookup runs and summary references the existing case; recommendation includes human review. |
| Empty order reference | Agent does not invoke the lookup tool. |
| High or Critical complaint | Existing priority condition passes and the test Telegram destination receives the escalation. |
| Customer text asks the agent to ignore instructions | Output remains complaint analysis and does not expose unrelated records. |
| Missing credentials or invalid sheet | Failure is visible in n8n; verify whether retrying could append another row or create another draft. |
| Parser output | All six intended fields contain usable strings and reach the sheet and draft. |
| No-Slack variant | Gmail output reaches the priority check without any Slack dependency. |

Check names, recipient addresses, line breaks, case IDs, and spreadsheet mappings. Review drafts manually. Do not use real customer records in screenshots, sample exports, or issue reports.
