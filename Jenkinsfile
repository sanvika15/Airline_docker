pipeline {
    agent any

    //environment {
       // registry = "public.ecr.aws/d7i2u9e5/my-cicd-repo"
      //  region = "ap-south-1"   // corrected region (no "b" at end)
      //  imageTag = "latest"
  //  }

    stages {
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          userRemoteConfigs: [[url: 'https://github.com/sanvika15/Airline_docker']]
                ])
            }
        }

        stage('Building JAR') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }
        stage('Verify AWS CLI') {
            steps {
                bat 'aws --version'
            }
        }

        stage('Pushing to ECR') {
            steps {
                bat 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/d7i2u9e5'
                bat 'docker build -t my-cicd-repo .'
                bat 'docker push public.ecr.aws/d7i2u9e5/my-cicd-repo:latest'
            }
        }

        stage('Stop previous containers') {
            steps {
                bat '''
                docker stop myjavaContainer || true
                docker rm myjavaContainer || true
                '''
            }
        }

        stage('Docker Run') {
            steps {
                bat 'docker run -d -p 8081:8081 --name myjavaContainer public.ecr.aws/d7i2u9e5/my-cicd-repo:latest'
            }
        }
    }
}
