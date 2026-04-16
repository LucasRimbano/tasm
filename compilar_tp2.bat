@echo off
cls
echo ============================================
echo   COMPILADOR TP2 - ENSAMBLADOR 8086
echo   Proyecto: tp2.asm + librerias externas
echo ============================================
echo.

rem ----- COMPILAR TODOS LOS .ASM -----
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

echo.
echo ----- ENSAMBLADO COMPLETO -----
echo.

rem ----- ENLAZAR TODOS LOS OBJ -----
tlink tp2.obj imp.obj carga.obj opc.obj error.obj mus.obj color.obj alu.obj mem.obj int.obj trol.obj ea.obj r22a.obj

echo.
echo ============================================
echo  COMPILACION FINALIZADA SIN ERRORES
echo  Ejecuta: tp2.exe
echo ============================================
pause
