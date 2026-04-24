@echo off
:: Set variables WITHOUT quotes here
SET PROJ_ROOT=C:\hyms
SET OVMS_BIN=%PROJ_ROOT%\ovms\ovms.exe

:: 1. Add OVMS to Path
SET "PATH=%PROJ_ROOT%\ovms;%PROJ_ROOT%\ovms\python;%PATH%"

:: 2. Launch OVMS
:: We use the path without quotes in the assignment, then quote the usage.
echo Launching OpenVINO Model Server...
start "OVMS" /D "%PROJ_ROOT%\ovms" cmd /k "%OVMS_BIN% --model_repository_path %PROJ_ROOT%\models --model_name deepseek-r1 --port 9000 --rest_port 8000 --target_device CPU --task text_generation"

:: 3. Wait for OVMS to be ready (CPU model compilation takes 60-120s)
echo [WAIT] Waiting for OVMS to be ready at http://127.0.0.1:8000/v3/models ...
:wait_loop
timeout /t 5 /nobreak >nul
curl -s -o nul -w "%%{http_code}" http://127.0.0.1:8000/v3/models | findstr /r "^200$" >nul 2>&1
if errorlevel 1 (
    echo [WAIT] Still loading model... retrying in 5s
    goto wait_loop
)
echo [WAIT] OVMS is ready!

:: 4. Launch BiFrost
echo Launching BiFrost...
start "BIFROST" /D "%PROJ_ROOT%" cmd /k "npx -y @maximhq/bifrost -app-dir config"

echo.
echo ==========================================
echo DEEPSEEK-R1 STACK INITIALIZED
echo ==========================================