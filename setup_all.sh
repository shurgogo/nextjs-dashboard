# pg
docker run --name my-pg -d \
--env=POSTGRES_USER=postgres \
--env=POSTGRES_PASSWORD=postgres \
--env=PGDATA=/var/lib/postgresql/data \
-v /pg-data:/var/lib/postgresql/data \
-p 5432:5432 \
--restart=no \
postgres

# jenkins
docker run --name my-jk -d \
-p 8080:8080 \
-p 50000:50000 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/bin/docker:/usr/bin/docker \
-v /jenkins-data:/var/jenkins_home \
jenkins/jenkins:2.462.2-jdk17

# node
