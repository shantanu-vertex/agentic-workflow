---
name: dsl
description: >
  Uses information provided by local skills and user provided content to generate Structurizr DSL
argument-hint: >
  Structurizr DSL
---

# Structurizr C4 DSL Generation & Validation

## What This Skill Produces

This skill turns an architecture description into a Structurizr DSL workspace
that is suitable for C4 modeling. 

This skill can produce one or more of these views:

- System context
- Container
- Deployment

Default to a system context, container and deployment view when the requested level is unspecified.
Produce only the views justified by the available information. Do not invent
implementation details, deployment topology, or internal containers when the
source material does not support them.

<!-- When `## Stage 2c Output — <offering>` blocks are present in the context, treat
them as authoritative deployment input and generate one `deployment` view per
confirmed offering . -->

<!-- > ⛔ **BLOCKING RULE — Deployment views:**
> Do NOT generate deployment views unless `## Stage 2c Output — <offering>` blocks
> are present in the **current conversation context** as the result of running the
> `deployment` skill in this session.
> Pre-existing deployment DSL in any output file does **not** satisfy this requirement.
> A file on disk is an output artifact, not a confirmation. If no Stage 2c Output
> blocks exist in the conversation, invoke the `deployment` skill first and complete
> all confirmation grids before writing any deployment DSL. -->

## When to Use
This skill is intended to be used as part of a larger workflow for generating Structurizr DSL. 
It is not suitable for standalone use.

## Required Inputs
Gather or infer only the minimum information needed to model the requested
scope:

- The system of interest and its purpose 
- The primary users or personas
- External software systems or dependencies
- Internal containers, if a container view is needed
- Important relationships, protocols, or data flows when known
- Any requested view scope, naming conventions, or technology constraints
- Deployment topology from `## Stage 2c Output — <offering>` blocks, if deployment views are requested

Use the structured elicitation algorithm below to gather and confirm this
information interactively before writing any DSL.

