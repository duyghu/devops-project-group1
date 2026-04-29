# Burger Builder Azure DevOps Project

Production-style Azure deployment for a 3-tier Burger Builder application. The solution uses a React/TypeScript/Vite frontend, a Spring Boot backend, Azure SQL Database, private networking, Application Gateway WAF v2 as the only public entry point, Terraform for provisioning, Ansible for SonarQube VM automation, GitHub Actions for CI/CD, and Azure Monitor for observability.

## Repository Structure

```text
.
├── .github/workflows/
├── backend/
├── config/ansible/
│   ├── inventories/{dev,prod}
│   ├── playbooks/sonarqube.yml
│   └── roles/sonarqube
├── docs/
│   ├── architecture-diagram.svg
│   └── runbook.md
├── frontend/
├── infra/terraform/
└── scripts/alerts/
```

## Architecture

- Only Azure Application Gateway WAF v2 is public.
- `/` routes to the frontend web app.
- `/api/*` routes to the backend web app.
- Frontend and backend App Services have public network access disabled.
- Azure SQL Database has public network access disabled and is reached through a private endpoint.
- Key Vault is private through a private endpoint and private DNS.
- Application Insights and Log Analytics are used for telemetry and diagnostics.

Architecture diagram: [docs/architecture-diagram.svg](/Users/duyguu16/Documents/conference/group1/project/docs/architecture-diagram.svg)

## Prerequisites

- Azure CLI authenticated to the target subscription
- Terraform `>= 1.6`
- Docker
- Node.js 20+
- Java 21 + Maven
- Ansible
- GitHub repository secrets:
  - `AZURE_CLIENT_ID`
  - `AZURE_TENANT_ID`
  - `AZURE_SUBSCRIPTION_ID`
  - `SONAR_TOKEN`
  - `SONAR_HOST_URL`

## Provision with Terraform

```bash
cd infra/terraform
terraform init -backend-config=backend.hcl
terraform workspace select -or-create=true dev
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Terraform provisions:

- Resource group
- VNet and subnets
- Application Gateway WAF v2
- Frontend and backend Linux Web Apps
- App Service VNet integration
- Private endpoints for frontend, backend, SQL, and Key Vault
- Private DNS zones and VNet links
- Azure SQL server and database
- ACR
- Application Insights + Log Analytics
- Metric alerts for:
  - App Gateway backend health
  - Frontend CPU
  - Backend CPU
  - SQL utilization

## Configure SonarQube with Ansible

```bash
cd config/ansible
ansible-galaxy collection install -r requirements.yml
ansible-playbook playbooks/sonarqube.yml
ansible-playbook -i inventories/prod/hosts.ini playbooks/sonarqube.yml
```

The SonarQube configuration is role-based and includes:

- Docker installation
- Docker service enablement
- Required kernel tuning
- Docker Compose rendering
- SonarQube + PostgreSQL startup

## Deploy with GitHub Actions

### Infrastructure

Workflow: `.github/workflows/infra.yml`

- Terraform init
- Workspace selection
- Terraform fmt
- Terraform validate
- Terraform plan
- Terraform apply

### Frontend

Workflow: `.github/workflows/frontend.yml`

- `npm ci`
- `npm run lint`
- `npm run test -- --run`
- `npm run build`
- Docker build
- Trivy scan
- ACR push
- Azure Web App deploy

### Backend

Workflow: `.github/workflows/backend.yml`

- Maven verify
- Docker build
- Trivy scan
- ACR push
- Azure Web App deploy

### SonarQube Analysis

Workflow: `.github/workflows/build.yml`

- Backend Maven verify
- SonarQube analysis

## Validate the Application

### Public entry point

```bash
curl -i http://<APP_GW_PUBLIC_IP>/
curl -i http://<APP_GW_PUBLIC_IP>/api/ingredients
curl -i http://<APP_GW_PUBLIC_IP>/api/health
```

Expected:

- `/` returns the frontend UI
- `/api/ingredients` returns backend JSON
- `/api/health` returns `200 OK`

### Database write and read proof

1. Open the app through the Application Gateway public IP.
2. Build a burger and place an order.
3. Read the order history back:

```bash
curl "http://<APP_GW_PUBLIC_IP>/api/orders/history?email=<customer-email>"
```

### Private networking checks

- Web apps: public network access disabled
- SQL: public network access disabled
- Private DNS zones present:
  - `privatelink.azurewebsites.net`
  - `privatelink.database.windows.net`
  - `privatelink.vaultcore.azure.net`

## Monitoring and Alerts

Implemented alerts:

- `alert-appgw-backend-health`
- `alert-frontend-cpu-high`
- `alert-backend-cpu-high`
- `alert-sql-high-utilization`

### Trigger scripts

Run from the Azure VM:

```bash
chmod +x scripts/alerts/*.sh
./scripts/alerts/trigger-backend-unhealthy.sh 600
./scripts/alerts/trigger-app-load.sh 600 20
./scripts/alerts/trigger-sql-load.sh 600 8
```

## Kusto Queries

Application Gateway diagnostics:

```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.NETWORK"
| where Category contains "ApplicationGateway"
| project TimeGenerated, Resource, Category, OperationName, httpStatus_d, requestUri_s
| order by TimeGenerated desc
```

Backend request failures:

```kusto
AppRequests
| where AppRoleName contains "backend"
| summarize failures=countif(Success == false), total=count() by bin(TimeGenerated, 5m), Name
| order by TimeGenerated desc
```

SQL dependency latency:

```kusto
AppDependencies
| where Type == "SQL"
| summarize avgDurationMs=avg(DurationMs), calls=count() by bin(TimeGenerated, 5m), Target
| order by TimeGenerated desc
```

## Submission Checklist

- Architecture diagram in `docs/architecture-diagram.svg`
- Runbook in `docs/runbook.md`
- Working app screenshots through Application Gateway
- Azure resource group screenshot
- Fired alert screenshots
- Dashboard or metrics screenshots
- Demo script below
- Final `terraform apply` output saved from a clean plan
- Ansible rerun showing idempotent results

## 3–5 Minute Demo Script

1. Show the architecture diagram and explain the single public Application Gateway.
2. Open the frontend through the Application Gateway public IP.
3. Call `/api/ingredients` and `/api/health`.
4. Place an order and show it can be read back.
5. Show Azure SQL private endpoint and disabled public access.
6. Show alert rules in Azure Monitor.
7. Run one alert trigger script and show the alert firing.
8. Show the GitHub Actions pipelines and SonarQube workflow.

## Operations

Runbook: [docs/runbook.md](/Users/duyguu16/Documents/conference/group1/project/docs/runbook.md)
