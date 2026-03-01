# build-backend.ps1
# =============================================================================
# Скрипт для сборки Docker-образа backend-приложения Markoff
# Запускается из корня проекта (E:\Projects\Markoff_2.0)
# Контекст сборки — папка backend/
# Dockerfile — docker/Dockerfile.backend
# =============================================================================

# Выводим красивый заголовок, чтобы было понятно, что сейчас происходит
Write-Host "Сборка образа markoff-backend:dev" -ForegroundColor Cyan
Write-Host "Контекст сборки: backend/" -ForegroundColor DarkGray
Write-Host "Используемый Dockerfile: docker/Dockerfile.backend" -ForegroundColor DarkGray
Write-Host "----------------------------------------" -ForegroundColor DarkGray

# -----------------------------------------------------------------------------
# 1. Очистка перед сборкой
# -----------------------------------------------------------------------------
# Если контейнер markoff-backend уже запущен — останавливаем его
# 2>$null — скрываем сообщение об ошибке, если контейнера нет
docker stop markoff-backend 2>$null

# Удаляем остановленный контейнер (если он существовал)
# Опять же 2>$null — чтобы не показывать ошибку "No such container"
docker rm markoff-backend 2>$null

# -----------------------------------------------------------------------------
# 2. Сборка образа
# -----------------------------------------------------------------------------
# Ключевые параметры команды docker build:
#   -f docker/Dockerfile.backend   → явно указываем путь к Dockerfile
#   -t markoff-backend:dev         → имя и тег образа (markoff-backend версии dev)
#   backend                        → контекст сборки — вся папка backend/
#                                     (именно отсюда берутся requirements.txt и src/)
Write-Host "Запускаем сборку образа..." -ForegroundColor Yellow

docker build `
  -f docker/Dockerfile.backend `
  -t markoff-backend:dev `
  backend

# -----------------------------------------------------------------------------
# 3. Проверка результата сборки
# -----------------------------------------------------------------------------
# $LASTEXITCODE — специальная переменная PowerShell, содержит код возврата
# последней выполненной внешней команды (в данном случае docker build)
# 0 = успех, любое другое значение = ошибка
if ($LASTEXITCODE -eq 0) {
    Write-Host "`nУСПЕХ!" -ForegroundColor Green -BackgroundColor Black
    Write-Host "Образ markoff-backend:dev успешно собран." -ForegroundColor Green
    Write-Host "Список локальных образов (фильтр по имени):" -ForegroundColor DarkGray
    
    # Показываем только строки, содержащие markoff-backend
    docker images | Select-String "markoff-backend"
    
    Write-Host "`nТеперь можно запустить контейнер с помощью run-backend.ps1" -ForegroundColor Cyan
} else {
    Write-Host "`nОШИБКА СБОРКИ" -ForegroundColor Red -BackgroundColor Black
    Write-Host "Код возврата docker build: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "Возможные причины:" -ForegroundColor Yellow
    Write-Host "  • Ошибка в Dockerfile" -ForegroundColor Yellow
    Write-Host "  • Отсутствует requirements.txt или папка src в backend/" -ForegroundColor Yellow
    Write-Host "  • Нет интернета / проблемы с Docker Hub" -ForegroundColor Yellow
    Write-Host "  • Недостаточно места на диске" -ForegroundColor Yellow
    Write-Host "`nПосмотрите строки выше — там указана точная причина." -ForegroundColor White
}

# -----------------------------------------------------------------------------
# 4. Пауза в конце — чтобы пользователь успел прочитать результат
# -----------------------------------------------------------------------------
Write-Host "`nНажмите любую клавишу для выхода..." -ForegroundColor DarkGray
Pause