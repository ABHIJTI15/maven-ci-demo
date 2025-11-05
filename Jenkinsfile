pipeline {
    agent any

    tools {
        maven 'Maven'  // Jenkins mein Maven tool name
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Pulling code from GitHub...'
                git url: 'https://github.com/ABHIJTI15/maven-ci-demo.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
                echo 'Build Complete!'
            }
        }

        stage('Test') {
            steps {
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
                sh 'mvn package'
                echo 'WAR File Created: target/hello-world.war'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo 'Deploying to Tomcat...'
                sh 'cp target/hello-world.war /opt/tomcat/webapps/'
                echo 'Deployed! App live at http://localhost:8081/hello-world/'
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline SUCCESS!'
        }
        failure {
            echo 'Pipeline FAILED!'
        }
    }
}