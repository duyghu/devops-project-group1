# Runbook

## Provision Infrastructure

```bash
cd infra/terraform
terraform init -backend-config=backend.hcl
terraform workspace select -or-create=true dev
terraform plan -out=tfplan
terraform apply tfplan
```

## Configure SonarQube VM

```bash
cd config/ansible
ansible-galaxy collection install -r requirements.yml
ansible-playbook playbooks/sonarqube.yml
ansible-playbook -i inventories/prod/hosts.ini playbooks/sonarqube.yml
```

## Deploy Applications

Applications deploy from GitHub Actions on pushes to `main`.

- `infra.yml` provisions or updates infrastructure
- `frontend.yml` builds, tests, scans, and deploys the frontend
- `backend.yml` builds, tests, scans, and deploys the backend
- `build.yml` runs backend SonarQube analysis

## Validate the Environment

```bash
curl -i http://<APP_GW_PUBLIC_IP>/
curl -i http://<APP_GW_PUBLIC_IP>/api/ingredients
curl -i http://<APP_GW_PUBLIC_IP>/api/health
```

Expected:

- `/` returns the frontend UI
- `/api/ingredients` returns JSON from the backend
- `/api/health` returns `200 OK`

## Monitoring Demo

Run from the project VM:

```bash
chmod +x scripts/alerts/*.sh
./scripts/alerts/trigger-backend-unhealthy.sh 600
./scripts/alerts/trigger-app-load.sh 600 20
./scripts/alerts/trigger-sql-load.sh 600 8
```

## Recovery

If the backend app is left stopped after a demo:

```bash
az webapp start --resource-group rg-burgerbuilder-group1 --name app-bb-backend-dev-group1
```
