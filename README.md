# CustomerCare AI

An n8n workflow for complaint triage, case tracking, and human-reviewed customer response drafts.

CustomerCare AI accepts a support request, uses an AI agent to classify the complaint and suggest next steps, records the case in Google Sheets, and creates a Gmail draft. High and Critical cases are routed to Telegram for review.

## Workflow

Form submission → AI analysis → field mapping → Google Sheets → Gmail draft → priority check → Telegram for High/Critical cases.

The agent has a read-only Google Sheets lookup tool for potential repeat complaints by order reference, an OpenAI chat model, and a structured output parser. The prompt instructs the agent to use the lookup when an order reference is supplied; this behavior needs runtime verification.

## Choose a version

| File | Purpose |
| --- | --- |
| `workflows/customercare-ai.json` | Default version without Slack; Gmail connects directly to the priority check. |
| `workflows/customercare-ai.with-slack.json` | Preserves the uploaded workflow's connections, including Slack before the priority check. |

Both exports are inactive templates. Credentials and deployment identifiers have been removed. They require configuration before use. The original private workflow was not modified.

## Setup

1. Import one JSON file into a separate workflow in your n8n instance. Keep your existing working workflow intact.
2. Connect credentials in the OpenAI, Google Sheets, Gmail, and Telegram nodes. The Slack variant also needs Slack credentials.
3. Create a Google Sheet with a tab named `Complaint`. Copy the header row from `examples/complaint-sheet-headers.csv`.
4. In both Google Sheets nodes, replace `YOUR_GOOGLE_SHEET_ID` with the same spreadsheet ID, select the `Complaint` tab, and verify the column mappings. The lookup and append nodes originally used separate credential references; ensure both chosen accounts can access the sheet.
5. Replace `YOUR_TELEGRAM_CHAT_ID` with a test destination. For the Slack variant, select your test channel in place of `#YOUR_SLACK_CHANNEL`.
6. Open the form trigger and obtain the new test form URL from your n8n instance. Original webhook identifiers were removed.
7. Follow `docs/TESTING.md` using synthetic requests before enabling the imported workflow.

The export selects `gpt-4o-mini`. Node types, versions, prompts, parser settings, and expressions are preserved from the source; compatibility with your n8n installation has not been tested here.

## Outputs and boundaries

- Classification: Billing, Technical, Delivery, Service Quality, or Other.
- Priority: Low, Medium, High, or Critical.
- Sentiment: Positive, Neutral, Frustrated, or Angry.
- Summary, recommended action, and a response draft.
- Gmail creates a draft; this workflow does not automatically send the customer response.
- Telegram sends an escalation message when the priority condition is true.

Customer names, email addresses, complaint text, and order references are passed to the AI agent and stored in the sheet during execution. Summaries can also reach notification services. Use synthetic data for public demonstrations and keep real execution records private.

## Verification

Run `pwsh -File scripts/validate.ps1` for structural and publication hygiene checks. GitHub Actions runs the same check on pushes and pull requests. These checks do not execute the workflow or prove service integration behavior.

See `docs/REVIEW.md` for the review scope and `docs/PUBLISHING.md` for publication steps. No license has been selected; add one deliberately before offering reuse terms.
