POSTGRES_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my-pg)
sed -i "s/\${POSTGRES_HOST}/$POSTGRES_IP/" .env.prod


