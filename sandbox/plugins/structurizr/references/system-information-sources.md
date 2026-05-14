# System Information Sources

## Atlassian

If `vertex-atlassian-mcp` is available and the user provides any Atlassian
reference, fetch the source content before running the Information Gathering
Algorithm. The fetched content becomes the input to Step 1 in place of the
user's prompt text.

### Available tools

| Tool | Purpose | Key parameters |
|---|---|---|
| `confluence_get_page` | Fetch a page by ID | `page_id`, `include_children`, `child_limit` |
| `confluence_search` | Search pages by text | `query`, `space_key`, `limit` |
| `jira_get_issue` | Fetch an issue by key | `issue_key`, `include_comments`, `comment_limit` |
| `jira_search_issues` | Search issues by JQL | `jql`, `limit` |

All tools are read-only.

### Fetching by page URL or ID

Extract the numeric page ID from the URL (the long number at the end of the
path) and call `confluence_get_page`. Always include child pages — they
frequently contain component-level or integration detail:

```
confluence_get_page(
  page_id: "<extracted page ID>",
  include_children: true,
  child_limit: 5
)
```

Fetch a child page's full content with a second `confluence_get_page` call
only if its title suggests architecture-relevant detail (e.g. "Container
Design", "Service Dependencies", "API Catalogue", "Integrations").

### Fetching by search

If the user names a system or team without a specific page, call
`confluence_search`. Scope to a space key if the user mentions one:

```
confluence_search(
  query: "<system name> architecture",
  space_key: "<space if known>",
  limit: 5
)
```

Present the result titles to the user and ask which to use before fetching
the full page with `confluence_get_page`.

### Fetching from Jira

If the user provides a Jira issue key (e.g. `DMS-42`), call `jira_get_issue`
with comments included — comments often capture integration decisions not in
the description:

```
jira_get_issue(
  issue_key: "DMS-42",
  include_comments: true,
  comment_limit: 10
)
```

Use component fields, description, and comment text to infer systems and
relationships. If the issue references related epics that likely contain
more system detail, fetch those with additional `jira_get_issue` calls.

### Extracting architecture content from Confluence markup

Confluence pages contain a mix of architecture content and surrounding noise.
When parsing fetched content:

- Focus on sections with headings like "Architecture", "Components",
  "Integrations", "Dependencies", "Context", "Design"
- Extract tables listing services, systems, or APIs — these map directly
  to containers and external systems
- Extract any listed personas, user types, or consumer systems
- Note technology labels mentioned inline (e.g. "built on Kafka",
  "PostgreSQL database", "REST API")
- Ignore sections titled "Change Log", "Approvals", "Related Links" unless
  they contain system names not mentioned elsewhere

### Fallback

If `vertex-atlassian-mcp` is not available, proceed with whatever the user
has provided in the prompt. Inform the user that a Confluence page URL, page
ID, or Jira issue key can be provided for richer results.