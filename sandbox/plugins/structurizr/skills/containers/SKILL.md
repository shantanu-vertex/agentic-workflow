---
name: containers
description: >
  Collects information about the primary software system's deployable modules or containers.
argument-hint: >
  Confluence page URL or ID, Jira issue key, or a direct description of the
  software system containers.
---

# Structurizr C4 Containers Information

## What This Skill Produces

This skill produces information about the primary software system containers.

## When to Use

This skill is intended to be used as part of a larger workflow for generating Structurizr DSL.
It is not suitable for standalone use.

## Required Inputs

Gather or infer only the minimum information needed to model the requested
scope:

- System containers that represent deployable applications, or data stores within the primary system.

Use the structured elicitation algorithm below to gather and confirm this
information interactively before writing any DSL.

- Refer to [Atlassian](../../references/system-information-sources.md#atlassian) for guidance on fetching and
  extracting architecture information from Confluence and Jira when the user provides a reference.

### Handoff to Step 1

Once content is fetched and extracted, treat it as the source material for
Step 1 of the Primary System Containers Information Gathering Algorithm. The algorithm runs identically
from that point — the only difference is the source.

---

## Primary System Containers Information Gathering Algorithm

Run these steps in order before generating any DSL. Each step presents an
editable grid for the user to confirm or amend. Apply the [Grid Editing](../../references/system-information-updates.md)
rules for all input methods at every step. Do not advance to the next
step without explicit user confirmation.

---

### Step 1 — Primary System Containers Grid

Present a prefilled, editable grid of the containers that belong to the
primary system inferred from the prompt and other external sources like Confluence or Jira.

**Grid columns:**

| Column | Type | Notes |
|---|---|---|
| Name | Text | Business-meaningful name |
| Technology | Text | e.g. "PostgreSQL", "Node.js", "Apache Kafka" |

> Refer to [inferred system information rules before proceeding further](../../references/auto-accept-inferred-system-information.md#auto-accept-tabular-system-information)

