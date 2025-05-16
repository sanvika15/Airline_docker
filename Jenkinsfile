pipeline {
    agent {
        docker {
            image 'maven:3.9.6-eclipse-temurin-17'  // Java 17 + Maven image
            args '-v /var/run/docker.sock:/var/run/docker.sock'  // optional, if you need docker inside container
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
