pipeline {
  agent any
    stage('Build') {
      def message = 'Hello, World!'
 
      googleCloudBuild \
        credentialsId: 'jinked-net',
        source: local('src'),
        request: file('Dockerfile'),
    }
}