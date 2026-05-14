---
name: structurizr
description: >
  Generates architecture diagrams as Structurizr DSL from Confluence pages or
  direct descriptions. Use this plugin when the user wants to create system
  context, container, or deployment diagrams, with or without a Confluence
  page as source material. Fetches and normalises Confluence content
  automatically when a URL, page ID, or search term is provided.
dependencies:
  - vertex-atlassian-mcp    # optional but strongly recommended
---

# Structurizr C4 Plugin

This plugin generates Structurizr DSL for system context, container, and
deployment diagrams. It accepts architecture input from three sources — a
Confluence page, a Jira issue, or a direct text description — and runs the
same information gathering and DSL generation workflow regardless of source.

## Prerequisites

### vertex-atlassian-mcp (required for Confluence/Jira input)

This plugin depends on `vertex-atlassian-mcp` for fetching Confluence and
Jira content. It must be installed and configured before use.

**Install:**
```
copilot plugin install vertex-atlassian-mcp@vertex-ai-plugins
```

**Configure credentials** (run once):
```
/vertex-atlassian-mcp:configure
```

You will be prompted for your Atlassian base URL, email, and API token.
Credentials are encrypted with Windows DPAPI and stored in
`%APPDATA%\RobbyAtlassianMCP\credentials.json`.

**Test the connection:**
```
/vertex-atlassian-mcp:test-connection
```

If `vertex-atlassian-mcp` is not installed, the plugin falls back to direct
text input and notifies the user.

### structurizr-c4 (this plugin)

**Install:**
```
copilot plugin install structurizr-c4@vertex-ai-plugins
```

---

## Workflow

> **Execution model:** Stages run sequentially: Stage 1 → Stage 2a → Stage 2b → Stage 2c → Stage 3.
> Do not begin a stage until all preceding stages are complete and their output blocks
> are present in the response. Do not skip stages. Do not combine stages in a single response turn.

### Stage 1 — Fetch source content

