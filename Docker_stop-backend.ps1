# stop-backend.ps1
# =============================================================================
# Остановка контейнера Markoff Backend
# =============================================================================

Write-Host ""
Write-Host "Остановка Markoff Backend" -ForegroundColor Cyan
Write-Host "Контейнер: markoff-backend" -ForegroundColor DarkGray
Write-Host "----------------------------------------" -ForegroundColor DarkGray

# Проверяем, существует ли контейнер
$container = docker ps -a -q -f name=^markoff-backend$
if (-not $container) {
    Write-Host "Контейнер markoff-backend не найден (уже остановлен или никогда не запускался)" -ForegroundColor DarkGray
    Write-Host ""
    Pause
    exit 0
}

Write-Host "Останавливаем контейнер..." -ForegroundColor Yellow
docker stop markoff-backend

if ($LASTEXITCODE -ne 0) {
    Write-Host "Ошибка при остановке контейнера" -ForegroundColor Red
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "УСПЕХ!" -ForegroundColor Green -BackgroundColor Black
    Write-Host "Контейнер markoff-backend остановлен и удалён." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "ОШИБКА при удалении" -ForegroundColor Red
    Write-Host "Код возврата: $LASTEXITCODE" -ForegroundColor Red
}

Write-Host ""
Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor DarkGray
Pause
