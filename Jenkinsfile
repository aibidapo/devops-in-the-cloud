pipeline {
    agent any

    environment {
        // AWS_DEFAULT_REGION = 'us-east-1'
        TF_IN_AUTOMATION = 'true'
        TF_CLI_CONFIG_FILE = credentials('tf-creds')
        // SSH_KEY_PARAM = sh(script: 'aws ssm get-parameter --name ai-devops-prod-key --with-decryption --query "Parameter.Value" --output text --region us-east-1', returnStdout: true).trim()
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
        stage('Validate Apply'){
            input {
                message "Do you want to apply this plan? "
                ok "Apply this plan."
            }
            steps {
                echo 'Apply Accepted'
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
                withCredentials([aws(credentialsId: '3232b887-94ae-4e90-bdfa-6e4bf09f378c')]) {
                    sh 'aws ec2 wait instance-status-ok --region us-east-1'
                }
            }
        }

        stage('Run Ansible') {
            steps {
                dir('Ansible/Playbooks') {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                        sh 'ansible-playbook main-playbook.yml -i ../../Terraform/aws_hosts --private-key=$SSH_KEY --user=ubuntu'
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
