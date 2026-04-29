# Alert Trigger Scripts

Run these from the project VM or any machine with Azure CLI access and network reachability to the Application Gateway public IP.

- `trigger-backend-unhealthy.sh`: drives the App Gateway backend health alert
- `trigger-app-load.sh`: drives web app CPU pressure
- `trigger-sql-load.sh`: drives SQL / API load
