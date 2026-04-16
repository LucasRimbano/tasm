;===========================================================
; SONIDO60H.COM
;-----------------------------------------------------------
; Instala una interrupción INT 60h residente.
; Al invocarla:
;   - Muestra "🎮 SONIDO ACTIVADO 🎮" en color amarillo
;   - Reproduce una melodía tipo presentación
;-----------------------------------------------------------
; Autor: Lucas Rimbano (TP Final)
;===========================================================

.8086
.model tiny
org 100h

start:
    cli
    mov ax, cs
    mov ds, ax
    mov es, ax

    ;--------------------------------------
    ; Guardar vector original INT 60h
    ;--------------------------------------
    mov ax, 3560h
    int 21h
    mov word ptr old_offset, bx
    mov word ptr old_segment, es

    ;--------------------------------------
    ; Instalar nuestra INT 60h personalizada
    ;--------------------------------------
    mov dx, offset nueva_int
    mov ax, 2560h
    int 21h
    sti

    ;--------------------------------------
    ; Mensaje de instalación
    ;--------------------------------------
    mov ah, 09h
    mov dx, offset msg_instalada
    int 21h

    ;--------------------------------------
    ; Dejar residente (TSR)
    ;--------------------------------------
    mov dx, offset fin
    sub dx, 100h
    mov ah, 31h
    int 21h


;-----------------------------------------------------------
; NUEVA RUTINA → Se ejecuta cuando se llama INT 60h
;-----------------------------------------------------------
nueva_int:
    push ax
    push bx
    push cx
    push dx

    ; Mostrar mensaje con color amarillo
    mov ah, 09h
    mov bh, 0
    mov bl, 0Eh          ; atributo color amarillo
    mov cx, len_msg
    mov bp, offset msg_activo
    mov ah, 13h
    mov al, 1
    mov bh, 0
    mov bl, 0Eh
    mov dh, 12           ; fila
    mov dl, 20           ; columna
    int 10h

    ; Reproducir mini melodía DO-MI-SOL-DO
    mov ax, 1912
    call tono
    mov ax, 1516
    call tono
    mov ax, 1275
    call tono
    mov ax, 956
    call tono

    ; Limpiar pantalla del mensaje (gris oscuro)
    mov ah, 06h
    mov al, 0
    mov bh, 07h
    mov cx, 0
    mov dx, 184Fh
    int 10h

    pop dx
    pop cx
    pop bx
    pop ax
    iret


;-----------------------------------------------------------
; SUBRUTINA: tono
; Entrada: AX = divisor de frecuencia
;-----------------------------------------------------------
tono:
    push ax
    push bx
    push cx
    push dx

    mov bx, ax
    mov al, 0B6h
    out 43h, al
    mov ax, bx
    out 42h, al
    mov al, ah
    out 42h, al

    in al, 61h
    or al, 00000011b
    out 61h, al

    mov cx, 25000
espera:
    loop espera

    in al, 61h
    and al, 11111100b
    out 61h, al

    pop dx
    pop cx
    pop bx
    pop ax
    ret

;-----------------------------------------------------------
; DATOS
;-----------------------------------------------------------
msg_instalada db 0Dh,0Ah,"INT 60h instalada. Llama a INT 60h desde tu juego para escuchar sonido!",0Dh,0Ah,'$'
msg_activo db "🎮 SONIDO ACTIVADO 🎮$"
len_msg equ ($ - msg_activo)
old_offset dw 0
old_segment dw 0
fin:

end start
