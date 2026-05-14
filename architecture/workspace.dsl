workspace "Oracle Accelerator Tech Design" "Architecture workspace for the Oracle Accelerator platform, covering system context, containers, and deployment." {

    !identifiers hierarchical

    model {

        # --- People ---
        businessUser = person "Business User" "An end user who interacts with the Oracle Accelerator platform to consume accelerated business capabilities."
        developer     = person "Developer"     "A developer who configures, extends, and integrates the Oracle Accelerator platform."
        sysAdmin      = person "System Administrator" "Responsible for platform operations, monitoring, and administration."

        # --- Internal Software System ---
        oracleAccelerator = softwareSystem "Oracle Accelerator Platform" "A configurable accelerator platform built on Oracle technologies that enables rapid delivery of business solutions." {

            webApp = container "Web Application" "Provides the browser-based user interface for the platform." "React / Oracle JET" "Browser"

            apiGateway = container "API Gateway" "Handles authentication, rate-limiting, and routes API requests to internal services." "Oracle API Gateway"

            coreService = container "Accelerator Core Service" "Implements the primary business logic, workflow orchestration, and accelerator modules." "Java / Helidon"

            configService = container "Configuration Service" "Manages platform configuration, feature flags, and tenant settings." "Java / Helidon"

            notificationService = container "Notification Service" "Sends email, SMS, and in-app notifications triggered by platform events." "Node.js"

            oracleDB = container "Oracle Database" "Persistent relational store for all platform and business data." "Oracle Autonomous Database" "Database"

            objectStorage = container "Object Storage" "Stores documents, reports, and binary artefacts." "Oracle Object Storage" "FileSystem"

            messageQueue = container "Message Queue" "Decouples asynchronous processing between services." "Oracle Streaming / Kafka"
        }

        # --- External Software Systems ---
        ociIAM            = softwareSystem "Oracle Cloud IAM" "Provides identity and access management including SSO, MFA, and SCIM provisioning." "External"
        oracleIntegration = softwareSystem "Oracle Integration Cloud" "Enterprise integration platform used to connect the accelerator with third-party and on-premises systems." "External"
        enterpriseLDAP    = softwareSystem "Enterprise Directory (LDAP)" "Corporate LDAP / Active Directory used for user authentication and group management." "External"
        monitoringPlatform = softwareSystem "Observability Platform" "Centralised logging, metrics, and tracing (e.g., Oracle Management Cloud / Grafana)." "External"

        # --- Relationships: People -> Systems ---
        businessUser -> oracleAccelerator "Uses" "HTTPS"
        developer    -> oracleAccelerator "Configures and extends" "HTTPS / API"
        sysAdmin     -> oracleAccelerator "Operates and monitors" "HTTPS / SSH"
        sysAdmin     -> monitoringPlatform "Reviews dashboards and alerts" "HTTPS"

        # --- Relationships: System -> External Systems ---
        oracleAccelerator -> ociIAM            "Authenticates users via" "HTTPS / OIDC"
        oracleAccelerator -> oracleIntegration "Triggers integration flows via" "HTTPS / REST"
        oracleAccelerator -> enterpriseLDAP    "Synchronises user directory from" "LDAPS"
        oracleAccelerator -> monitoringPlatform "Publishes logs, metrics, and traces to" "HTTPS"

        # --- Relationships: Containers ---
        businessUser -> oracleAccelerator.webApp        "Accesses via browser" "HTTPS"
        developer    -> oracleAccelerator.apiGateway     "Calls APIs" "HTTPS"

        oracleAccelerator.webApp        -> oracleAccelerator.apiGateway     "Sends API requests to" "HTTPS / JSON"
        oracleAccelerator.apiGateway    -> oracleAccelerator.coreService    "Routes requests to" "HTTPS / JSON"
        oracleAccelerator.apiGateway    -> oracleAccelerator.configService  "Routes configuration requests to" "HTTPS / JSON"
        oracleAccelerator.coreService   -> oracleAccelerator.oracleDB       "Reads and writes data via" "JDBC"
        oracleAccelerator.coreService   -> oracleAccelerator.objectStorage  "Stores and retrieves files via" "HTTPS"
        oracleAccelerator.coreService   -> oracleAccelerator.messageQueue   "Publishes events to" "Kafka Protocol"
        oracleAccelerator.notificationService -> oracleAccelerator.messageQueue "Consumes events from" "Kafka Protocol"
        oracleAccelerator.configService -> oracleAccelerator.oracleDB       "Reads and writes configuration via" "JDBC"
        oracleAccelerator.coreService   -> oracleIntegration                "Invokes integration flows via" "HTTPS / REST"
        oracleAccelerator.apiGateway    -> ociIAM                           "Validates tokens via" "HTTPS / JWKS"

        # --- Deployment ---
        deploymentEnvironment "Production" {

            ociRegion = deploymentNode "OCI Region (e.g., uk-london-1)" "Oracle Cloud Infrastructure region." "Oracle Cloud Infrastructure" {

                availabilityDomain = deploymentNode "Availability Domain" "A fault-isolated data centre within the region." "OCI AD" {

                    webTier = deploymentNode "Web Tier" "OCI Load Balancer providing TLS termination and traffic distribution." "OCI Load Balancer" {
                        webAppInstance = containerInstance oracleAccelerator.webApp
                    }

                    appTier = deploymentNode "Application Tier" "OCI Container Engine for Kubernetes (OKE) cluster." "OCI OKE" {
                        apiGatewayInstance      = containerInstance oracleAccelerator.apiGateway
                        coreServiceInstance     = containerInstance oracleAccelerator.coreService
                        configServiceInstance   = containerInstance oracleAccelerator.configService
                        notifServiceInstance    = containerInstance oracleAccelerator.notificationService
                    }

                    dataTier = deploymentNode "Data Tier" "Managed Oracle Cloud data services." "OCI Data Services" {
                        dbInstance      = containerInstance oracleAccelerator.oracleDB
                        storageInstance = containerInstance oracleAccelerator.objectStorage
                        mqInstance      = containerInstance oracleAccelerator.messageQueue
                    }
                }
            }

            externalServices = deploymentNode "Oracle Cloud SaaS / PaaS" "Externally managed Oracle cloud services consumed by the platform." "Oracle Cloud" {
                iciInstance  = softwareSystemInstance ociIAM
                oicInstance  = softwareSystemInstance oracleIntegration
            }
        }
    }

    views {
        !include views/system-context.dsl
        !include views/container.dsl
        !include views/deployment.dsl

        styles {
            element "Person" {
                shape Person
                background #0572CE
                color #ffffff
            }
            element "Software System" {
                background #1168BD
                color #ffffff
            }
            element "External" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438DD5
                color #ffffff
            }
            element "Database" {
                shape Cylinder
            }
            element "Browser" {
                shape WebBrowser
            }
            element "FileSystem" {
                shape Folder
            }
        }

        theme default
    }
}
