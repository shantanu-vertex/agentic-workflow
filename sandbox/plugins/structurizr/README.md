# structurizr

Generates Structurizr C4 architecture diagrams from Confluence pages or
direct descriptions. Produces validated system context and container diagrams as
validated Structurizr DSL.

---

## Prerequisites

### 1. Install and configure vertex-atlassian-mcp

You will need to install
the [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli) if you haven't already.
This plugin uses `vertex-atlassian-mcp` to fetch Confluence and Jira content.
[Install and configure](https://github.com/vertexinc/vertex-ai-plugins/tree/main/plugins/vertex-atlassian-mcp) it first. 

https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli

**Install:**
```
copilot plugin install vertex-atlassian-mcp@vertex-ai-plugins
```

**Install Python dependencies:**
```
cd <vertex-atlassian-mcp-dir>
pip install -r requirements.txt
```

**Configure credentials** (run once — prompts for base URL, email, API token):
```
/vertex-atlassian-mcp:configure
```

Credentials are encrypted with Windows DPAPI and stored at:
```
%APPDATA%\RobbyAtlassianMCP\credentials.json
```

To reconfigure, run the configure skill again — it overwrites previous
credentials. To remove credentials entirely, delete the directory:
```
%APPDATA%\RobbyAtlassianMCP\
```

**Test the connection:**
```
/vertex-atlassian-mcp:test-connection
```

---

### 2. Install structurizr

**From the registry:**
```
copilot plugin install structurizr@architecture-ai-registry
```

**From a local clone:**
```
# Primarily used for plugins in development — install directly from the local path
copilot plugin install ./sandbox/plugins/structurizr
```

---

## Usage

Once both plugins are installed, start a Copilot CLI session and use natural
language. The plugin calls `confluence_get_page`, `confluence_search`,
`jira_get_issue`, or `jira_search_issues` automatically based on what you
provide.

**From a Confluence page URL:**
```
> Create a C4 diagram from this page:
  https://vertexinc.atlassian.net/wiki/spaces/ARCH/pages/6344966233
```

**From a Confluence page ID:**
```
> Build a system context diagram from Confluence page 6344966233
```

**From a Confluence search:**
```
> Find the IPS architecture page in Confluence and generate a C4 diagram
```

**From a Jira issue:**
```
> Create a container diagram based on DMS-42
```

**From a Jira search:**
```
> Find architecture epics in the DMS project and build a context diagram
```

**From a direct description (no Atlassian required):**
```
> Model a system where a Tax Calc service talks to VoD, the IPS gateway,
  and a Postgres database — generate a system context diagram
```

---

## Plugin structure

```
structurizr/
  plugin.json                         # Manifest — declares vertex-atlassian-mcp dependency
  plugin.md                           # Orchestration instructions                 
  README.md
  references/
    dsl-styling.md
    system-information-sources.md
    system-information-updates.md
    value-streams.md
  skills/
    containers/
    dsl/
    system-context/
    ...
```

---

## Usage examples

```
> copilot
> Create a C4 diagram from this Confluence page:
  https://vertexinc.atlassian.net/wiki/spaces/CSA/pages/6777536649/Technical+Design+Oracle+Accelerator+2+System+Metadata

# Atlassian MCP requires python 3.13. The version installed currently does not allow higher versions
# Example prompt for auto accepting all inferred content. (Do not interpret this as a real prompt)
> Create a C4 diagram from this Confluence page:
  https://vertexinc.atlassian.net/wiki/spaces/CSA/pages/6777536649/Technical+Design+Oracle+Accelerator+2+System+Metadata. Use python3.13 for atlassian MCP. auto-accept-inferred-sys-info

> Create a C4 diagram from this Confluence page:
  https://vertexinc.atlassian.net/wiki/spaces/CSA/pages/6777536649/Technical+Design+Oracle+Accelerator+2+System+Metadata. Use python3.13 for Atlassian MCP. Follow instructions in
  sandbox/plugins/structurizr/plugin.md file closely and all its references.

> Model the system described in DMS-42 as a container diagram

> Create a C4 context diagram — our Tax Calc service talks to VoD,
  the IPS gateway, and a Postgres database
```
