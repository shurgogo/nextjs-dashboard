pipeline {
    agent any    //表示使用 jenkins 集群中的任意一个

    stages {
        stage('准备环境') {
            steps {
                // 注入环境变量到 .env.production
                sh 'chmod +x setup.sh'
                sh './setup.sh'

                // 因为 jenkins 容器绑定了本地存储，需要清理上次流水线遗留内容
                // 否则类似于 mkdir 的命令会报错（重复创建文件夹）
                sh 'chmod +x clean.sh'
                sh './clean.sh'
            }
        }
        // 添加 node_module
        stage('构建APP') {
            steps {
                withDockerContainer(image: 'node', args: '-e NODE_ENV=production') {
                    sh 'npm cache clean --force'
                    sh 'npm i --registry https://registry.npmmirror.com --force'
                    sh 'npm run build'
                }
            }
        }

        stage('生成制品') {
            steps {
                sh 'mkdir tmp'
                // cd /var/jenkins_home/workspace/nextjs-dashboard/tmp/
                dir('tmp') {
                    sh 'mkdir .next'
                    sh 'cp ../.env.production .'
                    sh 'cp -r ../public ./public'
                    sh 'cp -r ../.next/* ./.next/'
                    sh 'mv ./.next/standalone/* .'
                }
                sh 'tar -zcvf dash.tar.gz -C ./tmp .'
                archiveArtifacts artifacts: 'dash.tar.gz',
                                                allowEmptyArchive: true,
                                                fingerprint: true,
                                                onlyIfSuccessful: true
            }
        }

        stage('部署') {
            steps {
                writeFile file: 'Dockerfile',
                                        text: '''FROM node
WORKDIR /app
ADD dash.tar.gz /app
EXPOSE 3000
CMD ["node", "server.js"]
'''
                sh 'docker build -f Dockerfile -t dash-app:v1 .'
                sh 'docker rm -f dash-app'
                sh 'docker run -d -p 3000:3000 --name dash-app dash-app:v1'
            }
        }
    }
}
