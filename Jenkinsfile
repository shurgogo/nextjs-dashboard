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
                sh 'rm -rf tmp'
                sh 'rm -rf dash.tar.gz'
                sh 'mkdir tmp'
                // cd /var/jenkins_home/workspace/nextjs-dashboard/tmp/
                dir('tmp') {
                    sh 'mkdir .next'
                    sh 'cp -r ../public ./public'
                    sh 'mv ../.next/standalone/* .'
                    sh 'cp -r ../.next/* ./.next/*'
                    echo 'pwd'
                    sh 'ls -al'
                }
                sh 'pwd'
                sh 'ls -al'
                sh 'tar -zcvf dash.tar.gz -C ./tmp .'
                archiveArtifacts artifacts: 'dash.tar.gz',
                                                allowEmptyArchive: true,
                                                fingerprint: true,
                                                onlyIfSuccessful: true
            // dir('.next') {
            //     sh 'pwd'
            //     sh 'cp -r ../public ./public'
            //     sh 'tar -zcvf dash.tar.gz -C ./standalone .'
            //     archiveArtifacts artifacts: 'dash.tar.gz',
            //                                 allowEmptyArchive: true,
            //                                 fingerprint: true,
            //                                 onlyIfSuccessful: true
            // }
            }
        }

        stage('部署') {
            steps {
                sh 'pwd'
                sh 'ls -al'
                writeFile file: 'Dockerfile',
                                        text: '''FROM node
WORKDIR /app
ADD dash.tar.gz /app
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
