pipeline{
    agent any
    environment {
        TF_IN_AUTOMATION ='true'
        TF-CLI_CONFIG_FILE = credentials('tf-creds')
    }
    stages{
        stage('Init'){
            steps{
                sh 'cd Terraform'
                sh 'ls'
                sh 'terraform init -no-color'
            }
        }
        stage('Plan'){
            steps{
                sh 'cd Terraform'
                sh 'terraform plan -no-color'               
            }
        }
    }

}