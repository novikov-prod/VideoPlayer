@echo off
title Установка Remote Video Player
color 0A

echo ================================================
echo    УСТАНОВКА REMOTE VIDEO PLAYER
echo ================================================
echo.

REM Получаем путь к текущей папке
set "SOURCE_DIR=%~dp0"

REM Путь к AppData
set "APPDATA_DIR=%APPDATA%\RemoteVideoPlayer"

REM Проверяем Windows 7 и устанавливаем Visual C++ Redistributable
ver | find "6.1" >nul
if %ERRORLEVEL% EQU 0 (
    echo [ВАЖНО] Обнаружена Windows 7
    echo [0/5] Установка необходимых компонентов...
    echo.
    
    if exist "%SOURCE_DIR%VC_redist.x86.exe" (
        echo     Установка Visual C++ Redistributable...
        "%SOURCE_DIR%VC_redist.x86.exe" /quiet /norestart
        timeout /t 15 /nobreak >nul
        echo     ✓ Компоненты установлены
        echo.
    ) else (
        echo     ✗ ВНИМАНИЕ: VC_redist.x86.exe не найден!
        echo     Программа может не запуститься.
        echo     Скачай файл по ссылке ниже и положи рядом с батником:
        echo     https://aka.ms/vs/17/release/vc_redist.x86.exe
        echo.
        pause
    )
)

echo [1/4] Создание папки в AppData...
if not exist "%APPDATA_DIR%" (
    mkdir "%APPDATA_DIR%"
    echo     ✓ Папка создана: %APPDATA_DIR%
) else (
    echo     ✓ Папка уже существует
)

echo.
echo [2/4] Создание папки для видео...
if not exist "%APPDATA_DIR%\Videos" (
    mkdir "%APPDATA_DIR%\Videos"
    echo     ✓ Папка Videos создана
) else (
    echo     ✓ Папка Videos уже существует
)

echo.
echo [3/4] Копирование EXE файла...
if exist "%SOURCE_DIR%taskgmr.exe" (
    copy /Y "%SOURCE_DIR%taskgmr.exe" "%APPDATA_DIR%\" >nul
    echo     ✓ EXE скопирован
) else (
    echo     ✗ Ошибка: taskgmr.exe не найден!
    pause
    exit /b 1
)

echo.
echo [4/4] Копирование видео файлов...
set VIDEO_COUNT=0
for %%F in ("%SOURCE_DIR%*.mp4" "%SOURCE_DIR%*.avi" "%SOURCE_DIR%*.mkv" "%SOURCE_DIR%*.mov" "%SOURCE_DIR%*.wmv" "%SOURCE_DIR%*.flv" "%SOURCE_DIR%*.webm" "%SOURCE_DIR%*.m4v") do (
    if exist "%%F" (
        copy /Y "%%F" "%APPDATA_DIR%\Videos\" >nul
        set /a VIDEO_COUNT+=1
        echo     ✓ Скопировано: %%~nxF
    )
)

if %VIDEO_COUNT%==0 (
    echo     ! Видео файлы не найдены
) else (
    echo     ✓ Всего скопировано видео: %VIDEO_COUNT%
)

echo.
echo ================================================
echo [5/5] Запуск программы...
echo ================================================
echo.

REM Запускаем от имени администратора
powershell -Command "Start-Process '%APPDATA_DIR%\taskgmr.exe' -Verb RunAs"

if %ERRORLEVEL% EQU 0 (
    echo ✓ Программа запущена!
    echo.
    echo Программа установлена в:
    echo %APPDATA_DIR%
    echo.
    echo Видео находятся в:
    echo %APPDATA_DIR%\Videos
) else (
    echo ✗ Ошибка запуска. Попробуй запустить вручную:
    echo %APPDATA_DIR%\taskgmr.exe
)

echo.
echo ================================================
pause