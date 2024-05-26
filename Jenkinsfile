pipeline {

  agent any

   environment {
      GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-deployer')
      PROJECT_ID = 'level-ward-423317-j3'
      VERSION = "${env.BUILD_NUMBER}"
      DEPLOYMENT_FILE_FRONTEND = 'k8s/frontend-deployment.yml'
      DEPLOYMENT_FILE_BACKEND  = 'k8s/backend-deployment.yml'
      CLUSTER_NAME = 'lab-cluster'
      CLUSTER_LOCATION = 'us-west1-c'
      CLUSTER_LOCATION_REGISTRY = 'us-west1-docker'
      CREDENTIALS_KUBE_PLUGIN_ID = 'sa-kubectl'
      IMAGE_NAME_BACKEND = 'avatares-devops-backend'
      IMAGE_NAME_FRONTEND = 'avatares-devops-frontend'
      REPO_NAME_BACKEND = 'avatares-devops-backend'
      REPO_NAME_FRONTEND = 'avatares-devops-frontend'
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
          sh "docker build -t ${IMAGE_NAME_FRONTEND}:latest ./web -f ./web/Dockerfile --network=host"
          sh "docker build -t ${IMAGE_NAME_BACKEND}:latest ./api -f ./api/Dockerfile --network=host"
      }
    }
    stage('Tag Docker Images') {
      steps {
          sh "docker tag ${IMAGE_NAME_FRONTEND}:latest ${IMAGE_NAME_FRONTEND}:${VERSION}"          
          sh "docker tag ${IMAGE_NAME_FRONTEND}:${VERSION} ${CLUSTER_LOCATION_REGISTRY}.pkg.dev/${PROJECT_ID}/${REPO_NAME_FRONTEND}/${IMAGE_NAME_FRONTEND}:${VERSION}"          
          sh "docker tag ${IMAGE_NAME_BACKEND}:latest ${IMAGE_NAME_BACKEND}:${VERSION}"       
          sh "docker tag ${IMAGE_NAME_BACKEND}:${VERSION} ${CLUSTER_LOCATION_REGISTRY}.pkg.dev/${PROJECT_ID}/${REPO_NAME_BACKEND}/${IMAGE_NAME_BACKEND}:${VERSION}"
      }
    }
    stage('Push images') {
      steps {
          sh "gcloud auth configure-docker ${CLUSTER_LOCATION_REGISTRY}.pkg.dev"
          sh "docker push ${CLUSTER_LOCATION_REGISTRY}.pkg.dev/${PROJECT_ID}/${REPO_NAME_BACKEND}/${IMAGE_NAME_BACKEND}:${VERSION}"
          sh "docker push ${CLUSTER_LOCATION_REGISTRY}.pkg.dev/${PROJECT_ID}/${REPO_NAME_FRONTEND}/${IMAGE_NAME_FRONTEND}:${VERSION}"        
      }
    }
    stage('Update Deployment YAML') {
      steps {
          script {
              sh "sed -i 's|PLACEHOLDER_IMAGE_VERSION|${VERSION}|g' ${DEPLOYMENT_FILE_FRONTEND}"
              sh "sed -i 's|PLACEHOLDER_IMAGE_VERSION|${VERSION}|g' ${DEPLOYMENT_FILE_BACKEND}"
          }
      }
    }
    stage('Validate Deployment YAML') {
      steps {
          script {
              sh "cat ${DEPLOYMENT_FILE_FRONTEND}"
              sh "cat ${DEPLOYMENT_FILE_BACKEND}"
          }
      }
    }
    stage('Deploy frontend to kubernetes'){
      steps{
          step([
            $class: 'KubernetesEngineBuilder', 
            projectId: env.PROJECT_ID, 
            clusterName: env.CLUSTER_NAME, 
            location: env.CLUSTER_LOCATION, 
            manifestPattern: env.DEPLOYMENT_FILE_FRONTEND, 
            credentialsId: 'sa-kubectl',
            verifyDeployments: true])
		   echo "Deployment to frontend Finished ..."
      }
    }
    stage('Deploy backend to kubernetes'){
      steps{
          step([
            $class: 'KubernetesEngineBuilder', 
            projectId: env.PROJECT_ID, 
            clusterName: env.CLUSTER_NAME, 
            location: env.CLUSTER_LOCATION, 
            manifestPattern: env.DEPLOYMENT_FILE_BACKEND, 
            credentialsId: en.CREDENTIALS_KUBE_PLUGIN_ID,
            verifyDeployments: true])
		   echo "Deployment to backend Finished ..."
      }
    }
  }
}