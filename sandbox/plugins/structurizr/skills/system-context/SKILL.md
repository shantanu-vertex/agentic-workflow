---
name: system-context
description: >
  Collects information about the primary software system, its users, and its external dependencies.
argument-hint: >
  Confluence page URL or ID, Jira issue key, or a direct description of the
  system — including its scope and purpose, key users and personas, external systems.
---

# Structurizr System Context Information

## What This Skill Produces

This skill produces information about the primary software system, its users, and its external dependencies. It runs an 
interactive information gathering process to confirm this information.

## When to Use

This skill is intended to be used as part of a larger workflow for generating Structurizr DSL. 
It is not suitable for standalone use. 

## Required Inputs

Gather or infer only the minimum information needed to model the requested
scope:

- The system of interest and its purpose
- The primary users or personas
- External software systems or dependencies

Use the structured elicitation algorithm below to gather and confirm this
information interactively before writing any DSL.

- Refer to [Atlassian](../../references/system-information-sources.md#atlassian) for guidance on fetching and 
  extracting architecture information from Confluence and Jira when the user provides a reference.

### Handoff to Step 1

Once content is fetched and extracted, treat it as the source material for
Step 1 of the System Context Information Gathering Algorithm. The algorithm runs identically
from that point — the only difference is the source.

---

## System Context Information Gathering Algorithm

Run these steps in order before generating any DSL. Each step presents an
editable grid for the user to confirm or amend. Apply the [Grid Editing](../../references/system-information-updates.md)
rules for all input methods at every step. Do not advance to the next
step without explicit user confirmation.

### Step 1 — Primary System and Scope

Parse everything the user has provided and infer as much as possible:
primary system, its value stream, and scope.

Refer to [inferred system information rules before proceeding further](../../references/auto-accept-inferred-system-information.md#auto-accept-general-system-information)

---

### Step 2 - External Systems Grid
Present a prefilled, editable grid of all systems outside the primary system
boundary that interact with it. Pre-populate the Value Stream column using the
[Value Streams](../../references/value-streams.md#value-stream-reference) table — show the inferred value and 
let the user correct it if wrong.

**Grid columns:**

| Column | Type | Notes |
|---|---|---|
| Name | Text | Business-meaningful name |
| Value Stream | Select | Inferred from Value Stream Reference; default `External` |

> Refer to [inferred system information rules before proceeding further](../../references/auto-accept-inferred-system-information.md#auto-accept-tabular-system-information)


### Step 3 — Personas Grid

Present a prefilled, editable grid of all human actors that interact with the
primary system or its external dependencies. Pre-populate the Value Stream
column using the [Value Streams](../../references/value-streams.md#value-stream-reference) table. 
Default to `External` when no match is found.

**Grid columns:**

| Column | Type | Notes                        |
|---|---|------------------------------|
| Name | Text | Role or persona name         |
| Value Stream | Select | Inferred from Value Stream Reference; default `External` |

> Refer to [inferred system information rules before proceeding further](../../references/auto-accept-inferred-system-information.md#auto-accept-tabular-system-information)
