pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION = 'true'
        TF_CLI_CONFIG_FILE = credentials('tf-creds')
    }
    stages {
        stage('Init') {
            steps {
                dir('Terraform') {
                    withCredentials([aws(credentialsId: '3232b887-94ae-4e90-bdfa-6e4bf09f378c')]) {
                        sh 'ls' // List files in the Terraform directory
                        sh 'terraform init -no-color' // Run terraform init within the Terraform directory
                    }
                }
            }
        }
        stage('Plan') {
            steps {
                dir('Terraform') {
                    withCredentials([aws(credentialsId: '3232b887-94ae-4e90-bdfa-6e4bf09f378c')]) {
                        sh 'ls -l' // List files in the Terraform directory
                        sh 'terraform plan -no-color' 
                    }
                }
            }
        }
        stage('Apply') {
            steps {
                dir('Terraform') {
                    withCredentials([aws(credentialsId: '3232b887-94ae-4e90-bdfa-6e4bf09f378c')]) {
                        sh 'terraform apply -auto-approve -no-color' 
                    }
                }
            }
        }
        stage('EC2 Wait') {
            steps {
                dir('Terraform'){
                    withCredentials([aws(credentialsId: '3232b887-94ae-4e90-bdfa-6e4bf09f378c')]) {
                        sh 'aws ec2 wait instance-status-ok --region us-west-1'
                    }
                }
            }

        }
        stage('Destroy') {
            steps {
                dir('Terraform') {
                    withCredentials([aws(credentialsId: '3232b887-94ae-4e90-bdfa-6e4bf09f378c')]) {
                        sh 'terraform destroy -auto-approve -no-color' 
                    }
                }
            }
        }        
        
    }
}
