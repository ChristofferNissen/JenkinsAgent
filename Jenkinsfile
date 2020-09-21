pipeline {
  agent {
    label 'arm'
  }
  environment {
    docker_username='stifstof'
    test_server='91.100.23.100'
  }

  stages {

    stage('clone down') {
      steps {
	git clone https://github.com/openfaas/faas-cli.git docker-jenkins-agent/faas-cli
        stash name: 'code', excludes: '.git'
      }
      post {
        always {
          sh 'ls -lah'
          deleteDir()
          sh 'ls -lah'
        }
      }
    }
    
    stage('Build docker') {
      options {
        skipDefaultCheckout()
      }
      steps {
        unstash 'code'
        sh 'base/build.sh ${BUILD_NUMBER}'
        sh 'docker-jenkins-agent/build.sh ${BUILD_NUMBER}'
      }
    }

    stage('Push to Dockerhub') {
      options {
        skipDefaultCheckout()
      }
      environment {
        DOCKERCREDS = credentials('docker_login') //use the credentials just created in this stage
      }
      when { branch "master" } 
      steps {
        unstash 'code' //unstash the repository code
        sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin' //login to docker hub with the credentials above
        sh 'base/push.sh ${BUILD_NUMBER}' 
	sh 'docker-jenkins-agent/push.sh ${BUILD_NUMBER}'
      }

    
   }

  }
  
}
