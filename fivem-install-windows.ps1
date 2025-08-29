# Set the title for the PowerShell window
$Host.UI.RawUI.WindowTitle = "FiveM Server Installer by SuperHoriDev (PowerShell Version)"
$DefaultBaseUrl = "https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/17000-e0ef7490f76a24505b8bac7065df2b7075e610ba/server.7z"
$DefaultInstallPath = Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\FXServer"

function Write-ErrorAndExit {
    param(
        [string]$Message
    )
    Write-Host "`n[ERROR] $Message" -ForegroundColor Red
    Read-Host "`nPress Enter to exit."
    exit 1
}

Write-Host "Checking for prerequisites..."
if (-not (Get-Command 7z.exe -ErrorAction SilentlyContinue)) {
    Write-ErrorAndExit @"
7-Zip is not installed or not in your system's PATH.
Please install 7-Zip and ensure '7z.exe' is accessible from the command line.
Download from: https://www.7-zip.org/
"@
}

# Check if 'curl.exe' is available
if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) {
    Write-ErrorAndExit @"
curl.exe was not found.
This script requires cURL, which is included in modern versions of Windows.
If you are on an older system, please install it or update Windows.
"@
}

Write-Host "Prerequisites found.`n"

Write-Host "FiveM Server Artifacts Installer"
Write-Host "---------------------------------"
$InstallPath = Read-Host -Prompt "Enter the installation path (or press Enter for default [$DefaultInstallPath])"

if ([string]::IsNullOrWhiteSpace($InstallPath)) {
    $InstallPath = $DefaultInstallPath
}

Write-Host "`nServer will be installed to: $InstallPath`n"

if (-not (Test-Path -Path $InstallPath)) {
    Write-Host "Creating directory: $InstallPath"
    try {
        New-Item -Path $InstallPath -ItemType Directory -ErrorAction Stop | Out-Null
    }
    catch {
        Write-ErrorAndExit "Could not create directory '$InstallPath'. Please check permissions."
    }
}

try {
    Set-Location -Path $InstallPath -ErrorAction Stop
}
catch {
    Write-ErrorAndExit "Could not change to directory '$InstallPath'."
}

$ArtifactsUrl = Read-Host -Prompt "Enter the FiveM artifacts URL (or press Enter for default)"

if ([string]::IsNullOrWhiteSpace($ArtifactsUrl)) {
    $ArtifactsUrl = $DefaultBaseUrl
}

Write-Host "`nDownloading FiveM artifacts..."
Write-Host "URL: $ArtifactsUrl"

curl.exe -L -o server.7z $ArtifactsUrl

if ($LASTEXITCODE -ne 0) {
    Write-ErrorAndExit "Download failed. Please check your internet connection and the URL. (cURL exit code: $LASTEXITCODE)"
}

if (-not (Test-Path -Path "server.7z")) {
    Write-ErrorAndExit "Download command succeeded, but the artifact file (server.7z) was not found."
}

Write-Host "Download complete."

Write-Host "`nExtracting files..."
Write-Host "This may take a moment."
try {
    # Execute the 7-Zip command and wait for it to finish
    $process = Start-Process -FilePath "7z.exe" -ArgumentList "x server.7z -y" -Wait -NoNewWindow -PassThru
    # Check the exit code to ensure it was successful
    if ($process.ExitCode -ne 0) {
        throw "7-Zip process exited with a non-zero code: $($process.ExitCode)"
    }
    Write-Host "Extraction complete."
}
catch {
    Write-ErrorAndExit "Failed to extract server.7z. The archive might be corrupt or 7-Zip encountered an error."
}

Write-Host "`nCleaning up temporary files..."
try {
    Remove-Item -Path "server.7z" -Force -ErrorAction Stop
    Write-Host "Cleanup complete."
}
catch {
    Write-Host "[WARNING] Could not delete server.7z. You may need to remove it manually." -ForegroundColor Yellow
}

Write-Host "`n----------------------------------------------------------------" -ForegroundColor Green
Write-Host "    FiveM server artifacts successfully installed! " -ForegroundColor Green
Write-Host "`n  Server Path: $InstallPath" -ForegroundColor Green
Write-Host "`n  Next Steps:" -ForegroundColor Green
Write-Host "  1. Create a 'server.cfg' file to configure your server." -ForegroundColor Green
Write-Host "  2. Get a license key from https://keymaster.fivem.net" -ForegroundColor Green
Write-Host "  3. Run the server using 'FXServer.exe'." -ForegroundColor Green
Write-Host "----------------------------------------------------------------`n" -ForegroundColor Green

Read-Host -Prompt "Press Enter to exit."