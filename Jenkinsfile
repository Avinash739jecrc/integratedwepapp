pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'azure-service-principal'
        RESOURCE_GROUP = 'rg-jenkins'
        APP_SERVICE_NAME = 'webapiIntegratedavinash001'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Avinash739jecrc/integratedwepapp.git'
            }
        }

        stage('Run Terraform Script') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                    bat 'terraform validate'
                    bat 'terraform plan -out=tfplan'
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Restore Dependencies') {
            steps {
                dir('webapplicationintegrated') {
                    bat 'dotnet restore'
                }
            }
        }

        stage('Build Project') {
            steps {
                dir('webapplicationintegrated') {
                    bat 'dotnet build --configuration Release'
                }
            }
        }

        stage('Publish Artifacts') {
            steps {
                dir('webapplicationintegrated') {
                    bat 'dotnet publish -c Release -o publish'
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                dir('webapplicationintegrated') {
                    withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                        bat '''
                        az login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% --tenant %AZURE_TENANT_ID%
                        powershell Compress-Archive -Path .\\publish\\* -DestinationPath publish.zip -Force
                        az webapp deployment source config-zip --resource-group %RESOURCE_GROUP% --name %APP_SERVICE_NAME% --src publish.zip
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed! Please check the logs and fix the issue.'
        }
    }
}
