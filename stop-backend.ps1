# stop-backend.ps1
Write-Host "Stopping Markoff Backend..." -ForegroundColor Cyan
docker stop markoff-backend 2>$null
docker rm markoff-backend 2>$null
Write-Host "✅ Container stopped and removed" -ForegroundColor Green