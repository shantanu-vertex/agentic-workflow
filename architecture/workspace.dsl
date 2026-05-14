workspace "Agentic Workflow" "Architecture model for the agentic-workflow system." {

    model {
        # People
        developer = person "Developer" "A software engineer who triggers and monitors agentic workflows."
        endUser = person "End User" "A user who benefits from automated workflow outcomes."

        # Software Systems
        agenticWorkflow = softwareSystem "Agentic Workflow" "Orchestrates AI-driven automated workflows triggered via GitHub Actions." {
            # Containers
            githubActions = container "GitHub Actions Runner" "Executes workflow jobs and dispatches events." "GitHub Actions" "CI/CD"
            agentOrchestrator = container "Agent Orchestrator" "Coordinates AI agent tasks and manages workflow state." "Node.js / Python"
            aiModel = container "AI Model API" "Provides language model capabilities for reasoning and code generation." "External API (e.g. OpenAI / Copilot)"
            repository = container "Git Repository" "Stores source code, workflow definitions, and architecture artifacts." "GitHub"
            safeOutputs = container "Safe Outputs Service" "Validates and gates all write operations to GitHub (PRs, comments, issues)." "MCP Server"
        }

        githubActionsCI = softwareSystem "GitHub" "Hosts source code, CI/CD pipelines, issues, and pull requests." "External"

        # Relationships — people
        developer -> agenticWorkflow "Triggers workflows and reviews generated outputs"
        endUser -> agenticWorkflow "Benefits from automated analysis and generated artifacts"

        # Relationships — containers
        developer -> githubActions "Dispatches workflow_dispatch events"
        githubActions -> agentOrchestrator "Invokes agent with task inputs"
        agentOrchestrator -> aiModel "Sends prompts; receives completions"
        agentOrchestrator -> repository "Reads source files and writes architecture artifacts"
        agentOrchestrator -> safeOutputs "Creates PRs, comments, and signals completion"
        safeOutputs -> githubActionsCI "Writes PRs / comments via GitHub API"
        repository -> githubActionsCI "Hosted on GitHub"

        # Deployment
        deploymentEnvironment "Production" {
            deploymentNode "GitHub Cloud" "GitHub-hosted infrastructure" "GitHub SaaS" {
                deploymentNode "Actions Runner" "GitHub-hosted Ubuntu runner" "ubuntu-latest" {
                    containerInstance githubActions
                    containerInstance agentOrchestrator
                    containerInstance safeOutputs
                }
                deploymentNode "GitHub Services" "Core GitHub platform services" "GitHub SaaS" {
                    containerInstance repository
                    containerInstance aiModel
                }
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
                background #08427b
                color #ffffff
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "External" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "CI/CD" {
                background #2e7d32
                color #ffffff
            }
        }
    }
}
