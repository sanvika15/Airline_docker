#!groovy

pipeline {
    agent any

    tools {
        maven "maven" // You need to add a maven with name "3.6.0" in the Global Tools Configuration page
    }

    stages {
        stage("Build") {
            steps {
                bat "mvn -version"
                bat "mvn clean install"
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}