pipeline {
    agent any

    environment {
        // Static values
        LOCAL_DB     = 'aspnet_DB'
        REMOTE_DB    = 'aspnet_DB'
        LOCAL_TABLE  = 'asp_user'
        REMOTE_TABLE = 'asp_user'
        LOCAL_USER   = 'sa'
        REMOTE_USER  = 'sa'

        // Injected from Jenkins credentials (IDs must match)
        LOCAL_SERVER  = credentials('LOCAL_SERVER')
        REMOTE_SERVER = credentials('REMOTE_SERVER')
        LOCAL_PASS    = credentials('LOCAL_PASS')
        REMOTE_PASS   = credentials('REMOTE_PASS')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/Navateja-gogula/UseCase3-S2S.git', branch: 'main'
            }
        }

        stage('Run PowerShell Script') {
            steps {
                powershell '''
                    Write-Host "Starting data copy from VM-1 to VM-2..."

                    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

                    try {
                        Import-Module SqlServer -ErrorAction Stop
                        Write-Host "SqlServer module imported successfully."
                    } catch {
                        Write-Error "SqlServer module is not available."
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
                            -LocalUser "$env:LOCAL_USER" `
                            -LocalPassword "$env:LOCAL_PASS" `
                            -RemoteUser "$env:REMOTE_USER" `
                            -RemotePassword "$env:REMOTE_PASS"
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
            echo ' Data inserted successfully. Migration completed.'
        }
        failure {
            echo ' Data migration failed. Check logs for errors.'
        }
    }
}
