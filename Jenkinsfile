pipeline {
    agent any

    tools {
        maven 'Maven'  // Jenkins mein Maven tool name
    }

    options {
        timeout(time: 30, unit: 'MINUTES')  // 30 min tak wait karega
        retry(2)                            // Pura pipeline 2 baar try karega
    }

    stages {
        stage('Checkout') {
            options {
                timeout(time: 5, unit: 'MINUTES')
            }
            steps {
                echo 'Pulling code from GitHub...'
                retry(3) {
                    git url: 'https://github.com/ABHIJIT15/maven-ci-demo.git', branch: 'main'
                }
                echo 'Code pulled successfully!'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project...'
                sh 'mvn clean compile'
                echo 'Build Complete!'
            }
        }

        stage('Test') {
            steps {
                echo 'Running Tests...'
                sh 'mvn test'
                echo 'Tests Passed!'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package') {
            steps {
                echo 'Creating WAR file...'
                sh 'mvn package -DskipTests'
                archiveArtifacts artifacts: 'target/hello-world.war', fingerprint: true
                echo 'WAR File Created: target/hello-world.war'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo 'Deploying to Tomcat on port 8081...'
                sh '''
                    sudo cp -f target/hello-world.war /opt/tomcat/webapps/ || echo "Copy failed, check path!"
                    sudo /opt/tomcat/bin/shutdown.sh || true
                    sleep 10
                    sudo /opt/tomcat/bin/startup.sh
                '''
                echo 'Deployed! App live at: http://localhost:8081/hello-world/'
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline SUCCESS! APP IS LIVE!'
            echo 'URL: http://localhost:8081/hello-world/'
        }
        failure {
            echo 'Pipeline FAILED! Check logs above.'
            slackSend channel: '#jenkins-alerts', color: 'danger', message: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
        }
        always {
            cleanWs()  // Workspace clean karega
        }
    }
}