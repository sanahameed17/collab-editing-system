# Test script to verify all services are running
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Testing Collaborative Editing System Services..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$services = @(
    @{Name="User Service"; Port=8081; Path="/users"; Status="Checking..."},
    @{Name="Document Service"; Port=8082; Path="/documents"; Status="Checking..."},
    @{Name="Version Service"; Port=8083; Path="/versions"; Status="Checking..."},
    @{Name="Collaboration Service"; Port=8084; Path="/collab/shared-with/1"; Status="Checking..."},
    @{Name="API Gateway"; Port=8080; Path="/api/users"; Status="Checking..."}
)

$successCount = 0
$failCount = 0

foreach ($service in $services) {
    Write-Host "Testing $($service.Name) on port $($service.Port)..." -ForegroundColor Yellow -NoNewline
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$($service.Port)$($service.Path)" -Method GET -TimeoutSec 3 -ErrorAction Stop
        Write-Host " ✓ ONLINE" -ForegroundColor Green
        $service.Status = "ONLINE"
        $successCount++
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404 -or $_.Exception.Response.StatusCode -eq 405) {
            Write-Host " ✓ ONLINE (Endpoint exists)" -ForegroundColor Green
            $service.Status = "ONLINE"
            $successCount++
        } else {
            Write-Host " ✗ OFFLINE" -ForegroundColor Red
            $service.Status = "OFFLINE"
            $failCount++
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test Results Summary" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Online Services: $successCount / $($services.Count)" -ForegroundColor $(if ($successCount -eq $services.Count) { "Green" } else { "Yellow" })
Write-Host "Offline Services: $failCount / $($services.Count)" -ForegroundColor $(if ($failCount -eq 0) { "Green" } else { "Red" })
Write-Host ""

if ($successCount -eq $services.Count) {
    Write-Host "✓ All services are running successfully!" -ForegroundColor Green
    Write-Host "You can now access:" -ForegroundColor Cyan
    Write-Host "  - Frontend: http://localhost:3000" -ForegroundColor White
    Write-Host "  - API Gateway: http://localhost:8080" -ForegroundColor White
} else {
    Write-Host "⚠ Some services are not running." -ForegroundColor Yellow
    Write-Host "Please check the service terminals or run:" -ForegroundColor Yellow
    Write-Host "  .\start-all-services.ps1" -ForegroundColor White
}

Write-Host "========================================" -ForegroundColor Cyan

