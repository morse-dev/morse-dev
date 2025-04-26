@echo off
setlocal enabledelayedexpansion

:: ========== Default Theme ==========
:: Classic: Black background, white text
set "defaultColor=07"
color %defaultColor%
title CVIM

:: Save starting folder so we can go back
set "ROOT_DIR=%cd%"

:menu
cls
echo.
echo ==============================
echo       NEWVIM CLI Workspace    
echo ==============================
echo Current Directory: %cd%
echo.

:: List files and folders
dir /b

echo.
echo [N] New File   [E] Edit File   [D] Delete Content
echo [F] New Folder [O] Open Folder [B] Back
echo [P] Ping Server [L] Lookup Website IP [S] Settings   [Q] Quit
echo.
set /p choice=Choose an option: 

if /i "!choice!"=="N" goto newfile
if /i "!choice!"=="E" goto editfile
if /i "!choice!"=="D" goto deletecontent
if /i "!choice!"=="F" goto newfolder
if /i "!choice!"=="O" goto openfolder
if /i "!choice!"=="B" goto goback
if /i "!choice!"=="P" goto pingserver
if /i "!choice!"=="L" goto lookupip
if /i "!choice!"=="S" goto settings
if /i "!choice!"=="Q" exit
goto menu

:newfile
set /p fname=Enter new filename (e.g. index.html): 
if exist "!fname!" (
    echo File already exists!
) else (
    echo Press Ctrl+Z then Enter to save. Start typing...
    copy con "!fname!"
)
pause
goto menu

:editfile
set /p fname=Enter file to edit: 
if not exist "!fname!" (
    echo File does not exist!
    pause
    goto menu
)
echo.
echo Editing !fname!
echo --------------------------
echo Current content:
type "!fname!"
echo --------------------------
echo Type new content below.
echo (Press Ctrl+Z then Enter to save)
copy con "!fname!"
pause
goto menu

:deletecontent
set /p fname=Enter file to clear content: 
if not exist "!fname!" (
    echo File does not exist!
    pause
    goto menu
)
break > "!fname!"
echo File content cleared.
pause
goto menu

:newfolder
set /p foldername=Enter new folder name: 
md "!foldername!"
echo Folder "!foldername!" created.
pause
goto menu

:openfolder
set /p folder=Enter folder path or name to open: 
if exist "!folder!\" (
    pushd "!folder!"
) else (
    echo Folder not found!
    pause
)
goto menu

:goback
popd
goto menu

:pingserver
cls
set /p target=Enter server IP or address to ping: 
echo.
echo Pinging !target! ...
ping !target! -n 6
pause
goto menu

:lookupip
cls
set /p domain=Enter website domain (e.g. example.com): 
echo.
echo Looking up IP address for !domain! ...
set "ip="
for /f "tokens=2 delims=:" %%A in ('nslookup !domain! ^| findstr /R /C:"Address: " ^| findstr /V "127.0.0.1"') do (
    set ip=%%A
)
if defined ip (
    echo IP Address: !ip!
    set /p copyChoice=Do you want to copy this IP to your clipboard? [Y] Yes / [N] No: 
    if /i "!copyChoice!"=="Y" (
        echo !ip! | clip
        echo IP address copied to clipboard!
    ) else (
        echo IP address not copied to clipboard.
    )
) else (
    echo IP address not found or lookup failed.
)
pause
goto menu

:settings
cls
echo.
echo ============ SETTINGS ============
echo.
echo Choose a color theme:
echo [1] Classic      (Black + White)
echo [2] Matrix       (Black + Green)
echo [3] Cyber Blue   (Blue + Green)
echo [4] Hacker Aqua  (Black + Aqua)
echo [5] Solar Yellow (Blue + Yellow)
echo.
set /p theme=Select a number: 

if "!theme!"=="1" set "defaultColor=07"
if "!theme!"=="2" set "defaultColor=0A"
if "!theme!"=="3" set "defaultColor=1A"
if "!theme!"=="4" set "defaultColor=0B"
if "!theme!"=="5" set "defaultColor=1E"

color !defaultColor!
goto menu
