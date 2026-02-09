echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo.
echo =============================================
echo  Сборка Docker-образа markoff-backend:dev
echo  Контекст сборки: корень проекта
echo =============================================
echo.

cd /d "%~dp0"

if not exist "docker\Dockerfile.backend" (
    echo ОШИБКА: файл docker\Dockerfile.backend не найден!
    echo Текущая папка: %CD%
    pause
    exit /b 1
)

echo Текущая директория: %CD%
echo.

docker build ^
    -f docker/Dockerfile.backend ^
    -t markoff-backend:dev ^
    .

if %ERRORLEVEL% equ 0 (
    echo.
    echo =============================================
    echo УСПЕХ! Образ markoff-backend:dev успешно собран.
    echo.
    docker images | findstr markoff-backend
    echo.
) else (
    echo.
    echo =============================================
    echo ОШИБКА при сборке! Код ошибки: %ERRORLEVEL%
    echo Посмотрите вывод выше — там должна быть причина.
)

echo.
pause