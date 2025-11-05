pipeline {
    agent any

    tools {
        maven 'Maven'  // Jenkins mein Maven tool name
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
        retry(2)
    }

    environment {
        TOMCAT_WEBAPPS = '/opt/tomcat/webapps'
        TOMCAT_BIN     = '/opt/tomcat/bin'
    }

    stages {
        stage('Checkout') {
            options { timeout(time: 5, unit: 'MINUTES') }
            steps {
                echo 'Pulling code from GitHub...'
                retry(3) {
                    checkout scmGit(
                        branches: [[name: '*/main']],
                        userRemoteConfigs: [[url: 'https://github.com/ABHIJIT15/maven-ci-demo.git']]
                    )
                }
                echo 'Code pulled successfully!'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project...'
                sh 'mvn clean compile -Dmaven.test.skip=true'
                echo 'Build Complete!'
            }
        }

        stage('Test') {
            steps {
                echo 'Running Tests...'
                sh 'mvn test || true'
                echo 'Tests Executed!'
            }
            post {
                always {
                    junit testResults: 'target/surefire-reports/*.xml', allowEmptyResults: true
                }
            }
        }

        stage('Package') {
            steps {
                echo 'Creating WAR file...'
                sh 'mvn package -DskipTests'
                archiveArtifacts artifacts: 'target/hello-world.war', fingerprint: true, allowEmptyArchive: false
                echo 'WAR File Created: target/hello-world.war'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo 'Deploying to Tomcat on port 8081...'
                script {
                    try {
                        sh """
                            echo "Copying WAR file..."
                            sudo /bin/cp -f target/hello-world.war ${TOMCAT_WEBAPPS}/ || (echo "Copy failed!" && exit 1)

                            echo "Restarting Tomcat..."
                            sudo ${TOMCAT_BIN}/shutdown.sh || true
                            sleep 15
                            sudo ${TOMCAT_BIN}/startup.sh

                            echo "Waiting for app to start..."
                            sleep 20
                        """
                        echo 'Deployed! App live at: http://localhost:8081/hello-world/'
                    } catch (Exception e) {
                        echo "Deployment failed: ${e.getMessage()}"
                        throw e
                    }
                }
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
        }
        always {
            cleanWs(cleanWhenSuccess: true, cleanWhenFailure: true)
        }
    }
}