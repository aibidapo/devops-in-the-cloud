pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION = 'true'
    }
    stages {
        stage('Init') {
            steps {
                withCredentials([file(credentialsId: 'tf-creds', variable: 'TF_CLI_CONFIG_FILE')]) {
                    dir('Terraform') {
                        sh 'ls' // List files in the Terraform directory
                        sh 'terraform init -no-color' // Run terraform init within the Terraform directory
                    }
                }
            }
        }
        stage('Plan') {
            steps {
                withCredentials([file(credentialsId: 'tf-creds', variable: 'TF_CLI_CONFIG_FILE')]) {
                    dir('Terraform') {
                        sh 'ls -l' // List files in the Terraform directory
                        sh 'terraform plan -no-color' // Run terraform plan within the Terraform directory
                    }
                }
            }
        }
    }
}
