@echo off
cls
echo ============================================
echo      COMPILANDO TP FINAL SPD (Rick) 🧠
echo ============================================

rem ----- COMPILACION DE TODOS LOS MODULOS -----
echo.
echo  Compilando archivos ASM...
tasm tp2.asm
tasm imp.asm
tasm carga.asm
tasm opc.asm
tasm error.asm
tasm mus.asm
tasm color.asm
tasm alu.asm
tasm mem.asm
tasm int.asm
tasm trol.asm
tasm ea.asm
tasm r22a.asm
tasm intro.asm

echo.
echo 
echo   ENLAZANDO ARCHIVOS OBJ...
echo 

tlink /v tp2.obj imp.obj carga.obj opc.obj error.obj mus.obj color.obj alu.obj mem.obj int.obj trol.obj ea.obj r22a.obj intro.obj

echo.
if exist tp2.exe goto ok
goto error

:ok
echo 
echo   COMPILACION EXITOSA - EJECUTANDO TP2...
echo 
echo.
tp2.exe
goto fin

:error
echo 
echo    ERROR: NO SE GENERO TP2.EXE
echo   Revisa posibles errores de TASM o TLINK
echo 
goto fin

:fin
echo.
pause
