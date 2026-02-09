@echo off
setlocal EnableDelayedExpansion

echo Создание структуры проекта Markoff_2.0
echo.

set "ROOT=E:\Projects\Markoff_2.0"

if not exist "%ROOT%" (
    mkdir "%ROOT%"
    echo Создана корневая папка: %ROOT%
) else (
    echo Папка %ROOT% уже существует
)

cd /d "%ROOT%" || (
    echo Ошибка: не удалось перейти в %ROOT%
    pause
    exit /b 1
)

:: Основные директории
mkdir config backend nanobot shared docker\environments docker\monitoring docker\init-scripts tests\backend tests\nanobot tests\integration docs scripts

:: backend
mkdir backend\src\api\routers backend\src\db\models backend\src\db\migrations backend\src\utils

:: nanobot
mkdir nanobot\src\providers nanobot\src\skills nanobot\src\channels nanobot\src\stt_tts

:: shared
mkdir shared\schemas

:: docker
mkdir docker\environments

:: docs
mkdir docs

:: scripts
mkdir scripts

:: Создание пустых ключевых файлов (можно потом заполнить)
echo. > config\.env
echo. > config\nanobot_config.json
echo. > config\logging.yaml

echo. > backend\requirements.txt
echo. > backend\src\main.py

echo. > nanobot\requirements.txt
echo. > nanobot\src\main.py

echo. > shared\enums.py

echo. > docker\environments\dev-compose.yml
echo. > docker\Dockerfile.backend
echo. > docker\Dockerfile.nanobot

echo. > docs\architecture.md
echo. > docs\README.md

echo. > scripts\start-dev.bat
echo. > scripts\run-backend.bat
echo. > scripts\run-nanobot.bat

echo.
echo Структура создана:
echo.
tree /f /a
echo.
echo Готово.
echo.

pause