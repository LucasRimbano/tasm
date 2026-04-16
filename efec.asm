;============================================================
; EFECTO_CORTINA_OK.COM
; Interrupción INT 60h → Cortina vertical suave + beep final
;------------------------------------------------------------
; Uso:
;   Ejecutar antes del juego:  efecto_cortina_ok
;   Luego, desde tu juego:
;       call imagenGana
;       int 60h
;============================================================

.8086
.model tiny
.code
org 100h

start:
    cli
    mov ax, cs
    mov ds, ax
    mov es, ax

    ; Guardar vector original INT 60h
    mov ax, 3560h
    int 21h
    mov word ptr old_off, bx
    mov word ptr old_seg, es

    ; Instalar nuestra INT 60h
    mov dx, offset cortina_int
    mov ax, 2560h
    int 21h
    sti

    ; Mensaje de instalación
    mov dx, offset msg_ok
    mov ah, 09h
    int 21h

    ; Dejar residente
    mov dx, offset fin
    sub dx, 100h
    mov ah, 31h
    int 21h

;------------------------------------------------------------
; NUEVA INTERRUPCIÓN INT 60h
;------------------------------------------------------------
cortina_int:
    push ax
    push bx
    push cx
    push dx
    push es
    push di

    mov ax, 0A000h
    mov es, ax
    xor bx, bx            ; inicio buffer (fila 0)
    mov cx, 200           ; 200 filas

fila_loop:
    mov di, bx
    mov al, 0             ; color negro
    mov dx, 320           ; 320 píxeles por fila

rellenar_fila:
    mov es:[di], al
    inc di
    dec dx
    jnz rellenar_fila

    ; retardo más corto → ~suave y no bloqueante
    mov dx, 1500
delay:
    dec dx
    jnz delay

    add bx, 320
    loop fila_loop

    ; pequeño beep con el speaker
    mov ah, 02h
    mov dl, 07h
    int 21h

    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    iret

;------------------------------------------------------------
msg_ok db 0Dh,0Ah,'INT 60h (efecto cortina suave) instalada!$'
old_off dw ?
old_seg dw ?
fin:
end start
