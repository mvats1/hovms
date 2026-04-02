@echo off
SETLOCAL

:: 1. Define Project Root
SET "PROJ_ROOT=C:\hyms"

:: 2. Fix DLL Pathing
SET "PATH=%PROJ_ROOT%\ovms\python;%PROJ_ROOT%\ovms;%PATH%"

:: 3. Start OpenVINO Model Server (The Hands)
:: Removed the backslashes from the quotes here
echo [HANDS] Launching OpenVINO...
start "OVMS-HANDS" /D "%PROJ_ROOT%\ovms" cmd /k "ovms.exe --model_path %PROJ_ROOT%\models --model_name deepseek-r1 --port 9000 --rest_port 8000 --target_device CPU"

:: 4. Wait for initialization
timeout /t 5

:: 5. Start BiFrost Gateway (The Brain)
:: Removed the escaped quotes that were breaking the directory creation
echo [BRAIN] Launching BiFrost...
start "BIFROST-BRAIN" /D "%PROJ_ROOT%" cmd /k "npx -y @maximhq/bifrost -app-dir config"

echo.
echo ==========================================
echo BIFROST + OPENVINO REPAIRED
echo ==========================================