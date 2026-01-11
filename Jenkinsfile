pipeline {
    agent any

    stages {
        stage("Terraform Init") {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-prod']]) {
                    sh "cd terraform && terraform init"
                }
            }
        }

        stage("Terraform Apply") {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-prod']]) {
                    sh "cd terraform && terraform apply -auto-approve"
                }
            }
        }

        stage("Configure Servers") {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-prod']]) {
                    script {
                        def ip = sh(
                            script: "cd terraform && terraform output -raw app_ip",
                            returnStdout: true
                        ).trim()

                        sh """
                        cd ansible
                        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${ip}, deploy.yml
                        """
                    }
                }
            }
        }
    }
}
