---
description: Generate Structurizr architecture views (System Context, Container, Deployment) based on explicit user confirmations.
on:
  roles: [admin, maintainer, write]
  workflow_dispatch:
    inputs:
      confirm_system_context:
        description: "Generate System Context view"
        type: boolean
        required: true
        default: false
      confirm_container_view:
        description: "Generate Container view"
        type: boolean
        required: true
        default: false
      confirm_deployment_view:
        description: "Generate Deployment view"
        type: boolean
        required: true
        default: false
      architecture_scope:
        description: "System or product name for the generated views"
        type: string
        required: true
permissions: read-all
tools:
  github:
    toolsets: [default]
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

Generate only the Structurizr views that the user explicitly confirmed in workflow inputs.

## Inputs

- `confirm_system_context`: `${{ github.event.inputs.confirm_system_context }}`
- `confirm_container_view`: `${{ github.event.inputs.confirm_container_view }}`
- `confirm_deployment_view`: `${{ github.event.inputs.confirm_deployment_view }}`
- `architecture_scope`: `${{ github.event.inputs.architecture_scope }}`

Treat a value as confirmed only when it is `true`.

## Required Behavior

1. Read existing repository files before creating anything.
2. Create or update architecture definitions under `architecture/` using Structurizr DSL.
3. Only generate confirmed views:
   - If `confirm_system_context` is `true`, generate/update a System Context view.
   - If `confirm_container_view` is `true`, generate/update a Container view.
   - If `confirm_deployment_view` is `true`, generate/update a Deployment view.
4. Do not generate an unconfirmed view.
5. Keep generated DSL focused on `${{ github.event.inputs.architecture_scope }}`.
6. If no view is confirmed, call `noop` with a message that no generation was requested.

## Output Layout

Use this structure (create missing files as needed):

- `architecture/workspace.dsl`
- `architecture/views/system-context.dsl` (only if confirmed)
- `architecture/views/container.dsl` (only if confirmed)
- `architecture/views/deployment.dsl` (only if confirmed)

If an existing consolidated DSL structure is already present, update that structure instead of duplicating architecture models.

## Quality Rules

- Keep naming consistent across people, software systems, containers, and deployment nodes.
- Prefer incremental edits over full rewrites.
- Preserve existing manually-authored descriptions where possible.
- Include short, clear descriptions for relationships.

## Completion

1. If files changed, create a pull request via `create-pull-request`:
   - Title prefix: `architecture:`
   - Summarize which views were generated from confirmed inputs.
2. Add one summary comment via `add-comment` describing:
   - confirmed inputs
   - generated files
   - skipped (unconfirmed) views
3. If nothing changed after analysis, call `noop` with an explanation.

## Usage

Run this workflow manually and set confirmations:

- `confirm_system_context=true` to generate System Context
- `confirm_container_view=true` to generate Container
- `confirm_deployment_view=true` to generate Deployment

Leave any confirmation as `false` to skip that view.