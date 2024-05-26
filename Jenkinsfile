pipeline {

  agent any/*{
    docker { image 'google/cloud-sdk:latest' }
  }*/

   environment {
      GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-deployer')
      KUBECONFIG = credentials('kubeconfig')
      PROJECT_ID = 'level-ward-423317-j3'
      GITHUB_REPO = 'https://github.com/canessaalvamiguel/bootcamp-devops-final-project-01.git'
      DOCKER_IMAGE_NAME = 'avatares-devops-frontend'
      DOCKERFILE_DIR = 'web'
      VERSION = "${env.BUILD_NUMBER}"
      DEPLOYMENT_FILE_FRONTEND = 'k8s/frontend-deployment.yml'
      DEPLOYMENT_FILE_BACKEND  = 'k8s/backend-deployment.yml'
  }

  stages {
    stage('Check gcloud installation') {
      steps {
        sh 'gcloud version'
      }
    }
    stage('Authenticate to GCP') {
      steps {
          script {
              withCredentials([file(credentialsId: 'gcp-deployer', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                  sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                  sh 'gcloud config set project $PROJECT_ID'
              }
          }
      }
    }
    stage('Build Docker Images') {
      steps {
          sh 'docker build -t avatares-devops-frontend ./web -f ./web/Dockerfile'
          sh 'docker build -t avatares-devops-backend ./api -f ./api/Dockerfile'
      }
    }
    stage('Tag Docker Images') {
      steps {
          sh "docker tag avatares-devops-frontend:latest avatares-devops-frontend:${VERSION}"          
          sh "docker tag avatares-devops-frontend:${VERSION} us-west1-docker.pkg.dev/level-ward-423317-j3/avatares-devops-frontend/avatares-devops-frontend:${VERSION}"
          sh "docker tag avatares-devops-backend:latest avatares-devops-backend:${VERSION}"       
          sh "docker tag avatares-devops-backend:${VERSION} us-west1-docker.pkg.dev/level-ward-423317-j3/avatares-devops-backend/avatares-devops-backend:${VERSION}"
      }
    }
    stage('Push images') {
      steps {
          sh "gcloud auth configure-docker us-west1-docker.pkg.dev"
          sh "docker push us-west1-docker.pkg.dev/level-ward-423317-j3/avatares-devops-backend/avatares-devops-backend:${VERSION}"
          sh "docker push us-west1-docker.pkg.dev/level-ward-423317-j3/avatares-devops-frontend/avatares-devops-frontend:${VERSION}"        
      }
    }
    stage('Deploy to GKE') {
      steps {
          script {
              sh "kubectl --kubeconfig=${KUBECONFIG} apply -f ${DEPLOYMENT_FILE_FRONTEND}"
              sh "kubectl --kubeconfig=${KUBECONFIG} apply -f ${DEPLOYMENT_FILE_BACKEND}"
          }
      }
    }
  }
}