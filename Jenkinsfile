pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-prod').username
        AWS_SECRET_ACCESS_KEY = credentials('aws-prod').password
    }

    stages {
        stage("Terraform Init") {
            steps {
                sh "cd terraform && terraform init"
            }
        }

        stage("Terraform Apply") {
            steps {
                sh "cd terraform && terraform apply -auto-approve"
            }
        }

        stage("Configure Servers") {
            steps {
                sh """
                cd terraform
                IP=$(terraform output -raw app_ip)
                cd ../ansible
                ansible-playbook -i "$IP," deploy.yml
            }
        }
    }
}
