@echo off
cls
echo
echo 
echo 
echo.

REM 
tasm /zi txtt.asm
tasm /zi lett.asm
tasm /zi voca.asm
tasm /zi impp.asm
tasm /zi R22a.asm

REM 
tasm /zi main.asm

REM
tlink /v main.obj txtt.obj lett.obj voca.obj impp.obj R22a.obj

echo.
echo 
echo 
echo
echo 
pause
