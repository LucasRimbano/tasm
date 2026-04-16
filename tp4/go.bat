@echo off
cls
echo ============================================
echo    COMPILANDO TP4 - Juego SPD (Rick) 🧠
echo ============================================

echo.
echo 1) Compilando modulos del EXE...
tasm /m2 tp4.asm
tasm /m2 imp.asm
tasm /m2 carga.asm
tasm /m2 opc.asm
tasm /m2 error.asm
tasm /m2 mus.asm
tasm /m2 color.asm
tasm /m2 alu3.asm
tasm /m2 mem3.asm
tasm /m2 int3.asm
tasm /m2 trol3.asm
tasm /m2 ea3.asm
tasm /m2 r22a.asm
tasm /m2 punt2.asm
tasm /m2 limpiar.asm
tasm /m2 bmp2.asm
tasm /m2 mouse.asm
tasm /m2 conta.asm
tasm /m2 tiempo.asm

echo.
echo 2) Creando archivo de respuesta para TLINK...
rem 
echo tp4+imp+carga+opc+error+mus+color+alu3+mem3+int3+trol3+ea3+r22a+punt2+limpiar+bmp2+mouse+conta+tiempo,tp4>tp4.rsp

echo.
echo 3) Enlazando TP4.EXE...
tlink /v @tp4.rsp

if not exist tp4.exe goto error

del tp4.rsp

echo.
echo 4) Compilando INTRO.COM...
tasm /m2 intro.asm
tlink /t intro.obj

echo.
echo 5) Compilando WIN.COM...
tasm /m2 win.asm
tlink /t win.obj

echo.
echo ============================================
echo   TODO OK: TP4.EXE, INTRO.COM y WIN.COM
echo ============================================
dir tp4.exe intro.com win.com
goto fin

:error
echo.
echo *** HUBO UN ERROR: NO SE GENERO TP4.EXE ***
echo     Revisar los mensajes de TASM/TLINK.
echo.
:fin
pause
