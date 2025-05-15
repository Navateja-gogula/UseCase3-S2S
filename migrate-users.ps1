param (
    [string]$LocalServer,
    [string]$RemoteServer,
    [string]$LocalDB,
    [string]$RemoteDB,
    [string]$LocalTable,
    [string]$RemoteTable,
    [string]$User,
    [string]$Password
)

try {
    Import-Module SqlServer -ErrorAction Stop
    Write-Host "✅ SqlServer module imported successfully."
} catch {
    Write-Error "❌ Failed to import SqlServer module: $_"
    exit 1
}

$sourceConnection = "Server=$LocalServer;Database=$LocalDB;User Id=$User;Password=$Password;TrustServerCertificate=True;"
$destConnection = "Server=$RemoteServer;Database=$RemoteDB;User Id=$User;Password=$Password;TrustServerCertificate=True;"

$queryExport = "SELECT user_id, user_name, user_email FROM $LocalTable"

try {
    $users = Invoke-Sqlcmd -Query $queryExport -ConnectionString $sourceConnection -ErrorAction Stop
    if (!$users) {
        Write-Warning "⚠️ No users returned from source database."
        exit 1
    }
    Write-Host "✅ Retrieved $($users.Count) users from source."
} catch {
    Write-Error "❌ Failed to query source DB: $_"
    exit 1
}

foreach ($user in $users) {
    $queryInsert = @"
INSERT INTO $RemoteTable (user_id, user_name, user_email)
VALUES ('$($user.user_id)', '$($user.user_name)', '$($user.user_email)')
"@

    try {
        Invoke-Sqlcmd -Query $queryInsert -ConnectionString $destConnection -ErrorAction Stop
        Write-Host "✅ Inserted user: $($user.user_id)"
    } catch {
        Write-Warning "⚠️ Failed to insert user $($user.user_id): $_"
    }
}

Write-Host "✅ Data migration completed successfully."
