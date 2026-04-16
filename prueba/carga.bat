@echo off
cls
echo ============================================
echo      COMPILANDO TP FINAL SPD (Rick) 🧠
echo ============================================
echo.

tasm /zi tp4.asm
tasm /zi imp.asm
tasm /zi carga.asm
tasm /zi opc.asm
tasm /zi error.asm
tasm /zi mus.asm
tasm /zi color.asm
tasm /zi alu3.asm
tasm /zi mem3.asm
tasm /zi int3.asm
tasm /zi trol3.asm
tasm /zi ea3.asm
tasm /zi r22a.asm
tasm /zi intro.asm
tasm /zi punt2.asm
tasm /zi limpiar.asm
tasm /zi bmp2.asm
tasm /zi conta.asm
tasm /zi tiempo.asm

echo.
echo ---- ENLAZANDO ----
tlink /v tp4.obj imp.obj carga.obj opc.obj error.obj mus.obj color.obj alu3.obj mem3.obj int3.obj trol3.obj ea3.obj r22a.obj intro.obj punt2.obj limpiar.obj bmp2.obj conta.obj tiempo.obj

echo.
if exist tp4.exe goto ok
goto error

:ok
echo ✅ Compilacion y enlace completados correctamente.
echo Ejecuta TP4.EXE para iniciar el juego.
goto fin

:error
echo ❌ Error: No se pudo generar TP4.EXE.
echo Verifica si alguno de los .ASM tiene errores (por ejemplo INTRO.ASM).
goto fin

:fin
pause
