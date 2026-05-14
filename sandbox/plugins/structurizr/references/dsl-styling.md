# DSL Styling Reference

## Container Name Based Styles
Infer the container type from the name and apply a
visual badge automatically — the user does not need to tag these manually:

| Name contains… | Badge | DSL shape |
|---|---|---|
| "database", "db", "store", "cache" | `DB` — cylinder icon | `Cylinder` |
| "queue", "dead letter" | `Q` — pipe icon | `Pipe` |
| "topic", "event bus", "bus" | `T` — pipe icon | `Pipe` |
| "api gateway", "gateway", "gw" | `GW` — component icon | `Component` |

Matching is case-insensitive. If a name matches more than one pattern, apply
the first match in the order above.

## Value Stream-Based Element Styles

| Value Stream | Color | Hex | Product names and aliases |
|---|---|---|---|
| `External` | Cool Gray | `#8C8496` | *(default — apply when no other match)* |
| `Tax Determination` | Dark Green | `#336600` | Tax calculation, Calc, Vertex On Demand, VoD, Vertex on Premise, VoP, Vertex Cloud Calc, Vertex Cloud Config |
| `E Invoicing` | Emerald Green | `#00994D` | Vertex E Invoicing, eInvoicing, e-Invoicing |
| `Compliance & Returns` | Deep Forest Green | `#006600` | Returns, Express Returns, NA Returns, VITR, O Series Reporting, TOO |
| `Connectors` | Azure Blue | `#007FFF` | Oracle Accelerator, Workday Connector, Microsoft Connector, Connector, Coupa Connector, SAP Connector, Oracle Accelerator 2 |
| `Cloud Platform Engineering` | Teal | `#006666` | CPE, Vertex Platform Services, Authn, Authz, Temporal, Pulsar, VESPA, Notification System, Email Notifications |
| `Connector Platform Services` | Bright Teal | `#009999` | Connector Platform Services, Integration Platform Services, IPS, IPS Message Log Service, IPS Transaction Services, Connectors MFE, IPS Configs, IPS Mapping, IPS Workflow Management |
| `Content Technology & Delivery` | Dark Olive | `#666600` | TRM, DMO, GIS, Tax Content Testing |
| `Data & Insights` | Deep Jungle Green | `#006633` | VDP, Concourse, Data & Insights, Data Fabric, ITC, Indirect Tax Close |

The primary system and all its containers are always styled dark blue
(`#1061B0`) regardless of Value Stream.

## Relationship Line Styles
- Line color: use the hex color associated with the source element's Value
  Stream.
- Line style and tagging during DSL generation:
  - If the protocol name contains "Async" or "Scheduled" (case-insensitive),
    tag the relationship as `Async` so the `relationship "Async"` style
    rule applies and renders the line dashed.
  - If the protocol name does not contain "Async" or "Scheduled", do not add
    the `Async` tag; the default `relationship "Relationship"` style keeps
    the line solid.

## Styles Block

Always emit the complete styles block below. It covers all Value Stream
colours, container shapes, and element types. Do not omit rules that have
no current matches — keeping the block complete avoids incremental additions
as the model grows.

```dsl
styles {
  element "Person" {
    shape Person
    background #08427b
    color #ffffff
  }
  element "Software System" {
    background #1061B0
    color #ffffff
  }
  element "Container" {
    background #1061B0
    color #ffffff
  }
  element "External" {
    background #8C8496
    color #ffffff
  }
  element "Tax Determination" {
    background #336600
    color #ffffff
  }
  element "E Invoicing" {
    background #00994D
    color #ffffff
  }
  element "Compliance & Returns" {
    background #006600
    color #ffffff
  }
  element "Connectors" {
    background #007FFF
    color #ffffff
  }
  element "Cloud Platform Engineering" {
    background #006666
    color #ffffff
  }
  element "Connector Platform Services" {
    background #009999
    color #ffffff
  }
  element "Content Technology & Delivery" {
    background #666600
    color #ffffff
  }
  element "Data & Insights" {
    background #006633
    color #ffffff
  }
  element "Database" {
    shape Cylinder
  }
  element "Queue" {
    shape Pipe
  }
  element "Topic" {
    shape Pipe
  }
  relationship "Relationship" {
    dashed false
  }
  relationship "Async" {
    dashed true
  }
}
```

## Export Note
These shapes render correctly in the Structurizr diagram
viewer (playground, local, and server). They are not fully supported in
Mermaid or PlantUML exports — those formats render all elements as standard
boxes regardless of the shape setting. If the user intends to export to
Mermaid or PlantUML, flag this limitation so they are not surprised.
