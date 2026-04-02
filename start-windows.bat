@echo off
title Portable Uncensored AI - Launcher
color 0A

echo ===================================================
echo     Launching Portable AI Engine from USB...       
echo ===================================================

:: Set Ollama model data path to the USB drive
set "OLLAMA_MODELS=%~dp0ollama\data"

:: Override APPDATA so AnythingLLM saves ALL data on the USB (not on host PC!)
set "APPDATA=%~dp0anythingllm_data"

:: Set STORAGE_DIR so AnythingLLM uses official portable data path
set "STORAGE_DIR=%~dp0anythingllm_data"

:: Start Ollama Engine silently in the background
echo Starting Ollama Engine...
start "" /B "%~dp0ollama\ollama.exe" serve

:: Give it a few seconds to boot up
timeout /t 3 >nul

:: Find and launch AnythingLLM
echo Starting AnythingLLM Interface...

if exist "%~dp0anythingllm\AnythingLLM.exe" (
    set "APP_PATH=%~dp0anythingllm\AnythingLLM.exe"
    goto LaunchApp
)
if exist "%~dp0anythingllm_app\AnythingLLM.exe" (
    set "APP_PATH=%~dp0anythingllm_app\AnythingLLM.exe"
    goto LaunchApp
)

echo.
echo First time Windows Setup: Extracting AnythingLLM to USB...
echo (This will take 1-3 minutes depending on your USB speed!)
echo Please wait patiently and do not close this window...

taskkill /F /IM "AnythingLLM.exe" /IM "AnythingLLMDesktop.exe" >nul 2>&1

if exist "%~dp0anythingllm\AnythingLLM_Installer.exe" (
    start /wait "" "%~dp0anythingllm\AnythingLLM_Installer.exe" /CURRENTUSER /S /D=%~sdp0anythingllm_app
) else if exist "%~dp0anythingllm\AnythingLLMDesktop.exe" (
    start /wait "" "%~dp0anythingllm\AnythingLLMDesktop.exe" /CURRENTUSER /S /D=%~sdp0anythingllm_app
) else (
    echo.
    echo ERROR: AnythingLLM was not found on this USB drive!
    echo Please run install.bat first to download everything.
    echo.
    pause
    exit /b
)

set WaitCount=0
:WaitLoop
if exist "%~dp0anythingllm_app\AnythingLLM.exe" (
    set "APP_PATH=%~dp0anythingllm_app\AnythingLLM.exe"
    goto LaunchApp
)
if %WaitCount% geq 24 goto LaunchFail
timeout /t 5 >nul
set /a WaitCount+=1
goto WaitLoop

:LaunchFail
echo.
echo ERROR: AnythingLLM failed to extract natively! 
echo Please cancel the script, manually extract AnythingLLMDesktop.exe, and try again!
echo.
pause
exit /b

:LaunchApp
start "" "%APP_PATH%"

:Running
echo.
echo ===================================================
echo   SYSTEM ONLINE: Your AI is running from the USB!  
echo ===================================================
echo.
echo You can now use the AnythingLLM window to chat.
echo Keep this black window open to keep the AI engine running!
echo.
echo Press any key to SHUT DOWN the AI safely...
echo.
pause

:: Clean shutdown
taskkill /F /IM "ollama.exe" >nul 2>&1
taskkill /F /IM "AnythingLLM.exe" >nul 2>&1
echo.
echo AI Engine shut down. You may safely eject the USB.
timeout /t 3 >nul
