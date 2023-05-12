#!/usr/bin/env groovy

pipeline {
    agent any

    parameters {
        string(name: 'VERSION', description: 'The version for frontend image')
    }
    options {
        timeout(time: 1, unit: 'HOURS')
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        //Default artifactory connect info
        BE_IMAGE_NAME="mlops-frontend"
        SERVER_ID="Jfrog-mlops-model-store"
        DOCKER_REPO="mlops-docker-images"

        //The name and version for the backend image to be built
        IMAGE_TO_PUSH="${BE_IMAGE_NAME}:${params.VERSION}"

        // Define default job parameters
        propagate = true

    }

    stages {

        stage('Build and Push Docker Image') {
            steps {
                script {
                    
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'artifactory_user',
                            usernameVariable: 'USERNAME',
                            passwordVariable: 'PASSWORD'
                        )
                    ]) {
                        // Build the Docker image
                        sh "docker build -t artifactorymlopsk18.jfrog.io/${DOCKER_REPO}/${IMAGE_TO_PUSH} ."
                        sh "docker login -u ${USERNAME} -p ${PASSWORD} artifactorymlopsk18.jfrog.io"

                        // sh "docker tag ${IMAGE_TO_PUSH} artifactorymlopsk18.jfrog.io/${DOCKER_REPO}/${IMAGE_TO_PUSH}"
                        sh "docker push artifactorymlopsk18.jfrog.io/${DOCKER_REPO}/${IMAGE_TO_PUSH}"
                    }
                }
            }
            post {
                success {
                    script { 
                        sh "docker image rm -f artifactorymlopsk18.jfrog.io/${DOCKER_REPO}/${IMAGE_TO_PUSH}" 
                    }
                }
            }
        }

    }
    post {
        always {
            cleanWs()
        }
    }
}