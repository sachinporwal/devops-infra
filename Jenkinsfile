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
                script {
                    def ip = sh(
                        script: "cd terraform && terraform output -raw app_ip",
                        returnStdout: true
                    ).trim()

                    sh """
                    cd ansible
                    ansible-playbook -i ${ip}, deploy.yml
                    """
                }
            }
        }
    }
}
