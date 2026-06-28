pipeline {
    agent any

    environment {
        CANGJIE_SDK_ZIP = 'C:\\Users\\cdk\\Downloads\\cangjie-sdk-windows-x64-1.0.5.zip'
    }

    stages {
        stage('Check workspace') {
            steps {
                bat 'dir'
            }
        }

        stage('Check Cangjie SDK') {
            steps {
                powershell '''
                    $ErrorActionPreference = "Stop"
                    if (-not (Test-Path $env:CANGJIE_SDK_ZIP)) {
                        throw "Cangjie SDK zip not found: $env:CANGJIE_SDK_ZIP"
                    }
                    Write-Host "Using Cangjie SDK: $env:CANGJIE_SDK_ZIP"
                '''
            }
        }

        stage('Run Cangjie unit tests') {
            steps {
                powershell '''
                    $ErrorActionPreference = "Stop"
                    .\\.ci\\run-tests-windows.ps1 -SdkZip $env:CANGJIE_SDK_ZIP
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'target/**', allowEmptyArchive: true
        }
    }
}
