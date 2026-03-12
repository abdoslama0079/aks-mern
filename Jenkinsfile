pipeline {
    agent any

    // Parameters are defined here in Declarative syntax
    parameters {
        string(name: 'Environment', defaultValue: 'dev', description: 'Target environment')
        choice(name: 'Terraform_Action', choices: ['plan', 'apply', 'destroy'], description: 'What should Terraform do?')
    }

    stages {
        stage('Preparing') {
            steps {
                echo "Preparing deployment for ${params.Environment}"
            }
        }

        stage('Git Pulling') {
            steps {
                // Best practice: use the 'checkout' step or the shorthand
                git branch: 'master', url: 'https://github.com/abdoslama0079/aks-mern.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([azureServicePrincipal('azure-sp-creds')]) {
                    sh '''
                        export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                        export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET
                        export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
                        export ARM_TENANT_ID=$AZURE_TENANT_ID

                        terraform init -input=false
                    '''
                }
            }
        }

        stage('Terraform Action') {
            steps {
                withCredentials([azureServicePrincipal('azure-sp-creds')]) {
                    sh """
                        export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                        export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET
                        export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
                        export ARM_TENANT_ID=$AZURE_TENANT_ID

                        if [ "${params.Terraform_Action}" == "plan" ]; then
                            terraform plan
                        elif [ "${params.Terraform_Action}" == "apply" ]; then
                            terraform apply -auto-approve
                        elif [ "${params.Terraform_Action}" == "destroy" ]; then
                            terraform destroy -auto-approve
                        fi
                    """
                }
            }
        }
    }
}