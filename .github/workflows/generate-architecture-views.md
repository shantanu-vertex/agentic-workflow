---
description: Generate Structurizr architecture diagram views via the Structurizr plugin with interrupt-and-resume confirmation flow.
on:
  roles: [admin, maintainer, write]
  workflow_dispatch:
    inputs:
      architecture_scope:
        description: "System or product name for the generated views"
        type: string
        required: true
      run_mode:
        description: "start or resume"
        type: choice
        required: true
        options: [start, resume]
        default: start
      confirmation_ref:
        description: "Reference ID from the previous confirmation request (required for resume)"
        type: string
        required: false
      confirmation_payload:
        description: "User confirmations as JSON or key=value pairs for resume"
        type: string
        required: false
permissions: read-all
tools:
  github:
    toolsets: [default]
  web-fetch:
  cache-memory: true
network:
  allowed:
    - defaults
    - vertexinc.atlassian.net
safe-outputs:
  create-pull-request:
    max: 1
  add-comment:
    max: 2
  noop:
---

# Generate Architecture Views

You are an AI architecture assistant for this repository.

## Goal

Use the Structurizr plugin files from `sandbox/plugins/structurizr` to generate architecture diagram views with a confirmation-driven, interrupt-and-resume execution flow.

## Inputs

- `architecture_scope`: `${{ github.event.inputs.architecture_scope }}`
- `run_mode`: `${{ github.event.inputs.run_mode }}`
- `confirmation_ref`: `${{ github.event.inputs.confirmation_ref }}`
- `confirmation_payload`: `${{ github.event.inputs.confirmation_payload }}`

## Plugin and Skills Discovery

1. Load the Structurizr plugin definition only from:
  - `sandbox/plugins/structurizr/plugin.json`
2. Read plugin docs only from:
  - `sandbox/plugins/structurizr/plugin.md`
3. Find confirmation skill files only from:
  - `sandbox/plugins/structurizr/skills/**/SKILL.md`
4. Extract confirmation questions from these skill files and treat them as required confirmation gates.
5. Do not use any globally installed Structurizr plugin or plugin files outside `sandbox/plugins/structurizr`.

If required plugin files are missing under `sandbox/plugins/structurizr`, use `add-comment` to report what path was searched, then call `noop`.

## Required Behavior

1. Read existing repository files before creating anything.
2. Create a C4 diagram from this Confluence page:
  - `https://vertexinc.atlassian.net/wiki/spaces/CSA/pages/6777536649/Technical+Design+Oracle+Accelerator+2+System+Metadata`
  - Use `web-fetch` to retrieve the page content and extract metadata required by the Structurizr plugin before generating any DSL.
3. Use only the Structurizr plugin commands and metadata mapping defined in `sandbox/plugins/structurizr` to prepare generation for `${{ github.event.inputs.architecture_scope }}` using the extracted Confluence metadata.
4. Enforce confirmation gates from skill files and plugin prompts.
5. Implement interrupt-and-resume flow:
  - If `run_mode` is `start` and confirmations are still required, do NOT generate final outputs.
  - Persist pending state in `/tmp/gh-aw/cache-memory/structurizr-pending.json` with:
    - `confirmation_ref` (generate one if absent)
    - list of required questions
    - plugin context needed to resume
  - Use `add-comment` to publish required confirmation questions and exact resume instructions.
  - Call `noop` after posting the request so the run ends cleanly.
6. On `run_mode=resume`:
  - Load pending state from cache-memory.
  - Match `confirmation_ref` and parse `confirmation_payload`.
  - Resume the Structurizr plugin flow and continue generation only for explicitly confirmed items.
7. Never generate an unconfirmed view.

## Output Layout

Generate/update DSL files in `.github/workflows/`:

- `.github/workflows/workspace.dsl`
- `.github/workflows/system-context.dsl` (only if confirmed)
- `.github/workflows/container.dsl` (only if confirmed)
- `.github/workflows/deployment.dsl` (only if confirmed)

If an existing consolidated DSL structure is already present, update that structure instead of duplicating architecture models.

## Quality Rules

- Keep naming consistent across people, software systems, containers, and deployment nodes.
- Prefer incremental edits over full rewrites.
- Preserve existing manually-authored descriptions where possible.
- Include short, clear descriptions for relationships.
- After generating DSL, run Structurizr plugin export/render commands defined in `sandbox/plugins/structurizr/plugin.md` to validate views are renderable.

## Completion

1. If files changed, create a pull request via `create-pull-request`:
   - Title prefix: `architecture:`
  - Summarize which views were generated and which confirmations were used.
2. Add one summary comment via `add-comment` describing:
  - confirmation ref
  - confirmed answers
   - generated files
  - skipped (unconfirmed) views
3. If nothing changed after analysis, call `noop` with an explanation.

## Usage

Start run:

- `run_mode=start`
- `architecture_scope=<name>`

Resume run after you answer confirmation questions:

- `run_mode=resume`
- `architecture_scope=<same name>`
- `confirmation_ref=<id from comment>`
- `confirmation_payload=<answers in JSON or key=value list>`

Only explicitly confirmed views are generated.