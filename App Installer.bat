@echo off
mode 140, 35
setlocal EnableDelayedExpansion

:: BatchGotAdmin
::-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    pause /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
::--------------------------------------


cls

:: Testing for connection in order to install Chocolately if needed.
ping -n 2 www.google.com
if errorlevel 1 goto fail
if not errorlevel 1 goto success

:fail
cls
echo No Internet Connection. Please make sure you are connected to the internet.
timeout /t 3 >nul
exit

:success
cls
echo Internet connected
timeout /t 3 >nul
goto :choco

:: Check to see if Chocolately path exists
:choco
cls
set chocoPath=%ProgramData%\chocolatey\choco.exe

if exist "%chocoPath%" (
    echo Chocolatey exists
    goto browsers
) else (
    echo Chocolatey isn't installed.
    echo Running install script
    Powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "Invoke-WebRequest -Uri 'https://community.chocolatey.org/install.ps1' -OutFile 'install.ps1'; .\install.ps1"
    goto browsers
)


:browsers
:: Disable confirmation message when installing apps through Chocolately
choco feature enable -n=allowGlobalConfirmation >nul 2>&1
cls
title App Installer
echo.
echo.
echo.
echo.
echo.
echo                                                             Browsers
echo.
echo.
echo                             1. Google Chrome                                            2. Brave                 
echo                             3. Firefox                                                  4. Vivaldi
echo.
echo.
echo                                                                          Press N to go to next page
set choice=
set /p choice=Option: 
if "%choice%"=="1" goto chrome
if "%choice%"=="2" goto brave
if "%choice%"=="3" goto firef
if "%choice%"=="4" goto viv
if "%choice%"=="N" (
    goto app
) else if "%choice%"=="n" (
    goto app
)

echo Invalid Option. Please select a valid option.
goto browsers


:chrome
choco install googlechrome
goto app


:brave
choco install brave
goto app

:firef
choco install firefox 
goto app

:viv
choco install Vivaldi
goto app




:app
cls
echo.
echo.
echo.
echo                                                         Apps
echo.
echo.
echo.
echo                             1. Discord                                          2. Spotify
echo.
echo                                                      3. iTunes 
echo.
echo                                                                               Press N to go next page                                          

set choice=
set /p choice=Option: 
if "%choice%"=="1" goto disc 
if "%choice%"=="2" goto spot 
if "%choice%"=="3" goto itun 
if "%choice%"=="N" (
    goto util
) else if "%choice%"=="n" (
    goto util
)
echo Invalid Option. Please select a valid option.
goto app


:disc
choco install discord 
goto app


:spot
choco install spotify 
goto app


:itun
choco install itunes
goto app



:util
cls
echo.
echo.
echo.
echo                                                          Utilities
echo.
echo.
echo                                     1.  7zip                                   2. GPU-Z
echo.
echo                                                         3. HWINFO
echo.
echo                                     4. OBS Studio                              5. NanaZip
echo.
echo.                                    
echo                                                      6. Notepad++
echo                                                                               Press N to go to the next page                                   8. 
set choice=
set /p choice=Option: 
if "%choice%"=="1" goto 7z
if "%choice%"=="2" goto gpuz
if "%choice%"=="3" goto hwinfo
if "%choice%"=="4" goto obs
if "%choice%"=="5" goto nz
if "%choice%"=="6" goto n++
if "%choice%"=="N" (
    goto game
) else if "%choice%"=="n" (
    goto game
)
echo Invalid Option. Please select a valid option.
goto util


:7z
choco install 7zip
goto util


:gpuz
choco install gpu-z
goto util


:hwinfo
choco install hwinfo
goto util


:obs
choco install obs-studio
goto util


:nz
choco install nanazip 
goto util


:game
cls
echo.
echo.
echo.
echo.
echo                                                       Game Launchers
echo.
echo.
echo                                 1. Epic Games                                 2. Steam
echo.
echo.                                                   
echo. 
echo.
echo                                 3. Ubisoft Connect                            4. GOG Galaxy                                 
echo.
echo                                                                               Press N to go to next page 
set choice=
set /p choice=Option: 
if "%choice%"=="1" goto eg
if "%choice%"=="2" goto steam 
if "%choice%"=="3" goto uc 
if "%choice%"=="4" goto gog 
if "%choice%"=="N" (
    goto dev
) else if "%choice%"=="n"(
    goto dev
)

echo Invalid Option. Please select a valid option.
goto game

:eg
choco install epicgameslauncher
goto game

:steam
choco install steam-client
goto game

:uc
choco install ubisoft-connect
goto game

:gog
choco install goggalaxy
goto game


:dev
cls
echo.
echo.
echo.
echo.
echo                                                       Development
echo.
echo.
echo                                 1. Python                                 2. Git
echo.
echo                                 3. Rust                                   4. Golang
echo.
echo                                 5. Visual Studio Code                     6. VSCodium
echo.
echo                                                                         Press E to exit
set choice=
set /p choice=Option: 
if "%choice%"=="1" goto py
if "%choice%"=="2" goto git
if "%choice%"=="3" goto rs
if "%choice%"=="4" goto gl
if "%choice%"=="5" goto vsc
if "%choice%"=="6" goto vscd 
if "%choice%"=="E" goto (
    goto exit
) else if "%choice%"=="e" (
    goto exit
)
echo Invalid Option. Please select a valid option.
goto dev

:py
choco install python311
goto dev

:git
choco install git.install
goto dev

:rs
choco install rust
goto dev

:gl 
choco install golang
goto dev

:vsc
choco install vscode
goto dev

:vscd
choco install vscodium
goto dev



:exit
:: Pop up message once user finishes
echo msgbox "Thank you for using my script!" > %tmp%\tmp.vbs
wscript %tmp%\tmp.vbs
del %tmp%\tmp.vbs
exit
