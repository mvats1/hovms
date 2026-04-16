@echo off
:: Set variables WITHOUT quotes here
SET PROJ_ROOT=C:\hyms
SET OVMS_BIN=%PROJ_ROOT%\ovms\ovms.exe

:: 1. Add OVMS to Path
SET "PATH=%PROJ_ROOT%\ovms;%PROJ_ROOT%\ovms\python;%PATH%"

:: 2. Launch OpenVINO (The Hands)
:: We use the path without quotes in the assignment, then quote the usage.
echo [HANDS] Launching OpenVINO GenAI Server...
start "OVMS-HANDS" /D "%PROJ_ROOT%\ovms" cmd /k "%OVMS_BIN% --model_repository_path %PROJ_ROOT%\models --model_name deepseek-r1 --port 9000 --rest_port 8000 --target_device CPU --task text_generation"

:: 3. Wait for CPU to compile the model
timeout /t 10

:: 4. Launch BiFrost (The Brain)
echo [BRAIN] Launching BiFrost...
start "BIFROST-BRAIN" /D "%PROJ_ROOT%" cmd /k "npx -y @maximhq/bifrost -app-dir config"

echo.
echo ==========================================
echo DEEPSEEK-R1 STACK INITIALIZED
echo ==========================================