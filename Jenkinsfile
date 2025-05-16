pipeline {
    agent any

    environment {
        EC2_USER = "Jenkins Master" // Replace with your EC2 username
        EC2_HOST = "ec2-65-1-134-15.ap-south-1.compute.amazonaws.com" // Replace with your EC2 public DNS or IP
        KEY_PATH = "airline-docker-key.pem" // Path to your EC2 key pair
        JAR_NAME = "target/devops-0.0.1-SNAPSHOT.jar" // Adjust based on your project structure
        DOCKER_IMAGE = "maven:3.9.9-amazoncorretto-21" // Docker image with Maven and Java
    }

    stages {
        stage('Checkout Source') {
            steps {
                git url: 'https://github.com/sanvika15/Airline_docker.git', branch: 'main' // Replace with your repository URL
            }
        }

        stage('Build Project') {
            steps {
                script {
                    docker.image(DOCKER_IMAGE).inside {
                        sh 'mvn clean install -DskipTests=false'
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    docker.image(DOCKER_IMAGE).inside {
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                echo 'Copying JAR to EC2...'
                sh """
                    chmod 400 ${KEY_PATH}
                    scp -o StrictHostKeyChecking=no -i ${KEY_PATH} ${JAR_NAME} ${EC2_USER}@${EC2_HOST}:/home/ec2-user/ || error_exit "Failed to copy JAR to EC2"
                """
            }
        }

        stage('Start Application on EC2') {
            steps {
                echo 'Starting JAR on EC2...'
                sh """
                    ssh -o StrictHostKeyChecking=no -i ${KEY_PATH} ${EC2_USER}@${EC2_HOST} '
                    pkill -f ${JAR_NAME.split('/').last()} || true
                    nohup java -jar /home/ec2-user/${JAR_NAME.split('/').last()} > app.log 2>&1 &
                    ' || error_exit "Failed to start application on EC2"
                """
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution complete.'
            cleanWs()
        }
    }
}

// Function to handle errors
def error_exit(message) {
    error(message)
}