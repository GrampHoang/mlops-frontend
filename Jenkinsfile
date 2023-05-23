#!/usr/bin/env groovy
library 'mlops-shared-lib'

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
        FE_IMAGE_NAME="mlops-frontend"
        SERVER_ID="Jfrog-mlops-model-store"

        //The name and version for the backend image to be built
        IMAGE_TO_PUSH="${FE_IMAGE_NAME}:${params.VERSION}"

        // Define default job parameters
        propagate = true

    }

    stages {
        stage('Precheck pipeline parameters'){
            steps {
                script {
                    echo "Validating parameters..."
                    if (!params.VERSION?.trim()) {
                        error "VERSION is a mandatory parameter"
                        return
                    }
                    //Check semantic rule for parameter
                    semanticVersionCheck(this,params.VERSION)
                }
            }
        }

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
                        sh "docker build --no-cache -t ${env.SERVER_URL}/${env.DOCKER_REPO}/${IMAGE_TO_PUSH} ."
                        sh "docker login -u ${USERNAME} -p ${PASSWORD} ${env.SERVER_URL}"

                        // sh "docker tag ${IMAGE_TO_PUSH} artifactorymlopsk18.jfrog.io/${env.DOCKER_REPO}/${IMAGE_TO_PUSH}"
                        sh "docker push ${env.SERVER_URL}/${env.DOCKER_REPO}/${IMAGE_TO_PUSH}"
                    }
                }
            }
            post {
                success {
                    script { 
                        sh "docker image rm -f ${env.SERVER_URL}/${env.DOCKER_REPO}/${IMAGE_TO_PUSH}" 
                    }
                }
            }
        }

    }
    post {
        success {
            slackSend(color:"good", message:"To: <!here|here>, Build deployed successfully - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
        }

        failure {
            slackSend(color:"#ff0000",message: "To: <!channel|channel>, Build failed  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
        }
        always {
            cleanWs()
        }
    }
}