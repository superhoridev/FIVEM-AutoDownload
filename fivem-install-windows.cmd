@echo off
title FiveM Server Installer by SuperHoriDev

:: --- Configuration ---
:: This script will automatically download the latest recommended build of FiveM.
:: The artifacts list can be found at: https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/
set "DEFAULT_BASE_URL=https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/17000-e0ef7490f76a24505b8bac7065df2b7075e610ba/server.7z"
set "DEFAULT_INSTALL_PATH=C:\Users\Administrator\Desktop\FXServer"

:: --- Prerequisite Check ---
echo Checking for prerequisites...
where /q 7z
if %errorlevel% neq 0 goto no_7z

where /q curl
if %errorlevel% neq 0 goto no_curl

echo Prerequisites found.
echo.
goto main_logic

:no_7z
echo.
echo [ERROR] 7-Zip is not installed or not in your system's PATH.
echo Please install 7-Zip and ensure '7z.exe' is accessible from the command line.
echo Download from: https://www.7-zip.org/
echo.
pause
exit /b 1

:no_curl
echo.
echo [ERROR] curl.exe was not found.
echo This script requires cURL, which is included in modern versions of Windows.
echo If you are on an older system, please install it or update Windows.
echo.
pause
exit /b 1

:main_logic
:: --- User Input for Installation Path ---
echo FiveM Server Artifacts Installer
echo ---------------------------------
set /p "INSTALL_PATH=Enter the installation path (or press Enter for default [%DEFAULT_INSTALL_PATH%]): "

if "%INSTALL_PATH%"=="" (
    set "INSTALL_PATH=%DEFAULT_INSTALL_PATH%"
)

echo.
echo Server will be installed to: %INSTALL_PATH%
echo.

:: --- Directory Setup ---
if not exist "%INSTALL_PATH%" (
    echo Creating directory: %INSTALL_PATH%
    mkdir "%INSTALL_PATH%"
)

:: Change to the installation directory
cd /d "%INSTALL_PATH%"

:: --- Determine Latest Artifact URL ---

set /p "BASE_URL=Enter the fivem artifacts url version (or press Enter for default [%DEFAULT_BASE_URL%]): "

if "%BASE_URL%"=="" (
    set "BASE_URL=%DEFAULT_BASE_URL%"
)

set "ARTIFACTS_URL=%BASE_URL%"
echo Latest recommended build is %LATEST_BUILD%.
echo.
goto download

:fetch_error_read
echo.
echo [ERROR] Could not read the latest build number. The LATEST-RECOMMENDED file might be empty or corrupt.
echo.
pause
exit /b 1

:download
:: --- Download Artifacts ---
echo Downloading FiveM artifacts...
echo URL: %ARTIFACTS_URL%
curl -L -o server.7z "%ARTIFACTS_URL%"

if %errorlevel% neq 0 goto dl_error
if not exist "server.7z" goto dl_error_no_file

echo Download complete.
echo.
goto extract

:dl_error
echo.
echo [ERROR] Download failed. Please check your internet connection and the URL.
echo.
pause
exit /b 1

:dl_error_no_file
echo.
echo [ERROR] Download completed, but the artifact file (server.7z) was not found.
echo.
pause
exit /b 1

:extract
:: --- Extraction ---
echo Extracting files...
echo This may take a moment.
7z x server.7z -y > nul

if %errorlevel% neq 0 goto extract_error

echo Extraction complete.
echo.
goto cleanup

:extract_error
echo.
echo [ERROR] Failed to extract server.7z. The archive might be corrupt or 7-Zip encountered an error.
echo.
pause
exit /b 1

:cleanup
:: --- Cleanup ---
echo Cleaning up temporary files...
del server.7z
echo Cleanup complete.
echo.
goto end_message

:end_message
:: --- Completion Message ---
echo ----------------------------------------------------------------
echo  FiveM server artifacts successfully installed!
echo  
echo  Server Path: %INSTALL_PATH%
echo.
echo  Next Steps:
echo  1. Create a 'server.cfg' file to configure your server.
echo  2. Get a license key from https://keymaster.fivem.net
echo  3. Run the server using 'FXServer.exe'.
echo ----------------------------------------------------------------
echo.
pause

