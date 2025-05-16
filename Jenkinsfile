pipeline {
    agent {
        docker {
            image 'maven:3.9.6-eclipse-temurin-17'
            args '-v /c/ProgramData/Jenkins/.jenkins/workspace:/workspace -w /workspace'

        }
    }

    environment {
        JAR_NAME = "devops-0.0.1-SNAPSHOT.jar"
        EC2_HOST = "ec2-65-1-134-15.ap-south-1.compute.amazonaws.com"
        PEM_KEY = credentials('airline-docker-key.pem')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t airline-management .'
            }
        }

        stage('Push Docker Image (Optional)') {
            when {
                expression { return false }
            }
            steps {
                sh 'docker tag airline-management sanvikaa15/airline-management'
                sh 'docker push sanvikaa15/airline-management'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh "scp -i ${PEM_KEY} target/${JAR_NAME} ${EC2_HOST}:/home/ec2-user/"
                sh """
                ssh -i ${PEM_KEY} ${EC2_HOST} << EOF
                    pkill -f '${JAR_NAME}' || true
                    nohup java -jar ${JAR_NAME} > app.log 2>&1 &
                EOF
                """
            }
        }
    }
}