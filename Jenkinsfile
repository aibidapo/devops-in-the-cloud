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
                    withCredentials([aws(credentialsId: 'your-aws-credentials-id')]) {
                        sh 'ls' // List files in the Terraform directory
                        sh 'terraform init -no-color' // Run terraform init within the Terraform directory
                    }
                }
            }
        }
        stage('Plan') {
            steps {
                dir('Terraform') {
                    withCredentials([aws(credentialsId: 'your-aws-credentials-id')]) {
                        sh 'ls -l' // List files in the Terraform directory
                        sh 'terraform plan -no-color' 
                    }
                }
            }
        }
        stage('Apply') {
            steps {
                dir('Terraform') {
                    withCredentials([aws(credentialsId: 'your-aws-credentials-id')]) {
                        sh 'terraform apply -auto-approve -no-color' 
                    }
                }
            }
        }
        stage('EC2 Wait') {
            steps {
                withCredentials([aws(credentialsId: 'your-aws-credentials-id')]) {
                    sh 'aws ec2 wait instance-status-ok --region us-east-1'
                }
            }
        }
        stage('Ansible') {
            steps {
                dir('Ansible/Playbooks') { 
                    ansiblePlaybook(credentialsId: 'ec2-ssh-key', playbook: 'main-playbook.yml' inventory: 'aws_hosts')
                }
            }
        }
        stage('Destroy') {
            steps {
                dir('Terraform') {
                    withCredentials([aws(credentialsId: 'your-aws-credentials-id')]) {
                        sh 'terraform destroy -auto-approve -no-color' 
                    }
                }
            }
        }        
    }
}
