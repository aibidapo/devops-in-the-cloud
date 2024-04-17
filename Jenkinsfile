pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION = 'true'
        TF_CLI_CONFIG_FILE = credentials('tf-creds')
        AWS_ACCESS_KEY_ID = ''
        AWS_SECRET_ACCESS_KEY = ''
    }
    stages {
        stage('Init') {
            steps {
                dir('Terraform') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'AKIATCKAPLPLYZMSUAGA', 
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                        sh 'ls' // List files in the Terraform directory
                        sh 'terraform init -no-color' // Run terraform init within the Terraform directory
                    }
                }
            }
        }
        stage('Plan') {
            steps {
                dir('Terraform') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'AKIATCKAPLPLYZMSUAGA', 
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                        sh 'ls -l' // List files in the Terraform directory
                        // sh 'terraform plan -no-color' // Uncomment this line to run terraform plan within the Terraform directory
                    }
                }
            }
        }
    }
}
