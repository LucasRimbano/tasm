;============================================================
; MOUSE_YTEST.ASM
; Muestra X e Y del mouse (en HEX) cada vez que haces clic.
; Sirve para calibrar en qué Y están las opciones A/B/C.
;------------------------------------------------------------
; Compilar:
;   tasm mouse_ytest
;   tlink /t mouse_ytest.obj
; Ejecutar:
;   mouse_ytest
;============================================================

.8086
.model tiny
.code
org 100h

start:
    ; modo texto 80x25 por las dudas
    mov ax, 0003h
    int 10h

    ; init mouse
    mov ax, 0
    int 33h
    cmp ax, 0
    je no_mouse

    ; mostrar cursor
    mov ax, 1
    int 33h

main_loop:
    ; esperar que apriete botón izq
esperar_presion:
    mov ax, 3
    int 33h        ; BX=botones, CX=X, DX=Y
    test bx, 1
    jz  esperar_presion

    ; esperar que suelte
esperar_suelta:
    mov ax, 3
    int 33h
    test bx, 1
    jnz esperar_suelta

    ; ahora CX = X, DX = Y
    ; limpiamos la línea y mostramos
    mov ah, 02h
    mov bh, 0
    mov dh, 0      ; fila 0
    mov dl, 0      ; columna 0
    int 10h

    mov dx, offset msgXY
    mov ah, 09h
    int 21h

    ; mostrar X
    mov ax, cx
    call print_hex

    mov dx, offset msgY
    mov ah, 09h
    int 21h

    ; mostrar Y
    mov ax, dx
    call print_hex

    jmp main_loop

no_mouse:
    mov dx, offset msgNoMouse
    mov ah, 09h
    int 21h
    mov ax, 4C00h
    int 21h

;----------------------------------------
; Rutina: print_hex
; EN: AX = valor a mostrar (16 bits)
;----------------------------------------
print_hex proc
    push ax
    push bx
    push cx
    push dx

    mov cx, 4          ; 4 dígitos hex
hex_loop:
    rol ax, 4          ; rota nibble alto al bajo
    mov bl, al
    and bl, 0Fh        ; BL = nibble
    cmp bl, 9
    jbe digito
    add bl, 7          ; A-F
digito:
    add bl, '0'
    mov dl, bl
    mov ah, 02h
    int 21h

    loop hex_loop

    ; espacio
    mov dl, ' '
    mov ah, 02h
    int 21h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_hex endp

;----------------------------------------
msgXY      db "Click en respuesta. X= ",0
msgY       db " Y= ",0Dh,0Ah,'$'
msgNoMouse db "No hay mouse instalado.$"

end start
