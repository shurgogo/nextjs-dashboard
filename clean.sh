docker stop my-dash
docker rm my-dash
docker rmi dashboard:v1
docker build -t dashboard:v1 .
docker run --name my-dash -d dashboard:v1