pipeline {
    agent any    //表示使用 jenkins 集群中的任意一个

    stages {
        // build .next
        stage('构建') {
            steps {
                sh 'chmod +x setup.sh'
                sh './setup.sh'
                withDockerContainer(image: 'node', args: '-e NODE_ENV=production') {
                    sh 'npm install --registry https://registry.npmmirror.com'
                    sh 'npm run build'
                }
            }
        }

        stage('制品') {
            steps {
                // cd /var/jenkins_home/workspace/nextjs-dashboard/.next/
                dir('.next') {
                    sh 'pwd'
                    sh 'ls -al'
                    sh 'tar -zcvf dash.tar.gz -C ./standalone .'
                    archiveArtifacts artifacts: 'dash.tar.gz',
                                                allowEmptyArchive: true,
                                                fingerprint: true,
                                                onlyIfSuccessful: true
                }
            }
        }

        stage('部署') {
            steps {
                dir('.next') {
                    sh 'pwd'
                    sh 'ls -al'
                    writeFile file: 'Dockerfile',
                                           text: '''FROM node
ADD dash.tar.gz .
EXPOSE 3000
CMD ["node", "server.js"]
'''
                    sh 'cat Dockerfile'
                    sh 'docker build -f Dockerfile -t dash-app:v1 .'
                    sh 'docker rm -f dash-app'
                    sh 'docker run -d -p 3000:3000 --name dash-app dash-app:v1'
                }
            }
        }
    }
}
