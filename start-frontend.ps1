# Script to start the frontend web server
Write-Host "Starting Frontend Web Server..." -ForegroundColor Green

$port = 3000

# Check if port is already in use
$portInUse = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "Port $port is already in use. Trying to find an available port..." -ForegroundColor Yellow
    $port = 3001
}

Write-Host "`nStarting server on port $port..." -ForegroundColor Yellow
Write-Host "Open your browser and navigate to: http://localhost:$port" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server`n" -ForegroundColor Yellow

Set-Location "$PSScriptRoot\frontend"

# Try different methods to start a web server
if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "Using Python HTTP Server..." -ForegroundColor Green
    python -m http.server $port
} elseif (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "Using Node.js http-server..." -ForegroundColor Green
    if (-not (Get-Command http-server -ErrorAction SilentlyContinue)) {
        Write-Host "Installing http-server globally..." -ForegroundColor Yellow
        npm install -g http-server
    }
    http-server -p $port
} elseif (Get-Command php -ErrorAction SilentlyContinue) {
    Write-Host "Using PHP built-in server..." -ForegroundColor Green
    php -S localhost:$port
} else {
    Write-Host "No web server found. Please install one of:" -ForegroundColor Red
    Write-Host "  - Python: https://www.python.org/" -ForegroundColor White
    Write-Host "  - Node.js: https://nodejs.org/" -ForegroundColor White
    Write-Host "  - PHP: https://www.php.net/" -ForegroundColor White
    Write-Host "`nOr use VS Code Live Server extension" -ForegroundColor Yellow
    Write-Host "Or manually serve the files from the 'frontend' directory" -ForegroundColor Yellow
}

