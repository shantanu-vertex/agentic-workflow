---
name: deployment

description: >
  Collects and confirms deployment-specific information required to generate a Structurizr C4 Deployment Diagram for Vertex Accelerator / O Series deployments across Vertex Cloud, Vertex On-Demand, and On-Premise offerings.

argument-hint: >
  Deployment context such as environment (prod/non-prod), deployment offering (Vertex Cloud, On-Demand, On-Prem), regions, cloud providers, Kubernetes clusters, virtual networks, and control-plane / application-plane topology.

---

## Structurizr C4 Deployment Information

### What This Skill Produces

This skill produces a **deployment model** suitable for generating a **Structurizr C4 Deployment Diagram**, including:

- Deployment environments (e.g., Prod, Non-Prod)
- Deployment nodes (cloud, region, VNet/VPC, clusters)
- Runtime topology (Control Plane vs Application Plane)
- Infrastructure boundaries (Vertex-managed vs Customer-managed)
- Mapped container instances (derived from the C4 Container Diagram)

The output is used downstream to synthesize **Structurizr DSL deployment views**.

---

### When to Use

Use this skill **after**:

1. The **C4 Container Diagram** skill has been completed and confirmed
2. The deployment context (VoP / VoD / Vertex Cloud) is known or can be elicited

This skill is **not intended for standalone usage**. It must be executed as part of a larger workflow that:

- First generates a Container diagram
- Then confirms deployment assumptions
- Then generates Deployment views

---

### Required Inputs

Gather or infer only the minimum deployment information necessary to accurately model the requested scope.

Required inputs fall into five categories:

#### 1. Deployment Offering

Identify the high-level deployment model:

- Vertex Cloud (multi-tenant SaaS)
- Vertex On-Demand (single-tenant, hosted)
- Vertex On-Premises (customer-managed, private cloud or data center)

#### 2. Environment Context

Confirm one or more environments:

- Production
- Non-Production (Dev / Test / UAT)

For each environment, capture whether it is:

- Vertex-managed
- Customer-managed

#### 3. Infrastructure Topology

For each environment, collect:

- Cloud provider or hosting type (Vertex Cloud, AWS, Azure, OCI, On-Prem)
- Region(s)
- Virtual Network / VPC / VNet
- Kubernetes cluster(s) or compute substrate

#### 4. Plane Separation

Confirm logical separation of runtime planes:

- **Control Plane** (shared services, orchestration, configuration, batch workers)
- **Application Plane** (customer-facing APIs, calc services, client-specific workers)

Identify whether planes:

- Are deployed in separate clusters
- Share a cluster but use namespaces
- Span multiple regions

#### 5. External Dependencies

Identify externally deployed systems:

- Customer ERP systems (Oracle ERP Cloud, SAP, etc.)
- On-premise or edge calc engines
- Managed databases (PostgreSQL, global or regional)
- Observability / monitoring agents (e.g., Datadog Agent)

---

### Handoff from Container Diagram Skill

Once the **C4 Container Diagram Skill** completes:

- Treat confirmed containers as immutable logical elements
- Use container names and technologies as-is
- Only model **instances** and **deployment locations** in this skill

No new containers must be introduced during deployment modeling.

---

## Confluence Page Metadata Detection

Before running any steps, check whether the source Confluence page contains a section titled **"C4 Deployment Diagram Metadata"** with all five deployment tables:

- Table 1 — Deployment Offerings
- Table 2 — Offerings, Plane and Cloud provider
- Table 3 — Cloud Providers & Regions
- Table 4 — Cluster Topology
- Table 5 — Container → Plane & Instance Type Mapping
- Table 6 — External Systems Deployment Placement

