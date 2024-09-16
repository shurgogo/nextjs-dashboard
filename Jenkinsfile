pipeline {
    agent any    //表示使用 jenkins 集群中的任意一个

    stages {
        stage('构建') {
            steps {
                withDockerContainer('node', args: '-e NODE_ENV=production') {
                    // some block
                    sh 'node -v'
                    sh 'npm config set registry https://registry.npmmirror.com'
                    sh 'npm install'
                    sh 'npm run next:build'
                }
            }
        }

        stage('制品'){
         steps {
            // cd /var/jenkins_home/workspace/nextjs-dashboard/.vitepress/dist
             dir('.vitepress/dist') {
                 // some block
                 sh 'ls -al'
                 sh 'tar -zcvf docs.tar.gz *'
                 archiveArtifacts artifacts: 'docs.tar.gz',
                                                allowEmptyArchive: true,
                                                fingerprint: true,
                                                onlyIfSuccessful: true
                 sh 'ls -al'
             }
         }
        }

        stage('部署'){
             steps {
                 dir('.vitepress/dist') {
                                 sh 'ls -al'
                                 writeFile file: 'Dockerfile',
                                           text: '''FROM nginx
ADD docs.tar.gz /usr/share/nginx/html/'''
                                 sh 'cat Dockerfile'
                                 sh 'docker build -f Dockerfile -t docs-app:latest .'
                                 sh 'docker rm -f app'
                                 sh 'docker run -d -p 80:80 --name app docs-app:latest'
                 }
             }
        }
    }
}