- Refer to [Atlassian](../../references/system-information-sources.md#atlassian) for guidance on fetching and
  extracting architecture information from Confluence and Jira when the user provides a reference.

### Handoff to Step 1

Once content is fetched and extracted, treat it as the source material for
Step 1 of the Structurizr DSL Generation & Validation Algorithm. The algorithm runs identically
from that point — the only difference is the source.

---

## Structurizr DSL Generation & Validation Algorithm

Run these steps in order before generating any DSL. Each step presents an
editable grid for the user to confirm or amend. Apply the [Grid Editing](../../references/system-information-updates.md)
rules for all input methods at every step. Do not advance to the next
step without explicit user confirmation.

### Step 1 — Relationships Grid

Present a prefilled, editable grid of all directed relationships between
personas, containers, and external systems identified in prior steps and stages.

**Grid columns:**

| Column | Type | Notes |
|---|---|---|
| Source | Text | Name of the originating element |
| Target | Text | Name of the receiving element |
| Label | Text | Short description of the interaction |
| Protocol | Text | e.g. HTTPS, gRPC, Kafka, AMQP, OIDC |

> Refer to [inferred system information rules before proceeding further](../../references/auto-accept-inferred-system-information.md#auto-accept-tabular-system-information)

---
### Step 2 - Deployment view

**Deployment views:** If one or more `## Stage 2c Output — <offering>` blocks are present in the **current conversation context** (produced by the `deployment` skill in this session), generate one `deployment` view block per confirmed offering. If no such blocks exist — including when a pre-existing `workspace.dsl` already contains deployment nodes — **stop, invoke the `deployment` skill, and complete all 6 confirmation grids before writing any deployment DSL.** Name each view after its offering (e.g. `"DeploymentVertexCloud"`, `"DeploymentVoD"`, `"DeploymentVoP"`). Do not merge offerings into a single view. For each deployment view:

- Nest deployment nodes in the hierarchy: **Environment → Cloud/Hosting → Region → Network → Cluster**
- Use `deploymentNode` only for the infrastructure hierarchy; do not re-define containers here, and emit deployed application/runtime elements as instances
- For each confirmed container of the primary software system from Stage 2b/2c, emit a `containerInstance` inside the deployment node that matches its confirmed hosting location
- Reference containers by exact name from the container diagram when creating `containerInstance` entries
- Show Control Plane and Application Plane as separate nodes or labels
- For each confirmed external system, emit a `softwareSystemInstance` inside the deployment node that matches its confirmed hosting location (Control Plane, App Plane, or Customer-hosted)
- Do not add `autoLayout` to deployment view blocks

---

### Step 3 — Generate DSL

Once all system information is confirmed, proceed to DSL generation using the
confirmed data as the sole source of truth. Do not infer or invent anything
not present in the confirmed grids so far. Apply:

- [Value stream style guides](../../references/dsl-styling.md#value-stream-based-element-styles)
- [Container style guides](../../references/dsl-styling.md#container-name-based-styles)
- [Relationship style guides](../../references/dsl-styling.md#relationship-line-styles)
- [Styles block](../../references/dsl-styling.md#styles-block)



---

### Step 4 - Validate DSL and Autocorrect Errors
After generating the DSL, save it in ./generated/structurizr directory. Validate it using structurizr-cli's `validate` command. If any errors are found, attempt
to autocorrect based on the error messages. Proceed to next step only after the DSL is valid.

After generating the DSL, ensure the `./generated/structurizr` directory exists and save the workspace in that location.
Validate that file using structurizr-cli's `validate` command. If any errors are found, attempt
to autocorrect based on the error messages and structurizr-cli's `inspect` command. Proceed to next step only after generated dsl 
in `./generated/structurizr` is valid.

### Step 5 - Review with User
Present the generated DSL to the user along with any assumptions or inferred details. 
Ask for confirmation that the DSL accurately represents their system and the requested views. 
Make any necessary adjustments based on user feedback.

## Procedure

1. Run the information gathering stages and steps before writing
   any DSL.

2. Select the appropriate view set from the confirmed data.
   Default to system context. Add a container view when the containers grid
   contains meaningful entries. Add a deployment view per offering 

3. Write the Structurizr DSL from the confirmed grids.
   Build a complete workspace with `workspace`, `model`, and `views` sections.
   Keep identifiers simple and consistent. Apply element tags and styles as
   described in the [DSL Styling](../../references/dsl-styling.md) sections.

4. Review for C4 correctness.
   Check that each element appears at the right abstraction level for the view.
   Do not mix deployment nodes, code components, or operational detail into
   context or container diagrams unless the user explicitly asks for them.

5. Surface assumptions.
   If the DSL depends on inferred details, list the assumptions separately after
   the DSL or ask the user to confirm before finalizing.

## Decision Points

### Which View to Generate

- Generate a system context view by default when the user asks for an
  architecture diagram without specifying a C4 level. Use it to show users
  and external dependencies around one primary software system.
- Generate a container view when the user asks for the internals of a software
  system and provides enough detail to distinguish major applications, data
  stores, or services.
- Generate a deployment view. Use the corresponding output block as the sole source of truth for
  that view's deployment topology. Do not merge multiple offerings into a single view.
- If the user asks for a landscape or enterprise-wide view, explain that this
  skill covers system context, container, and deployment diagrams only, and suggest they
  scope to a single system to get started.

### When to Ask Questions First

Ask clarifying questions before finalizing when any of these are true:

- The primary software system is unclear.
- The requested view level is ambiguous.
- A container view is requested but no meaningful containers are described.
- Relationship direction or purpose is unclear.
- Multiple names could refer to the same person, system, or container.

### When to Stop at a Higher Abstraction

- If internal structure is vague, produce only a context view.
- If technologies are unknown, omit technology labels rather than guessing.
- If deployment topology data (`## Stage 2c Output — <offering>` blocks) is not yet available, produce only context and container views and do not attempt to generate deployment views.

## Quality Criteria

The skill is complete only when all of the following are true:

- The DSL is structurally complete, validated, and ready to be saved as a workspace file.
- The model has a clear primary system.
- Relationships between systems and personas are present; if missing from the
  source material, ask for them explicitly rather than leaving them out or
  inventing them.
- Element names are consistent and non-duplicative.
- Relationships have meaningful descriptions.
- The chosen views match the requested or supported abstraction level.
- All database, queue, and topic containers are tagged and the styles block
  contains the corresponding shape rules.
- All external systems and personas have a Value Stream assigned and the
  corresponding style rule is present in the styles block.
- Assumptions, gaps, or inferred details are explicit.
- No major entities from the source material are silently dropped.

## Output Format

Return:

1. The Structurizr DSL in a fenced code block.
2. A short assumptions section when needed, including any Value Stream
   inferences the user should verify.
3. A short list of unresolved questions only if they block correctness.

When the user asks for only the DSL, keep the response concise and put any
assumptions after the code block.

The generated DSL does not include `autoLayout`. Mention to the user that they
can enable automatic layout temporarily in the Structurizr UI to get an initial
arrangement, then position elements manually. This keeps the DSL layout-neutral
so manual positioning is never overwritten by a future update.

## Authoring Rules

- Do not invent systems, containers, or protocols to make the diagram look more
  complete.
- Do not collapse distinct actors or systems unless the source material clearly
  treats them as one thing.
- Prefer business-facing descriptions over implementation trivia.
- Keep container decomposition coarse-grained. A container is a deployable or
  runnable application, data store, or major service boundary, not a class or
  library.
- Preserve user terminology unless it causes a modeling conflict.
- Do not include `autoLayout` in any view block. Structurizr re-applies
  automatic layout every time a workspace containing `autoLayout` is updated,
  which silently discards any manual positioning the user has done. Omitting
  it leaves layout control entirely with the user.
- Tag every container that represents a database, queue, or topic. Never leave
  these as plain unstyled containers — the pictorial shape is the primary way
  readers distinguish data stores and messaging infrastructure from application
  services at a glance.
- Apply Value Stream tags to every external system and persona. Use the
  Value Stream Reference table to infer; default to `External` only when no
  alias matches. List all inferences in the assumptions section so the user
  can verify them.