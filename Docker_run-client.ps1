# run-client.ps1
# =============================================================================
# Скрипт для запуска Docker-контейнера с desktop-приложением Markoff (PySide6)
# Запускается из корня проекта (E:\Projects\Markoff_2.0)
# Запускает графическое приложение в контейнере
# =============================================================================

Write-Host ""
Write-Host "Запуск Markoff Desktop Client" -ForegroundColor Cyan
Write-Host "Образ: markoff-client:dev" -ForegroundColor DarkGray
Write-Host "----------------------------------------" -ForegroundColor DarkGray

# -----------------------------------------------------------------------------
# 1. Проверка наличия образа
# -----------------------------------------------------------------------------
$imageExists = docker images -q markoff-client:dev
if (-not $imageExists) {
    Write-Host "ОШИБКА: Образ markoff-client:dev не найден!" -ForegroundColor Red
    Write-Host "Сначала выполните build-client.ps1" -ForegroundColor Yellow
    Write-Host ""
    Pause
    exit 1
}

# -----------------------------------------------------------------------------
# 2. Очистка перед запуском
# -----------------------------------------------------------------------------
Write-Host "Останавливаем и удаляем старый контейнер (если существует)..." -ForegroundColor Yellow
docker stop markoff-client 2>$null
docker rm markoff-client 2>$null

# -----------------------------------------------------------------------------
# 3. Запуск контейнера
# -----------------------------------------------------------------------------
Write-Host "Запускаем приложение в контейнере..." -ForegroundColor Yellow

# Важно: для графического приложения в Windows используем --network=host + X11 forwarding не нужен,
# но в Docker Desktop для Windows графический вывод работает через VcXsrv / XLaunch или встроенный в Docker Desktop
# Если окно не появляется — проверь, установлен ли VcXsrv и запущен ли X-сервер
# -it обязательно для GUI
# --network host чтобы клиент мог достучаться до backend на localhost:8000
# -e DISPLAY для вывода GUI в Windows (Docker Desktop)
# -v /tmp/.X11-unix монтируем X11 сокет (если используешь VcXsrv)
# -v "${PWD} чтобы изменения попадали в контейнер без пересборки

docker run --name markoff-client --rm -it --network host -e DISPLAY=host.docker.internal:0 -v /tmp/.X11-unix:/tmp/.X11-unix -v "${PWD}\client\src:/app/src" markoff-client:dev

# -----------------------------------------------------------------------------
# 4. Проверка результата запуска
# -----------------------------------------------------------------------------
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "УСПЕХ!" -ForegroundColor Green -BackgroundColor Black
    Write-Host "Приложение запущено в контейнере." -ForegroundColor Green
    Write-Host ""
    Write-Host "Ожидайте появления окна приложения." -ForegroundColor Cyan
    Write-Host "Если окно НЕ появилось:" -ForegroundColor Yellow
    Write-Host "  1. Установите VcXsrv (https://sourceforge.net/projects/vcxsrv/)" -ForegroundColor Yellow
    Write-Host "  2. Запустите XLaunch → Multiple windows → Display number -1 → Start no client → Finish" -ForegroundColor Yellow
    Write-Host "  3. Перезапустите run-client.ps1" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Логи контейнера (если нужно): docker logs markoff-client" -ForegroundColor DarkGray
} else {
    Write-Host ""
    Write-Host "ОШИБКА ЗАПУСКА" -ForegroundColor Red -BackgroundColor Black
    Write-Host "Код возврата: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "Возможные причины:" -ForegroundColor Yellow
    Write-Host "  • Нет запущенного X-сервера (VcXsrv / Xming)" -ForegroundColor Yellow
    Write-Host "  • DISPLAY не настроен правильно" -ForegroundColor Yellow
    Write-Host "  • Проблемы с правами / firewall" -ForegroundColor Yellow
    Write-Host "  • Ошибка в main.py" -ForegroundColor Yellow
}

# -----------------------------------------------------------------------------
# 5. Пауза
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor DarkGray
Pause