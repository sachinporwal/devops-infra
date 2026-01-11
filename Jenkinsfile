pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
    }

    stages {

        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Terraform Init") {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-prod']]) {
                    sh '''
                        cd terraform
                        terraform init
                    '''
                }
            }
        }

        stage("Terraform Apply") {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-prod']]) {
                    sh '''
                        cd terraform
                        terraform apply -auto-approve
                    '''
                }
            }
        }

        stage("Configure Servers") {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-prod'],
                    sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')
                ]) {
                    script {
                        def ip = sh(
                            script: "cd terraform && terraform output -raw app_ip",
                            returnStdout: true
                        ).trim()

                        sh """
                        cd ansible
                        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
                          -i ${ip}, \
                          --user ec2-user \
                          --private-key \$SSH_KEY \
                          deploy.yml
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Infrastructure and application deployed successfully"
        }
        failure {
            echo "Pipeline failed. Check Terraform or Ansible logs"
        }
    }
}
