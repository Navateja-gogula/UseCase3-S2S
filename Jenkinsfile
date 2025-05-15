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
    // Use Jenkins credentials for secure password storage
    SA_PASS = 'P@ssword@123'  // stored in Jenkins as a secret text
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
        echo ' Data migration failed.'
    }
}
}
