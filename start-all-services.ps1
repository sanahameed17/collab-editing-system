# Script to start all microservices
Write-Host "Starting Collaborative Editing System Microservices..." -ForegroundColor Green

# Start User Service
Write-Host "`nStarting User Service on port 8081..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\user-service'; .\mvnw.cmd spring-boot:run" -WindowStyle Normal

Start-Sleep -Seconds 5

# Start Version Service
Write-Host "Starting Version Service on port 8083..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\version-service'; .\mvnw.cmd spring-boot:run" -WindowStyle Normal

Start-Sleep -Seconds 5

# Start Document Service
Write-Host "Starting Document Service on port 8082..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\document-service'; .\mvnw.cmd spring-boot:run" -WindowStyle Normal

Start-Sleep -Seconds 5

# Start API Gateway
Write-Host "Starting API Gateway on port 8080..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\api-gateway'; .\mvnw.cmd spring-boot:run" -WindowStyle Normal

Write-Host "`nAll services are starting..." -ForegroundColor Green
Write-Host "Please wait for all services to fully start before making API calls." -ForegroundColor Cyan
Write-Host "`nService URLs:" -ForegroundColor Cyan
Write-Host "  - API Gateway: http://localhost:8080" -ForegroundColor White
Write-Host "  - User Service: http://localhost:8081" -ForegroundColor White
Write-Host "  - Document Service: http://localhost:8082" -ForegroundColor White
Write-Host "  - Version Service: http://localhost:8083" -ForegroundColor White

