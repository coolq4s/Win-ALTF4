@echo off

PUSHD %~DP0 & cd /d "%~dp0"
%1 %2
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :runas","","runas",1)(window.close)&goto :eof 
:runas

rmdir /s /q "%TEMP%/WinGet"


REM Internet connectivity check
ping -n 1 8.8.8.8 >nul 2>&1
if errorlevel 1 (
    color 4F
    echo Internet not connected. 
    echo Please check your connection and try again.
    echo Exiting in 5 seconds...
    timeout /t 5 /nobreak >nul
    color 07
    goto exit
)

:menu
cls
echo =====================================
echo              Main Menu
echo =====================================
echo 1. Install Software
echo 2. Activate Windows
echo 3. Set Timezone to GMT+7 (ID)
echo 0. Exit
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto submenu
if "%choice%"=="2" goto activate_windows
if "%choice%"=="3" goto set_timezone
if "%choice%"=="0" exit
goto menu

:submenu
cls
echo =====================================
echo           Install Software
echo =====================================
echo 1. Chrome
echo 2. Visual C++ Redistributable
echo 3. DirectX Web Installer (Manual)
echo 4. Code Editor
echo 5. Install Whatsapp
echo 0. Back
echo.
set /p subchoice=Select an option: 

if "%subchoice%"=="1" goto install_chrome
if "%subchoice%"=="2" goto install_vcredist
if "%subchoice%"=="3" goto install_directx
if "%subchoice%"=="4" goto code_editor
if "%subchoice%"=="5" goto install_whatsapp
if "%subchoice%"=="0" goto menu
goto submenu

:install_chrome
cls
echo Downloading Google Chrome...
winget install Google.Chrome --silent --accept-source-agreements --accept-package-agreements
cls
echo Chrome installation completed.
rmdir /s /q "%TEMP%/WinGet"
pause
goto submenu

:install_vcredist
cls
echo Downloading Microsoft Visual C++ Redistributable...

set "vcurl=https://aka.ms/vs/17/release/vc_redist.x64.exe"
set "vcfile=%TEMP%\vc_redist.x64.exe"

powershell -Command "Invoke-WebRequest -Uri '%vcurl%' -OutFile '%vcfile%'"

echo Installing silently...
start /wait "" "%vcfile%" /quiet /norestart

echo Installation complete. Cleaning up...
del /f /q "%vcfile%"
pause
goto submenu

:install_directx
cls
echo Downloading DirectX Web Installer...

set "dxurl=https://download.microsoft.com/download/1/7/1/1718ccc4-6315-4d8e-9543-8e28a4e18c4c/dxwebsetup.exe"
set "dxfile=%TEMP%\dxwebsetup.exe"

powershell -Command "Invoke-WebRequest -Uri '%dxurl%' -OutFile '%dxfile%'"

echo Installing DirectX Web Installer...
start /wait "" "%dxfile%"

echo Installation complete. Cleaning up...
del /f /q "%dxfile%"
pause
goto submenu

:activate_windows
cls
echo Running Windows activation script...
powershell -Command "irm https://get.activated.win | iex"
echo Activation script executed.
pause
goto menu

:set_timezone
cls
echo Setting timezone to SE Asia Standard Time (GMT+7)...
tzutil /s "SE Asia Standard Time"
echo Timezone set to GMT+7 (Bangkok, Hanoi, Jakarta).
echo Syncing time with internet time server...
net start w32time
w32tm /resync > nul
echo Time synchronized.
net stop w32time > nul
pause
goto menu

:code_editor
cls
echo =====================================
echo             Code Editor
echo =====================================
echo 1. Install VSCode
echo 2. Install Notepad++
echo 0. Back
echo.
set /p codechoice=Select an option: 

if "%codechoice%"=="1" goto install_vscode
if "%codechoice%"=="2" goto install_notepadpp
if "%codechoice%"=="0" goto submenu
goto code_editor

:install_vscode
cls
echo Downloading Visual Studio Code...
winget install Microsoft.VisualStudioCode --silent --accept-source-agreements --accept-package-agreements
echo Installation complete. Cleaning up...
rmdir /s /q "%TEMP%/WinGet"
pause
goto code_editor

:install_notepadpp
cls
echo Downloading Notepad++...
set "npp_url=https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.8.2/npp.8.8.2.Installer.exe"
set "npp_file=%TEMP%\npp_installer.exe"
powershell -Command "Invoke-WebRequest -Uri '%npp_url%' -OutFile '%npp_file%'"
echo Installing Notepad++ silently...
start /wait "" "%npp_file%" /S
echo Installation complete. Cleaning up...
del /f /q "%npp_file%"
pause
goto code_editor

:install_whatsapp
cls
echo Downloading Whatsapp installer...
set "wa_url=https://get.microsoft.com/installer/download/9NKSQGP7F2NH?cid=website_cta_psi"
set "wa_file=%TEMP%\WhatsappSetup.exe"
powershell -Command "Invoke-WebRequest -Uri '%wa_url%' -OutFile '%wa_file%'"
echo Installing Whatsapp...
start /wait "" "%wa_file%"
timeout /t 10 /nobreak >nul
echo Installation complete. Cleaning up...
del /f /q "%wa_file%"
pause
goto submenu

:exit

rmdir /s /q "%TEMP%/WinGet"
exit
