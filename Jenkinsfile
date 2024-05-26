pipeline {
  agent {
    docker { image 'google/cloud-sdk:latest' }
  }
  stages {
    stage('Test') {
      steps {
        sh 'gcloud version'
      }
    }
  }
}