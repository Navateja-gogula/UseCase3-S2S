pipeline {
    agent any

    environment {
        LOCAL_SERVER = 'tcp:10.128.0.16,1433'
        REMOTE_SERVER = 'tcp:10.128.0.19,1433'
        LOCAL_DB = 'aspnet_DB'
        REMOTE_DB = 'aspnet_DB'
        LOCAL_TABLE = 'asp_user'
        REMOTE_TABLE = 'asp_user'
        SA_USER = 'sa'
        SA_PASS = 'P@ssword@123' // Ideally stored in Jenkins credentials securely
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/Navateja-gogula/UseCase3-S2S.git', branch: 'main'
            }
        }

        stage('Install SqlServer Module if Missing') {
            steps {
                powershell '''
                    $module = Get-Module -ListAvailable -Name SqlServer
                    if (-not $module) {
                        Write-Host "SqlServer module not found. Attempting to install..."
                        Install-Module -Name SqlServer -Force -Scope AllUsers -AllowClobber -ErrorAction Stop
                    } else {
                        Write-Host "SqlServer module is already installed."
                    }
                '''
            }
        }

        stage('Run PowerShell Script') {
            steps {
                powershell '''
                    Write-Host "Starting data copy from VM-1 to VM-2..."

                    # Ensure SqlServer module is imported
                    try {
                        Import-Module SqlServer -ErrorAction Stop
                        Write-Host "SqlServer module imported successfully."
                    } catch {
                        Write-Error "Failed to import SqlServer module. Ensure it's installed system-wide and accessible."
                        exit 1
                    }

                    if (Test-Path "./migrate-users.ps1") {
                        ./migrate-users.ps1 `
                            -LocalServer "$env:LOCAL_SERVER" `
                            -RemoteServer "$env:REMOTE_SERVER" `
                            -LocalDB "$env:LOCAL_DB" `
                            -RemoteDB "$env:REMOTE_DB" `
                            -LocalTable "$env:LOCAL_TABLE" `
                            -RemoteTable "$env:REMOTE_TABLE" `
                            -User "$env:SA_USER" `
                            -Password "$env:SA_PASS"
                    } else {
                        Write-Error "migrate-users.ps1 not found in workspace"
                        exit 1
                    }
                '''
            }
        }
    }

    post {
        success {
            echo 'Data migration completed successfully!'
        }
        failure {
            echo 'Data migration failed.'
        }
    }
}
