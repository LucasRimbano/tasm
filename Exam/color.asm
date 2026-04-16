;===========================================================
; LIBCOLOR - Colores retro DOS (amarillo y gris)
;-----------------------------------------------------------
; cambiar_color_amarillo → limpia pantalla y pone fondo negro texto amarillo
; cambiar_color_gris     → limpia pantalla y pone fondo negro texto gris
;===========================================================

.8086
.model small
.stack 100h
.code

;-------------------------------------------
; Color amarillo brillante (0Eh)
;-------------------------------------------
public cambiar_color_amarillo
cambiar_color_amarillo proc
    push ax
    push bx
    push cx
    push dx

    ; AH=06h → Scroll up (limpia pantalla)
    mov ax, 0600h
    mov bh, 0Eh         ; atributo: fondo negro, texto amarillo brillante
    mov cx, 0000h       ; esquina superior izquierda (r0, c0)
    mov dx, 184Fh       ; esquina inferior derecha (r24, c79)
    int 10h

    ; Cursor arriba a la izquierda
    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
cambiar_color_amarillo endp

;-------------------------------------------
; Color gris claro (07h)
;-------------------------------------------
public cambiar_color_gris
cambiar_color_gris proc
    push ax
    push bx
    push cx
    push dx

    mov ax, 0600h
    mov bh, 07h         ; fondo negro, texto gris claro
    mov cx, 0000h
    mov dx, 184Fh
    int 10h

    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
cambiar_color_gris endp

end
