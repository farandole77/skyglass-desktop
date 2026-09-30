@echo off
rem ===== Settings =====
rem URL : your Vercel address (leave empty to run the index.html next to this file)
set "URL="
rem POS : top-left corner of the monitor to show on, as X,Y
rem       sub monitor right of a 1920px main -> 1920,0   /  left of main -> -1920,0   /  main monitor -> 0,0
set "POS=0,0"
rem ====================
set "HERE=%~dp0"
if "%URL%"=="" set "URL=file:///%HERE:\=/%index.html"
rem A separate Edge profile keeps the window position and your to-do/schedule/alarm data in one place.
start "" msedge --app="%URL%" --window-position=%POS% --start-fullscreen --user-data-dir="%LOCALAPPDATA%\SkyGlassDeskEdge" --no-first-run
