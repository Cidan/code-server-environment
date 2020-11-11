pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        script {
          def customImage = docker.build("code-server:${env.BUILD_ID}")
        }

      }
    }

    stage('Deploy') {
      steps {
        echo 'Deploying....'
      }
    }

  }
}