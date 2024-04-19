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
                        sh 'ls' 
                        sh "cat ${BRANCH_NAME}.tfvars"
                        sh 'terraform init -no-color' 
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                dir('Terraform') {
                    withCredentials([aws(credentialsId: '3232b887-94ae-4e90-bdfa-6e4bf09f378c')]) {
                        sh 'ls -l' 
                        sh "terraform plan -no-color -var-file=${BRANCH_NAME}.tfvars"
                    }
                }
            }
        }
        stage('Validate Apply'){
            when {
                beforeInput true
                branch "dev"
            }
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
                        sh "terraform apply -auto-approve -no-color -var-file=${BRANCH_NAME}.tfvars"
                    }
                }
            }
        }

        stage('EC2 Wait') {
            steps {
                dir('Terraform') {
                    withCredentials([aws(credentialsId: '3232b887-94ae-4e90-bdfa-6e4bf09f378c')]) {
                        sh 'aws ec2 wait instance-status-ok --region us-east-1'
                    }
                }
            }
        }
        stage('Validate Ansible') {
            when {
                beforeInput true
                branch "dev"
            }            
            input {
                message "Do you want to run Ansible? "
                ok "Run Ansible!"
            }
            steps {
                echo 'Running playbook'
            }
        }
        stage('Run Ansible') {
            steps {
                dir('Ansible/Playbooks/') {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                        sh 'ansible-playbook main-playbook.yml -i ../../Terraform/aws_hosts --private-key=${SSH_KEY} --user=ubuntu'
                    }
                }
            }
        }

        stage('Validate Infrastructure Destruction') {
            input {
                message "Are you sure you want to destroy the infrastructure? "
                ok "Destroy!"
            }
            steps {
                echo "Destroying DevOps In The Cloud Infrastructure"
            }
        }

        stage('Destroy') {
            steps {
                dir('Terraform') {
                    withCredentials([aws(credentialsId: '3232b887-94ae-4e90-bdfa-6e4bf09f378c')]) {
                        sh "terraform destroy -auto-approve -no-color -var-file=${BRANCH_NAME}.tfvars"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Success!'
        }

        failure {
            dir('Terraform') {
                withCredentials([aws(credentialsId: '3232b887-94ae-4e90-bdfa-6e4bf09f378c')]) {
                    sh "terraform destroy -auto-approve -no-color -var-file=${BRANCH_NAME}.tfvars"
                }
            }
        }

        aborted {
            dir('Terraform') {
                withCredentials([aws(credentialsId: '3232b887-94ae-4e90-bdfa-6e4bf09f378c')]) {
                    sh "terraform destroy -auto-approve -no-color -var-file=${BRANCH_NAME}.tfvars"
                }    
               
            }    
        }
    }
}
