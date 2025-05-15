# migrate-users.ps1

# SQL Server Credentials and Connection Strings
$sourceServer = "tcp:10.128.0.16,1433"
$destServer = "tcp:10.128.0.19,1433"
$database = "aspnet_DB"
$username = "sa"
$password = "P@ssword@123"

# Load SQL Server module (for older systems, install via Install-Module SqlServer)
Import-Module SqlServer -ErrorAction Stop

# Extract data from VM-1
$queryExport = "SELECT user_id, user_name, user_email FROM asp_user"
$sourceConnection = "Server=$sourceServer;Database=$database;User Id=$username;Password=$password;"

$users = Invoke-Sqlcmd -Query $queryExport -ConnectionString $sourceConnection

# Insert into VM-2
$destConnection = "Server=$destServer;Database=$database;User Id=$username;Password=$password;"

foreach ($user in $users) {
    $queryInsert = @"
    INSERT INTO asp_user (user_id, user_name, user_email)
    VALUES ('$($user.user_id)', '$($user.user_name)', '$($user.user_email)')
"@
    Invoke-Sqlcmd -Query $queryInsert -ConnectionString $destConnection
}

Write-Host "✅ Data migration completed successfully."