Determine the input type from the user's prompt and fetch accordingly.
- Refer to [Atlassian](references/system-information-sources.md#atlassian) for guidance on fetching and
  extracting architecture information from Confluence and Jira when the user provides a reference.
- Read `skills/system-context/SKILL.md` before starting Stage 2.
- Read `skills/containers/SKILL.md` before starting Stage 2.
- Read `skills/deployment/SKILL.md` before starting Stage 2.

**Direct text**
If no Atlassian reference is provided, or if `vertex-atlassian-mcp` is not
available, skip Stage 1 and proceed directly to Stage 2 using the user's
prompt as source material. Inform the user that a Confluence page or Jira
issue key can be provided for richer context.

**[STAGE 1 GATE]** Before proceeding to Stage 2, output the following block in
your response:

```
## Stage 1 Output
<paste the extracted source content here>
```

Do not begin Stage 2 until this block is present. If content cannot be fetched,
stop and ask the user how to proceed.

---

### Stage 2 — Information Gathering

**Requires:** `## Stage 1 Output` block must be present in the current context.
If it is missing, return to Stage 1 before continuing.

#### Stage 2a — System Context

Follow the instructions in [skills/system-context/SKILL.md](skills/system-context/SKILL.md) to gather information
about the primary system, its external dependencies, and personas. Use the `## Stage 1 Output` block as source material.

**[STAGE 2a GATE]** Before proceeding to Stage 2b, output the following block:

```
## Stage 2a Output
<system context summary: primary system, personas, external dependencies>
```

Do not begin Stage 2b until this block is present.

#### Stage 2b — Primary System Containers

**Requires:** `## Stage 2a Output` block must be present. If it is missing, complete Stage 2a first.

Follow the instructions in [skills/containers/SKILL.md](skills/containers/SKILL.md) to gather information about the
primary system's containers. Use the `## Stage 1 Output` and `## Stage 2a Output` blocks as source material.

**[STAGE 2b GATE]** Before proceeding to Stage 2c, output the following block:

```
## Stage 2b Output
<container summary: containers, technologies, internal relationships>
```

Do not begin Stage 2c until this block is present. Stage 2c is always required unless the user explicitly asks for system-context or container-only output.

---
#### Stage 2c — Deployment

**Requires:** `## Stage 2b Output` block must be present. If it is missing, complete Stage 2b first.

> Stage 2c may be omitted **only** when the user explicitly asks for system context or container views only. In all other cases it is mandatory — even when the source material contains no deployment information.
> Pre-filled deployment data in the source material (e.g. Confluence tables) speeds up confirmation but does NOT replace it.
> Do NOT infer offerings, regions, clusters, or external system placement from the source material without explicit user confirmation when Stage 2c is in scope.

**⛔ DEPLOYMENT SKILL GATE — always mandatory:*
Stage 2c is **always required** whenever the user requests a C4 diagram (unless the user explicitly asks for system context or container views only). It may NOT be skipped regardless of whether the source material contains deployment information:
- If the source material **contains** deployment offerings, planes, regions, or cluster information → use the deployment skill's **Fast Path** (when all 6 Confluence tables are present) or pre-fill what is known and follow the **Slow Path** for the rest.
- If the source material **does not contain** any deployment information → follow the deployment skill's **Slow Path** in full, collecting all deployment details interactively.

When Stage 2c is required (always):
- An existing `workspace.dsl` with deployment DSL does **NOT** count as confirmed deployment information. It is prior output, not a confirmed input. Stage 2c must still be run in full.
- Do NOT copy, reuse, or extend existing deployment nodes from a `workspace.dsl` without running the deployment skill first.
- Do NOT write any `deploymentEnvironment`, `deploymentNode`, `containerInstance`, `softwareSystemInstance`, or `deployment` view blocks in Stage 3 unless the corresponding `## Stage 2c Output — <offering>` block is present in the context.

**Step 1 — Run the deployment skill**

Follow the instructions in [skills/deployment/SKILL.md](skills/deployment/SKILL.md) exactly as written. The skill collects and confirms all deployment topology for all selected offerings in a single run — including asking the user which offerings to include as its first confirmation grid.

Rules:
- **Use the execution path defined by `skills/deployment/SKILL.md`**. If the deployment skill provides a documented fast path (for example, when Confluence metadata tables are present), use that fast path; otherwise use its standard question flow.
- **Use the deployment skill's `## Prompt Contract` section as defined in that file**. Treat each prompt-contract grid as the authoritative confirmation item — do not convert grids to one-by-one questions.
- Do NOT invent, replace, or override the deployment skill's question set, section names, ordering, or confirmation mechanics.
- Do NOT infer, assume, or skip any deployment information required by the deployment skill for the selected path.

**Step 2 — Produce one Stage 2c Output block per confirmed offering**

After confirming all questions for all offerings, output one output block per offering:

```
## Stage 2c Output — Vertex Cloud
<Deployment summary for Vertex Cloud: services, networking, regions, cloud providers, deployment environment>

## Stage 2c Output — VoD
<Deployment summary for Vertex On-Demand: ...>

## Stage 2c Output — VoP
<Deployment summary for Vertex On-Premises: ...>
```

Only include blocks for offerings the user confirmed. Do not begin Stage 3 until all confirmed offerings have an output block.

**[STAGE 2c GATE]** Do not begin Stage 3 until every confirmed offering has a corresponding `## Stage 2c Output — <offering>` block present in the context.

---
### Stage 3 — Generate & Validate Structurizr DSL

**Pre-flight verification (mandatory — output this checklist before writing any DSL):**

List each block and mark it present or missing:
- `## Stage 1 Output` — present / missing
- `## Stage 2a Output` — present / missing
- `## Stage 2b Output` — present / missing
- `## Stage 2c Output — Vertex Cloud` — present / missing / not applicable
- `## Stage 2c Output — VoD` — present / missing / not applicable
- `## Stage 2c Output — VoP` — present / missing / not applicable

If **any required block is missing**, stop immediately and complete that stage before continuing. Do not write any DSL until every required block is marked **present**.

**⛔ DEPLOYMENT DSL HARD STOP:** If the source material contains deployment information (offerings, planes, regions, clusters) and any `## Stage 2c Output — <offering>` block is marked **missing**, do NOT write deployment DSL for that offering under any circumstances — not even as a "best guess" or to "match the existing workspace". Stop and run Stage 2c for the missing offering first.

Follow the instructions in [skills/dsl/SKILL.md](skills/dsl/SKILL.md) to generate and validate Structurizr DSL.
Use the `## Stage 1 Output`, `## Stage 2a Output`, `## Stage 2b Output`, and all `## Stage 2c Output — <offering>` blocks as the sole source of truth.

**Multiple deployment views:** Generate one `deployment` view block in the DSL for each confirmed offering, using the corresponding `## Stage 2c Output — <offering>` block as source. Name each view after its offering, e.g. `"DeploymentVertexCloud"`, `"DeploymentVoD"`, `"DeploymentVoP"`. Do not merge offerings into a single view.
