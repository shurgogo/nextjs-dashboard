POSTGRES_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my-pg)
# DASHBOARD_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dash-app)
sed -i "s/\${POSTGRES_HOST}/$POSTGRES_IP/" .env.production
# sed -i "s/\${DASHBOARD_IP}/$DASHBOARD_IP/" .env.production


