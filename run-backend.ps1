# run-backend.ps1
Write-Host "Starting Markoff Backend..." -ForegroundColor Cyan

# Останавливаем если уже запущен
docker stop markoff-backend 2>$null
docker rm markoff-backend 2>$null

Write-Host "Starting container with hot reload..." -ForegroundColor Yellow
docker run -d `
  --name markoff-backend `
  --rm `
  -p 8000:8000 `
  -v "${PWD}\backend\src:/app/src" `
  -e DATABASE_URL="postgresql+psycopg2://markoff:1@192.168.2.4:5432/markoff2_0_db" `
  -e ENVIRONMENT=development `
  -e PYTHONUNBUFFERED=1 `
  markoff-backend:dev

Write-Host "✅ Container started!" -ForegroundColor Green
Write-Host "`nAccess URLs:" -ForegroundColor Cyan
Write-Host "  http://localhost:8000" -ForegroundColor White
Write-Host "  http://localhost:8000/docs" -ForegroundColor White
Write-Host "`nTo view logs: docker logs -f markoff-backend" -ForegroundColor Yellow

