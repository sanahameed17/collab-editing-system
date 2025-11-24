# Test script to verify all services are running
Write-Host "Testing Collaborative Editing System Services..." -ForegroundColor Green

$services = @(
    @{Name="User Service"; Port=8081; Path="/users"},
    @{Name="Document Service"; Port=8082; Path="/documents"},
    @{Name="Version Service"; Port=8083; Path="/versions"},
    @{Name="API Gateway"; Port=8080; Path="/api/users"}
)

foreach ($service in $services) {
    Write-Host "`nTesting $($service.Name) on port $($service.Port)..." -ForegroundColor Yellow
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$($service.Port)$($service.Path)" -Method GET -TimeoutSec 5 -ErrorAction Stop
        Write-Host "✓ $($service.Name) is running!" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404) {
            Write-Host "✓ $($service.Name) is running (404 is expected for empty endpoints)" -ForegroundColor Green
        } else {
            Write-Host "✗ $($service.Name) is not responding: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "`nAll service tests completed!" -ForegroundColor Cyan

