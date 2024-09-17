POSTGRES_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <pg_container_name_or_id>)
sed -i "s/\${POSTGRES_HOST}/$POSTGRES_IP/" .env.prod


