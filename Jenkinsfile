pipeline {
    agent {
        docker {
            image 'maven:3.9.6-eclipse-temurin-17'
            args "-v ${env.WORKSPACE.replaceAll('\\\\','/')}: /workspace"  // map Windows path to /workspace
            reuseNode true
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'pwd'                // inside container, should be /workspace
                sh 'mvn clean install'  // run mvn inside container
            }
        }
    }
}