**If all six tables are present → use the [Fast Path](#fast-path--confluence-tables-present).**  
**If any table is missing or the section does not exist → use the [Slow Path](#slow-path--no-confluence-tables).**

---

## Deployment Information Gathering Algorithm

Each step must:

- Present a **prefilled, editable grid**
- Be explicitly confirmed by the user
- Follow Grid Editing rules (add / edit / delete allowed)

Do **not** advance without confirmation.

---

### Fast Path — Confluence Tables Present

> ⛔ **Fast Path means 6 confirmations instead of 17 questions — it does NOT mean skip confirmations.**
> Every grid below must still be explicitly confirmed by the user before proceeding to the next one.

When all six tables are detected, replace every individual question with a single **grid confirmation** per step. Pre-fill each grid directly from the corresponding Confluence table. You must still confirm each grid with the user before proceeding.

**6 grid confirmations replace 17 individual questions.**

#### Fast Path Step 1 — Deployment Offerings Grid

Pre-fill from **Confluence Table 1 — Deployment Offerings**.

Present the following grid (pre-filled):

| Deployment Name | Offering | Environment | Management Model |
|------|------|------|------|
| *(from Table 1)* | *(from Table 1)* | *(from Table 1)* | *(from Table 1)* |

Ask once:
> "Here are the deployment offerings read from the Confluence page. Which offerings should be included in this diagram run? Edit, add, or remove rows as needed — then confirm."

Wait for confirmation before proceeding.

---

#### Fast Path Step 2 — Offerings, Plane and Cloud provider
Pre-fill from **Confluence Table 2 — Offerings, Plane and Cloud provider**, filtered to confirmed offerings only.


| Offering | Plane | Cloud Provider |
|------|------|------|
| *(from Table 2)* | *(from Table 2)* | *(from Table 2)* |

Ask once:
> "Here are the Plane and Cloud Provider for the selected offerings. Confirm or edit."

Wait for confirmation before proceeding.

---

#### Fast Path Step 3 — Cloud Providers & Regions
Pre-fill from **Confluence Table 3 — Cloud Providers & Regions**, filtered to confirmed offerings only.


| Cloud Providers | Region Code | Location |
|------|------|------|
| *(from Table 3)* | *(from Table 3)* | *(from Table 3)* |

Ask once:
> "Here are the Regions and Cloud Providers for the selected offerings. Confirm or edit."

Wait for confirmation before proceeding.
---

#### Fast Path Step 4 — Cluster Topology Grid

Pre-fill from **Confluence Table 4 — Cluster Topology** (filtered to confirmed offerings only).

| Offering | Plane | Cluster Name | Technology | Region | Isolation Model |
|------|------|------|------|------|------|
| *(from Table 4)* | *(from Table 4)* | *(from Table 4)* | *(from Table 4)* | *(from Table 4)* | *(from Table 4)* |

Ask once:
> "Here is the cluster topology for the selected offerings. Confirm or edit."

Wait for confirmation before proceeding.

---

#### Fast Path Step 5 — Container → Plane Mapping Grid

Pre-fill from **Confluence Table 5 — Container → Plane & Instance Type Mapping**.

| Container Name | Plane | Instance Type |
|------|------|------|
| *(from Table 5)* | *(from Table 5)* | *(from Table 5)* |

Ask once:
> "Here is the container-to-plane mapping. Confirm or edit."

Wait for confirmation before proceeding.

---

#### Fast Path Step 6 — External Systems Grid

Pre-fill from **Confluence Table 6 — External Systems Deployment Placement** (filtered to confirmed offerings only).

| System Name | Offering(s) | Plane / Hosting | Deployment Node |
|------|------|------|------|
| *(from Table 6)* | *(from Table 6)* | *(from Table 6)* | *(from Table 6)* |

Ask once:
> "Here are the external systems and their placement for the selected offerings. Remove any that should not appear, or confirm as-is."

Wait for confirmation before proceeding.

---

### Slow Path — No Confluence Tables

When Confluence deployment tables are **not present**, follow the **Prompt Contract** later in this file as the single source of truth for the slow-path workflow.

Do **not** use any older step sequence or legacy grid definitions in this section. The exact:

- step order,
- prompt wording,
- grid names,
- column names, and
- confirmation checkpoints

must match the Prompt Contract exactly.

In the slow path, present each Prompt Contract step in order, using its defined prefilled or blank grid, and wait for explicit user confirmation before advancing to the next step.
|------|------|------|
| Cloud/Hosting | Text | Azure / AWS / OCI / On-Prem |
| Region | Text | e.g. Ohio, Frankfurt, Virginia |
| Network | Text | VNet / VPC / Data Center Network |
| Notes | Text | Optional clarifications |

---

#### Step 3 — Clusters & Planes Grid

| Column | Type | Notes |
|------|------|------|
| Plane | Enum | Control Plane / Application Plane |
| Cluster Name | Text | Kubernetes or logical cluster |
| Region | Text | Deployment region |
| Isolation Model | Enum | Dedicated / Shared |

---

#### Step 4 — Container Deployment Mapping Grid

| Column | Type | Notes |
|------|------|------|
| Container Name | Text | Must match container skill output |
| Plane | Enum | Control / Application |
| Cluster | Text | Deployment target |
| Instance Type | Text | Pod, Job, Worker, Service |

---

#### Step 5 — Data Stores & External Systems Grid

Pre-populate this grid using **every external system confirmed in `## Stage 2a Output`**. Do not use a hardcoded example list. Present the full prefilled grid to the user and ask them to remove any systems that should not appear in the deployment diagram for this offering.

| Column | Type | Notes |
|------|------|------|
| Name | Text | From Stage 2a confirmed external systems |
| Type | Text | External System / Data Store |
| Hosting | Text | Control Plane / App Plane / Customer-hosted / Other |
| Region | Text | If applicable |

---

## Deployment DSL Generation Rules

- Always nest deployment nodes in this hierarchy:  
  **Environment → Cloud/Hosting → Region → Network → Cluster**
- Use `deploymentNode` only (never `container` definitions here)
- Reference containers by **exact name** from the container diagram
- Show Control Plane and Application Plane as separate nodes or labels
- Avoid over-modeling namespaces unless explicitly requested
- For every external system confirmed in the External Systems step (Fast Path: Confirmation 5; Slow Path: Step 5), emit a `softwareSystemInstance` inside the deployment node that matches the confirmed hosting location:
  - Control Plane → nest inside the Control Plane region node, in a `deploymentNode "Vertex Platform Services"` alongside the AKS/cluster node
  - App Plane → nest inside the App Plane region node
  - Customer-hosted → place in a separate top-level `deploymentNode "Customer"` node
  - Never omit a confirmed external system from the deployment model

---

## Non-Goals

This skill does **not**:

- Design new infrastructure
- Infer autoscaling or sizing characteristics
- Create environment-specific variants unless explicitly confirmed

---

## Output Guarantee

Once all steps are confirmed, the skill output is guaranteed to be:

- Deterministic
- Structurizr-compatible
- Ready for Deployment View DSL generation

---

## Prompt Contract

> ⛔ **BLOCKING RULE:** Do NOT write any deployment DSL until every grid below has been explicitly confirmed by the user.
> By default, do NOT use auto-accept rules for deployment confirmation; however, when the documented `auto-accept-inferred-sys-info` flow is enabled, you may auto-confirm inferred, pre-filled deployment grids instead of blocking for manual confirmation.
> Do NOT advance to the next grid until the user has confirmed the current one, unless confirmation is being provided via the documented `auto-accept-inferred-sys-info` flow.
> Do NOT skip any grid even if you believe the data is obvious.

The path taken depends on the presence of **"C4 Deployment Diagram Metadata"** tables in the source Confluence page.

---

### Fast Path — Confluence Tables Present (6 confirmations)

Use this path when all six tables are found on the Confluence page.

> ✅ **Announce to the user:** "I found deployment metadata tables on the Confluence page. I'll pre-fill each grid from those tables and ask you to confirm or edit each one — 5 confirmations instead of 17 questions."

#### Confirmation 1 — Deployment Offerings

Pre-fill from **Table 1 — Deployment Offerings**. Show the full grid.

Ask:
> "Here are the deployment offerings from the Confluence page. Which offerings should be included in this diagram run? Edit, add, or remove rows — then confirm."

⛔ Wait for explicit confirmation before proceeding.

---

#### Confirmation 2 — Offerings, Plane and Cloud provider

Pre-fill from **Table 2 — Offerings, Plane and Cloud provider**, filtered to confirmed offerings only.

Ask:
> "Here are the planes and cloud providers for the selected offerings. Confirm or edit."

⛔ Wait for explicit confirmation before proceeding.

---

#### Confirmation 3 — Cloud Providers & Regions 

Pre-fill from **Table 3 — Cloud Providers & Regions**, filtered to confirmed offerings and cloud providers.

Ask:
> "Here are the cloud providers for the selected offerings. Confirm or edit."

⛔ Wait for explicit confirmation before proceeding.

---

#### Confirmation 4 — Cluster Topology

Pre-fill from **Table 4— Cluster Topology**, filtered to confirmed offerings only.

Ask:
> "Here is the cluster topology for the selected offerings. Confirm or edit."

⛔ Wait for explicit confirmation before proceeding.

---

#### Confirmation 5 — Container → Plane Mapping

Pre-fill from **Table 5 — Container → Plane & Instance Type Mapping**.

Ask:
> "Here is the container-to-plane mapping. Confirm or edit."

⛔ Wait for explicit confirmation before proceeding.

---

#### Confirmation 6 — External Systems Placement

Pre-fill from **Table 6 — External Systems Deployment Placement**, filtered to confirmed offerings only.

Ask:
> "Here are the external systems and their deployment placement for the selected offerings. Remove any that should not appear, or confirm as-is."

⛔ Wait for explicit confirmation before proceeding to DSL generation.

---

### Slow Path — No Confluence Tables (editable confirmation grids)

Use this path when the Confluence page does **not** contain the "C4 Deployment Diagram Metadata" section.

> ℹ️ **Announce to the user:** "No deployment metadata tables were found on the Confluence page. I'll collect the full deployment details using editable tables and confirm each step before continuing."

Follow the same interaction model as the confirmed-table path:

- For each step below, present a single **editable grid/table**.
- **Pre-fill** the grid with any values already known from the user request, prior stages, or confirmed context.
- If a value is unknown, leave it blank or mark it as `TBD`.
- Ask the user to **edit, complete, remove rows, or confirm as-is**.
- ⛔ Do **not** proceed to the next step until the current grid has been explicitly confirmed.

#### Step 1 — Deployment Context

Present an editable grid for the deployment context with these columns:

- Deployment Name
- Deployment Offering
- Environment
- Management Boundary (Vertex-managed / Customer-managed)

Seed rows from any known environments already mentioned by the user or earlier stages.

Ask:
> "Here is the deployment context I have so far. Please fill in or correct any missing values, remove rows that do not apply, and confirm when this table is accurate."

---

#### Step 2 — Regions & Networks

Present an editable grid for regions and networks with these columns:

- Hosting Type / Cloud Provider
- Environment
- Region
- Virtual Network / VPC / Data-Center Network Name

Pre-fill from known offering, environment, or hosting details when available.

Ask:
> "Here are the regions and network boundaries for this deployment. Please complete or correct the table and confirm when it is accurate."

---

#### Step 3 — Control Plane vs Application Plane

Present an editable grid for plane topology with these columns:

- Separate Control Plane and Application Plane? (Yes / No)
- Deployment Model (Separate Clusters / Shared Cluster with Namespaces / Other)
- Plane
- Region(s)

Include one row per plane when applicable.

Ask:
> "Here is the control-plane and application-plane topology I have so far. Please edit as needed and confirm before we continue."

---

#### Step 4 — Clusters

Present an editable grid for clusters with these columns:

- Cluster Name
- Plane (Control / Application)
- Region
- Tenancy (Dedicated / Shared)
- Notes

Pre-fill from the confirmed topology and any cluster names already known.

Ask:
> "Here are the Kubernetes clusters or logical clusters for this deployment. Please add, remove, or correct rows and confirm when the table is accurate."

---

#### Step 5 — Container Mapping & External Systems

**Part A — Container Deployment Mapping**

Present an editable grid using the containers from the confirmed C4 Container Diagram, with these columns:

- Container
- Plane
- Cluster / Logical Host
- Instance Type (Service / Worker / Job / Database / Other)

Pre-fill the Container column from the C4 Container Diagram and fill any other known values when available.

Ask:
> "Here is the deployment mapping for containers from the C4 Container Diagram. Please complete or correct the plane, host, and instance-type fields, then confirm."

⛔ Wait for explicit confirmation before presenting Part B.

**Part B — External Systems Placement**

First, present an editable selection grid containing the full list of external systems confirmed in `## Stage 2a Output`, with these columns:

- External System
- Include in Deployment Diagram? (Yes / No)
- Offering / Environment Notes

Ask:
> "Here are the external systems confirmed in Stage 2a. Mark which ones should appear in the deployment diagram for this deployment, remove any that do not apply, and confirm the selection table."

After the selection table is confirmed, present a second editable placement grid for the selected systems with these columns:

- External System
- Deployment Placement
- Region / Network
- Notes

Allowed placement values:
- Control Plane (Vertex-managed)
- App Plane (Vertex-managed)
- Customer-hosted (external)
- Other (describe)

Group systems that share a deployment location into separate rows only when needed for clarity.

Ask:
> "Here is the deployment placement for the selected external systems. Please edit any placements or notes and confirm when this table is accurate."

⛔ Wait for explicit confirmation of the final external-systems placement grid before proceeding to DSL generation.
