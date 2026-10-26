# Security and privacy

Keep credentials in n8n's credential store. Do not commit environment files, raw exports, customer records, execution logs, screenshots containing personal information, or live webhook URLs.

Before publishing an updated export, remove credential references, instance metadata, pinned data, spreadsheet identifiers, recipient IDs, and webhook identifiers. Review free-text fields and embedded code as well as running automated checks.

Use synthetic data when reporting a problem. If a secret is accidentally published, revoke or rotate it and assess repository history; deleting the current file alone does not remove historical copies.
