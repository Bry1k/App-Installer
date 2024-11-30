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
:: Check to see if Chocolately path exists
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
echo                                                                              Press N to go to the next page
set choice=
set /p choice=Option: 
if "%choice%"=="1" goto 7z
if "%choice%"=="2" goto gpuz
if "%choice%"=="3" goto hwinfo
if "%choice%"=="4" goto obs
if "%choice%"=="5" goto nz
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
echo                                                                               Press E to exit 
set choice=
set /p choice=Option: 
if "%choice%"=="1" goto eg
if "%choice%"=="2" goto steam 
if "%choice%"=="3" goto uc 
if "%choice%"=="4" goto gog 
if "%choice%"=="E" (
    goto exit
) else if "%choice%"=="e" (
    goto exit
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

:exit
:: Pop up message once user finishes
echo msgbox "Thank you for using my script!" > %tmp%\tmp.vbs
wscript %tmp%\tmp.vbs
del %tmp%\tmp.vbs
exit