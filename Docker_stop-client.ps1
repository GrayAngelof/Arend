# stop-client.ps1
# =============================================================================
# Остановка контейнера Markoff Desktop Client
# =============================================================================

Write-Host ""
Write-Host "Остановка Markoff Desktop Client" -ForegroundColor Cyan
Write-Host "Контейнер: markoff-client" -ForegroundColor DarkGray
Write-Host "----------------------------------------" -ForegroundColor DarkGray

# Проверяем, существует ли контейнер
$container = docker ps -a -q -f name=^markoff-client$
if (-not $container) {
    Write-Host "Контейнер markoff-client не найден (уже остановлен или никогда не запускался)" -ForegroundColor DarkGray
    Write-Host ""
    Pause
    exit 0
}

Write-Host "Останавливаем контейнер..." -ForegroundColor Yellow
docker stop markoff-client

if ($LASTEXITCODE -ne 0) {
    Write-Host "Ошибка при остановке контейнера" -ForegroundColor Red
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "УСПЕХ!" -ForegroundColor Green -BackgroundColor Black
    Write-Host "Контейнер markoff-client остановлен и удалён." -ForegroundColor Green
    Write-Host "Окно приложения должно закрыться (если ещё открыто)." -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "ОШИБКА при удалении" -ForegroundColor Red
    Write-Host "Код возврата: $LASTEXITCODE" -ForegroundColor Red
}

Write-Host ""
Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor DarkGray
Pause