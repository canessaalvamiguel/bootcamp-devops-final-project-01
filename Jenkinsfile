pipeline {

  agent any/*{
    docker { image 'google/cloud-sdk:latest' }
  }*/

   environment {
      GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-deployer')
      PROJECT_ID = 'level-ward-423317-j3'
      GITHUB_REPO = 'https://github.com/canessaalvamiguel/bootcamp-devops-final-project-01.git'
      DOCKER_IMAGE_NAME = 'avatares-devops-frontend'
      DOCKERFILE_DIR = 'web'
  }

  stages {
    stage('Test') {
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
    stage('Run gcloud command') {
      steps {
          script {
              sh 'gcloud compute instances list'
          }
       }
    }
    stage('Build Docker Images') {
      steps {
          sh 'docker build -t avatares-devops-frontend ./web -f ./web/Dockerfile'
      }
    }
  }
}