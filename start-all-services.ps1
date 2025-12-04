# Script to start all microservices
Write-Host "Starting Collaborative Editing System Microservices..." -ForegroundColor Green
Write-Host "This will start 5 backend services in separate windows." -ForegroundColor Cyan
Write-Host ""

# Start User Service (Port 8081)
Write-Host "Starting User Service on port 8081..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\user-service'; Write-Host 'User Service Starting...' -ForegroundColor Green; .\mvnw.cmd spring-boot:run" -WindowStyle Normal

Start-Sleep -Seconds 8

# Start Version Service (Port 8083)
Write-Host "Starting Version Service on port 8083..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\version-service'; Write-Host 'Version Service Starting...' -ForegroundColor Green; .\mvnw.cmd spring-boot:run" -WindowStyle Normal

Start-Sleep -Seconds 8

# Start Document Service (Port 8082)
Write-Host "Starting Document Service on port 8082..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\document-service'; Write-Host 'Document Service Starting...' -ForegroundColor Green; .\mvnw.cmd spring-boot:run" -WindowStyle Normal

Start-Sleep -Seconds 8

# Start Collaboration Service (Port 8084)
Write-Host "Starting Collaboration Service on port 8084..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\collaboration-service'; Write-Host 'Collaboration Service Starting...' -ForegroundColor Green; if (Test-Path mvnw.cmd) { .\mvnw.cmd spring-boot:run } else { mvn spring-boot:run }" -WindowStyle Normal

Start-Sleep -Seconds 8

# Start API Gateway (Port 8080) - Start last as it depends on other services
Write-Host "Starting API Gateway on port 8080..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\api-gateway'; Write-Host 'API Gateway Starting...' -ForegroundColor Green; .\mvnw.cmd spring-boot:run" -WindowStyle Normal

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "All 5 services are starting..." -ForegroundColor Green
Write-Host "Please wait 60-90 seconds for all services to fully start." -ForegroundColor Cyan
Write-Host ""
Write-Host "Service URLs:" -ForegroundColor Cyan
Write-Host "  ✓ API Gateway:        http://localhost:8080" -ForegroundColor White
Write-Host "  ✓ User Service:       http://localhost:8081" -ForegroundColor White
Write-Host "  ✓ Document Service:   http://localhost:8082" -ForegroundColor White
Write-Host "  ✓ Version Service:   http://localhost:8083" -ForegroundColor White
Write-Host "  ✓ Collaboration:      http://localhost:8084" -ForegroundColor White
Write-Host ""
Write-Host "Frontend: http://localhost:3000" -ForegroundColor Cyan
Write-Host "  Start with: .\start-frontend.ps1" -ForegroundColor Yellow
Write-Host ""
Write-Host "Swagger UI:" -ForegroundColor Cyan
Write-Host "  - User Service:       http://localhost:8081/swagger-ui.html" -ForegroundColor White
Write-Host "  - Document Service:  http://localhost:8082/swagger-ui.html" -ForegroundColor White
Write-Host "  - Version Service:   http://localhost:8083/swagger-ui.html" -ForegroundColor White
Write-Host "  - Collaboration:      http://localhost:8084/swagger-ui.html" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Green "

