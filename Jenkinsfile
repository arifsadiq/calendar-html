pipeline {
    agent any
     
    environment {
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git 'https://github.com/arifsadiq/calendar-html.git'
            }
        }
        stage('Trivy Filesystem Scan') {
            steps {
                sh 'trivy fs --format table -o trivy-fs-scan.html .'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                   sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Cal -Dsonar.projectKey=Cal'''
                }
            }
        }
        stage('Docker Build and Tag') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred1', toolName: 'docker') {
                      sh 'docker build -t calendar .'
                      sh 'docker tag calendar ari786/calendar:latest'
                    }
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                sh 'trivy image ari786/calendar:latest > trivy-calimage-scan.txt'
            }
        }
        stage('Docker Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred1', toolName: 'docker') {
                      sh 'docker push ari786/calendar:latest'
                    }
                }
            }
        }
        stage('Deploy to K8s') {
            steps {
                script{
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://192.168.1.200:6443') {
                      sh 'kubectl apply -f cal-deployment.yaml'
                      sh 'kubectl get svc -n webapps'
                    }
                }
            }
        }      
    }
}