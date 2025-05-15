pipeline {
    agent any

    triggers {
        githubPush()  // Trigger pipeline on GitHub push
    }

    environment {
        SCRIPT_FILE = 'migrate-users.ps1'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/Navateja-gogula/UseCase3-S2S.git', branch: 'main'
            }
        }

        stage('Run Migration Script') {
            steps {
                powershell script: """
                    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
                    ./\$env:SCRIPT_FILE
                """
            }
        }
    }

    post {
        success {
            echo '✅ Migration job completed successfully.'
        }
        failure {
            echo '❌ Migration job failed.'
        }
    }
}
