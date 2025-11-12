pipeline {
    agent any

    environment {
        ACR_LOGIN_SERVER = 'vanshdemoacr123.azurecr.io'
        IMAGE_NAME       = 'demo-app'
        AKS_NAMESPACE    = 'demo-app'
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker image') {
            steps {
                script {
                    env.BUILD_IMAGE = "${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh """
                      docker build -t ${env.BUILD_IMAGE} .
                    """
                }
            }
        }

        stage('Login & Push to ACR') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'acr-sp',
                    usernameVariable: 'ACR_USER',
                    passwordVariable: 'ACR_PASS'
                )]) {
                    sh """
                      echo "${ACR_PASS}" | docker login ${ACR_LOGIN_SERVER} \
                        -u "${ACR_USER}" --password-stdin
                      docker push ${env.BUILD_IMAGE}
                      docker logout ${ACR_LOGIN_SERVER}
                    """
                }
            }
        }

        stage('Deploy to AKS via Helm') {
            steps {
                withCredentials([file(
                    credentialsId: 'aks-kubeconfig',
                    variable: 'KUBECONFIG_FILE'
                )]) {
                    sh """
                      export KUBECONFIG=${KUBECONFIG_FILE}

                      helm upgrade --install demo-app helm/demo-app \
                        --namespace ${AKS_NAMESPACE} --create-namespace \
                        --set image.repository=${ACR_LOGIN_SERVER}/${IMAGE_NAME} \
                        --set image.tag=${env.BUILD_NUMBER}
                    """
                }
            }
        }
    }

    post {
        success {
            emailext(
                subject: "demo-app: SUCCESS (${env.BUILD_NUMBER})",
                to: 'ananda.yashaswi@quokkalabs.com, ayush.vashishth@quokkalabs.com',
                body: "Build ${env.BUILD_NUMBER} succeeded. Image: ${env.BUILD_IMAGE}"
            )
        }
        failure {
            emailext(
                subject: "demo-app: FAILED (${env.BUILD_NUMBER})",
                to: 'ananda.yashaswi@quokkalabs.com, ayush.vashishth@quokkalabs.com',
                body: "Build ${env.BUILD_NUMBER} failed. Check Jenkins logs."
            )
        }
    }
}
