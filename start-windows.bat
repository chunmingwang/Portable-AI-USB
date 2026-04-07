@echo off
title Portable Uncensored AI - Launcher
color 0A

echo ===================================================
echo     Launching Portable AI Engine from USB...       
echo ===================================================

:: -------------------------------------------------------
:: IMPORTANT: All paths must point to USB, not the PC!
:: -------------------------------------------------------

:: Set Ollama model data path to the USB drive
set "OLLAMA_MODELS=%~dp0ollama\data"

:: Tell AnythingLLM to store ALL its data on the USB
:: STORAGE_DIR is the official AnythingLLM portable env var
set "STORAGE_DIR=%~dp0anythingllm_data"
set "ANYTHINGLLM_PROFILE=%STORAGE_DIR%\anythingllm-desktop"
set "ROAMING_PROFILE=%USERPROFILE%\AppData\Roaming\anythingllm-desktop"
set "PROFILE_BACKUP=%USERPROFILE%\AppData\Roaming\anythingllm-desktop.host-backup"

:: Also override APPDATA AND XDG paths for Electron safety net
set "APPDATA=%~dp0anythingllm_data"
set "LOCALAPPDATA=%~dp0anythingllm_data"

:: Create the data folder on USB if it doesn't exist
if not exist "%~dp0anythingllm_data" mkdir "%~dp0anythingllm_data"
if not exist "%ANYTHINGLLM_PROFILE%" mkdir "%ANYTHINGLLM_PROFILE%"

:: -------------------------------------------------------
:: ENSURE ANYTHINGLLM USES EXTERNAL OLLAMA (not built-in)
:: -------------------------------------------------------
set "ENV_FILE=%~dp0anythingllm_data\storage\.env"
if not exist "%~dp0anythingllm_data\storage" mkdir "%~dp0anythingllm_data\storage"

:: Read the first model from installed-models.txt if it exists
set "DEFAULT_MODEL=nemomix-local"
if exist "%~dp0models\installed-models.txt" (
    for /f "usebackq tokens=1 delims=|" %%a in ("%~dp0models\installed-models.txt") do (
        set "DEFAULT_MODEL=%%a"
        goto :GotModel
    )
)
:GotModel

:: Check if .env needs fixing (missing or using built-in ollama)
set "NEEDS_FIX=0"
if not exist "%ENV_FILE%" set "NEEDS_FIX=1"
if exist "%ENV_FILE%" (
    findstr /C:"LLM_PROVIDER=ollama" "%ENV_FILE%" >nul 2>&1
    if errorlevel 1 (
        findstr /C:"LLM_PROVIDER=anythingllm_ollama" "%ENV_FILE%" >nul 2>&1
        if not errorlevel 1 set "NEEDS_FIX=1"
    )
)

if "%NEEDS_FIX%"=="1" (
    echo Configuring AnythingLLM to use external Ollama engine...
    (
        echo LLM_PROVIDER=ollama
        echo OLLAMA_BASE_PATH=http://127.0.0.1:11434
        echo OLLAMA_MODEL_PREF=%DEFAULT_MODEL%
        echo OLLAMA_MODEL_TOKEN_LIMIT=4096
        echo EMBEDDING_ENGINE=native
        echo VECTOR_DB=lancedb
    ) > "%ENV_FILE%"
    echo Done. Default model: %DEFAULT_MODEL%
)

:: -------------------------------------------------------
:: PROFILE REDIRECT PREVENTED
:: -------------------------------------------------------
:: Electron '--user-data-dir' completely overrides profile creation,
:: ensuring Everything is purely portable on the USB drive.


:: -------------------------------------------------------
:: SHOW INSTALLED MODELS
:: -------------------------------------------------------
if exist "%~dp0models\installed-models.txt" (
    echo.
    echo Installed models:
    for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%~dp0models\installed-models.txt") do (
        echo   - %%b [%%c]
    )
    echo.
)

:: Start Ollama Engine silently in the background
echo Starting Ollama Engine...
start "" /B "%~dp0ollama\ollama.exe" serve

:: Give it a few seconds to boot up
timeout /t 3 >nul

:: Find and launch AnythingLLM
echo Starting AnythingLLM Interface...

if exist "%~dp0anythingllm_data\Programs\anythingllm-desktop\AnythingLLM.exe" (
    set "APP_PATH=%~dp0anythingllm_data\Programs\anythingllm-desktop\AnythingLLM.exe"
    goto LaunchApp
)

echo.
echo ERROR: AnythingLLM was not found on this USB drive!
echo It appears the installation process is not complete.
echo Please run install.bat first to download and extract everything.
echo.
pause
exit /b

:LaunchApp
:: Pass --user-data-dir directly to Electron to FORCE data storage on USB
:: This is the most reliable method — overrides all internal Electron path logic
start "" "%APP_PATH%" --user-data-dir="%~dp0anythingllm_data"

:Running
echo.
echo ===================================================
echo   SYSTEM ONLINE: Your AI is running from the USB!  
echo ===================================================
echo.
echo You can now use the AnythingLLM window to chat.
echo Keep this black window open to keep the AI engine running!
echo.
echo TIP: Go to Settings ^> LLM to switch between models.
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
