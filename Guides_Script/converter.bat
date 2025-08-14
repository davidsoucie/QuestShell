@echo off
echo.
echo 🎮 TourGuide to QuestShell Converter
echo ========================================
echo.

if "%~1"=="" (
    echo No file provided. Please drag and drop a .lua file onto this batch file.
    echo.
    echo Or run: converter.bat "path\to\your\file.lua"
    echo.
    pause
    exit /b
)

if not exist "%~1" (
    echo ❌ Error: File "%~1" not found!
    echo.
    pause
    exit /b
)

echo Processing: %~nx1
echo.

python "%~dp0converter.py" "%~1"

pause