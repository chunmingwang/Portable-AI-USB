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

:: Start Ollama Engine silently in the background
echo Starting Ollama Engine...
start "" /B "%~dp0ollama\ollama.exe" serve

:: Give it a few seconds to boot up
timeout /t 3 >nul

:: Find and launch AnythingLLM
echo Starting AnythingLLM Interface...

if exist "%~dp0anythingllm\AnythingLLM.exe" (
    start "" "%~dp0anythingllm\AnythingLLM.exe"
    goto Running
)

echo.
echo ERROR: AnythingLLM was not found on this USB drive!
echo Please run install.bat first to download everything.
echo.
pause
exit /b

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
