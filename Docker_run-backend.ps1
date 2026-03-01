# run-backend.ps1
# =============================================================================
# Скрипт для запуска backend-контейнера Markoff (FastAPI + hot-reload)
# Запускается из корня проекта (E:\Projects\Markoff_2.0)
# =============================================================================

Write-Host ""
Write-Host "Запуск Markoff Backend (FastAPI)" -ForegroundColor Cyan
Write-Host "Образ: markoff-backend:dev" -ForegroundColor DarkGray
Write-Host "----------------------------------------" -ForegroundColor DarkGray

# -----------------------------------------------------------------------------
# 1. Проверка наличия образа
# -----------------------------------------------------------------------------
$imageExists = docker images -q markoff-backend:dev
if (-not $imageExists) {
    Write-Host "ОШИБКА: Образ markoff-backend:dev не найден!" -ForegroundColor Red
    Write-Host "Сначала выполните build-backend.bat / .ps1" -ForegroundColor Yellow
    Pause
    exit 1
}

# -----------------------------------------------------------------------------
# 2. Очистка перед запуском
# -----------------------------------------------------------------------------
Write-Host "Останавливаем и удаляем старый контейнер..." -ForegroundColor Yellow
docker stop markoff-backend 2>$null
docker rm markoff-backend 2>$null

# -----------------------------------------------------------------------------
# 3. Запуск
# -----------------------------------------------------------------------------
Write-Host "Запускаем backend с hot-reload..." -ForegroundColor Yellow

docker run -d `
  --name markoff-backend `
  --rm `
  -p 8000:8000 `
  -v "${PWD}\backend\src:/app/src" `
  -e DATABASE_URL="postgresql+psycopg2://markoff:1@192.168.2.4:5432/markoff2_0_db" `
  -e ENVIRONMENT=development `
  -e PYTHONUNBUFFERED=1 `
  markoff-backend:dev

# -----------------------------------------------------------------------------
# 4. Результат
# -----------------------------------------------------------------------------
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "УСПЕХ!" -ForegroundColor Green -BackgroundColor Black
    Write-Host "Backend запущен." -ForegroundColor Green
    Write-Host ""
    Write-Host "Доступные адреса:" -ForegroundColor Cyan
    Write-Host "  • Swagger UI:     http://localhost:8000/docs" -ForegroundColor White
    Write-Host "  • Root:            http://localhost:8000/" -ForegroundColor White
    Write-Host "  • Health:          http://localhost:8000/health" -ForegroundColor White
    Write-Host ""
    Write-Host "Логи в реальном времени: docker logs -f markoff-backend" -ForegroundColor DarkGray
    Write-Host "Остановить:          docker stop markoff-backend" -ForegroundColor DarkGray
} else {
    Write-Host ""
    Write-Host "ОШИБКА ЗАПУСКА" -ForegroundColor Red
    Write-Host "Код: $LASTEXITCODE" -ForegroundColor Red
}

Write-Host ""
Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor DarkGray
Pause