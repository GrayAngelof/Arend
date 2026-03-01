# build-client.ps1
# =============================================================================
# Скрипт для сборки Docker-образа desktop-клиента Markoff (PySide6)
# Запускается из корня проекта (E:\Projects\Markoff_2.0)
# Контекст сборки — папка client/
# Dockerfile — docker/Dockerfile.client
# =============================================================================

# Выводим красивый заголовок, чтобы было понятно, что сейчас происходит
Write-Host "Сборка образа markoff-client:dev" -ForegroundColor Cyan
Write-Host "Контекст сборки: client/" -ForegroundColor DarkGray
Write-Host "Используемый Dockerfile: docker/Dockerfile.client" -ForegroundColor DarkGray
Write-Host "----------------------------------------" -ForegroundColor DarkGray

# -----------------------------------------------------------------------------
# 1. Очистка перед сборкой
# -----------------------------------------------------------------------------
# Если контейнер markoff-client уже запущен — останавливаем его
# 2>$null — скрываем сообщение об ошибке, если контейнера нет
docker stop markoff-client 2>$null

# Удаляем остановленный контейнер (если он существовал)
docker rm markoff-client 2>$null

# -----------------------------------------------------------------------------
# 2. Сборка образа
# -----------------------------------------------------------------------------
# Ключевые параметры команды docker build:
#   -f docker/Dockerfile.client   → явно указываем путь к Dockerfile
#   -t markoff-client:dev         → имя и тег образа (markoff-client версии dev)
#   client                        → контекст сборки — вся папка client/
#                                     (именно отсюда берутся requirements.txt и src/)
Write-Host "Запускаем сборку образа..." -ForegroundColor Yellow

docker build `
  -f docker/Dockerfile.client `
  -t markoff-client:dev `
  client

# -----------------------------------------------------------------------------
# 3. Проверка результата сборки
# -----------------------------------------------------------------------------
if ($LASTEXITCODE -eq 0) {
    Write-Host "`nУСПЕХ!" -ForegroundColor Green -BackgroundColor Black
    Write-Host "Образ markoff-client:dev успешно собран." -ForegroundColor Green
    Write-Host "Список локальных образов (фильтр по имени):" -ForegroundColor DarkGray
    
    # Показываем только строки, содержащие markoff-client
    docker images | Select-String "markoff-client"
    
    Write-Host "`nТеперь можно запустить приложение с помощью run-client.ps1" -ForegroundColor Cyan
} else {
    Write-Host "`nОШИБКА СБОРКИ" -ForegroundColor Red -BackgroundColor Black
    Write-Host "Код возврата docker build: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "Возможные причины:" -ForegroundColor Yellow
    Write-Host "  • Ошибка в Dockerfile.client" -ForegroundColor Yellow
    Write-Host "  • Отсутствует client/requirements.txt или client/src/main.py" -ForegroundColor Yellow
    Write-Host "  • Нет интернета / проблемы с Docker Hub" -ForegroundColor Yellow
    Write-Host "  • Недостаточно места на диске" -ForegroundColor Yellow
    Write-Host "  • Отсутствуют системные зависимости для Qt (проверь RUN apt-get ...)" -ForegroundColor Yellow
    Write-Host "`nПосмотрите строки выше — там указана точная причина." -ForegroundColor White
}

# -----------------------------------------------------------------------------
# 4. Пауза в конце — чтобы пользователь успел прочитать результат
# -----------------------------------------------------------------------------
Write-Host "`nНажмите любую клавишу для выхода..." -ForegroundColor DarkGray
Pause