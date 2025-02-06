# Run docker-compose
docker-compose up -d --build

# Create logs directory if it doesn't exist
$logsPath = "logs"
if (-not (Test-Path -Path $logsPath)) {
    New-Item -ItemType Directory -Path $logsPath
}

# Set max log size (10MB in bytes)
$maxSize = 10MB

# Check if log file exists and needs rotation
$logFile = Join-Path $logsPath "app.log"
if (Test-Path $logFile) {
    $fileInfo = Get-Item $logFile
    if ($fileInfo.Length -ge $maxSize) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        Move-Item -Path $logFile -Destination (Join-Path $logsPath "app-$timestamp.log")
        New-Item -ItemType File -Path $logFile
    }
}

# Start logging docker-compose output
Start-Job -ScriptBlock {
    docker-compose logs -f >> logs/app.log
}

Write-Host "Odoo and PostgreSQL containers successfully created" -ForegroundColor Green
