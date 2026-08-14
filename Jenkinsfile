pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "ap-south-2"
        AWS_REGION         = "ap-south-2"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh 'terraform init'
                }
            }
        }

        stage('Format Check') {
            steps {
                sh 'terraform fmt -check'
            }
        }

        stage('Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh 'terraform plan -out=tfplan'
                    stash name: 'tfplan', includes: 'tfplan'
                }
            }
        }

        stage('Manual Approval') {
            steps {
                input message: 'Approve Terraform Apply?', ok: 'Apply'
            }
        }

        stage('Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    unstash 'tfplan'
                    sh 'terraform apply tfplan'
                }
            }
        }
    }
}