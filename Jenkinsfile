pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION = 'true'
        TF_CLI_CONFIG_FILE = credentials('tf-creds')
    }
    stages {
        stage('Init') {
            steps {
                dir('Terraform') { // Change to the Terraform directory
                    sh 'ls' // List files in the Terraform directory
                    sh 'terraform init -no-color' // Run terraform init within the Terraform directory
                }
            }
        }
        stage('Plan') {
            steps {
                dir('Terraform') { // Change to the Terraform directory
                    sh 'ls -l' // List files in the Terraform directory
                    sh 'terraform plan -no-color' // Uncomment this line to run terraform plan within the Terraform directory
                }
            }
        }
    }
}
