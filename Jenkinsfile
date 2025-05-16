pipeline {
    agent {
        docker {
            image 'maven:3.8.7-eclipse-temurin-17'
            args '-v /root/.m2:/root/.m2' // Mount local Maven repo for caching
        }
    }

    environment {
        EC2_USER = "ec2-user"
        EC2_HOST = "ec2-65-1-134-15.ap-south-1.compute.amazonaws.com"
        KEY_PATH = "C:/Users/kndak/Desktop/honor-devops/airline/my-ec2-key.pem"
        JAR_NAME = "target/devops-0.0.1-SNAPSHOT.jar"
    }

    stages {
        stage('Checkout Source') {
            steps {
                git url: 'https://github.com/sanvika15/Airline_docker.git', branch: 'main'
            }
        }

        stage('Build Project') {
            steps {
                sh 'mvn clean install -DskipTests=false'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Deploy to EC2') {
            steps {
                echo 'Copying JAR to EC2...'
                sh """
                    scp -i ${KEY_PATH} ${JAR_NAME} ${EC2_USER}@${EC2_HOST}:/home/ec2-user/
                """
            }
        }

        stage('Start Application on EC2') {
            steps {
                echo 'Starting JAR on EC2...'
                sh """
                    ssh -i ${KEY_PATH} ${EC2_USER}@${EC2_HOST} '
                        pkill -f your-app-name.jar || true
                        nohup java -jar /home/ec2-user/your-app-name.jar > app.log 2>&1 &
                    '
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
