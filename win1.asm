;============================================================
; MELOTEST.ASM
; Programa simple para probar INT 61h (melodía de victoria)
;------------------------------------------------------------
; Uso:
;   1) tasm melodia.asm
;      tlink /t melodia.obj      ; genera MELODIA.COM (TSR)
;   2) tasm melotest.asm
;      tlink melotest
;   3) En DOSBox:
;         C:\>melodia      ; instala INT 61h
;         C:\>melotest     ; llama int 61h
;============================================================

.8086
.model small
.stack 100h

.data
msg_inicio db 0Dh,0Ah,"Probando INT 61h (melodia)...",0Dh,0Ah,'$'
msg_fin    db 0Dh,0Ah,"Fin de prueba. Presione una tecla para salir.",0Dh,0Ah,'$'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Mensaje inicial
    mov dx, offset msg_inicio
    mov ah, 09h
    int 21h

    ; Llamar a la interrupcion de la melodia
    int 61h              ; <-- acá debería sonar la melodía

    ; Mensaje final
    mov dx, offset msg_fin
    mov ah, 09h
    int 21h

    ; Esperar una tecla para ver si se colgó o no
    mov ah, 08h
    int 21h

    ; Salir a DOS
    mov ax, 4C00h
    int 21h
main endp

end main
