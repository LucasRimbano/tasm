.8086
.model small

.data
; (sin dependencias con DS, es todo BIOS)
dummy db 0
dummy2 db 0

.code
public cls_attr_10h
public cls_azul_10h
public setmodo_80x25

; setmodo_80x25: modo 03h (80x25, 16 colores)
; Preserva nada (rápida). Úsala si querés estandarizar el modo.

setmodo_80x25 proc
    mov ax, 0003h      ; AH=00h set video mode, AL=03h -> 80x25 color
    int 10h
    ret
setmodo_80x25 endp


; cls_attr_10h
; EN:  BL = atributo (BG<<4 | FG). Ej: 1Fh = fondo azul, texto blanco
; FX:  Limpia toda la pantalla con ese atributo y cursor a (0,0)
; RG:  Preserva AX,BX,CX,DX
; Usa: INT 10h / AH=06h (scroll up/clear window con atributo)

cls_attr_10h proc
    push ax
    push bx
    push cx
    push dx

    ; Limpiar toda la ventana con el atributo en BH
    mov ah, 06h        ; scroll up / clear window
    xor al, al         ; AL=0 -> limpiar toda la ventana
    mov bh, bl         ; BH = atributo pasado por el llamador
    xor cx, cx         ; CH=0 fila sup, CL=0 col izq
    mov dh, 24         ; fila inferior (0..24)
    mov dl, 79         ; columna inferior (0..79)
    int 10h

    ; Poner cursor en (0,0) página 0
    mov ah, 02h
    xor bh, bh
    xor dh, dh
    xor dl, dl
    int 10h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
cls_attr_10h endp


; cls_azul_10h: atajo fondo azul, texto blanco brillante (1Fh)
; RG: Preserva AX,BX,CX,DX

cls_azul_10h proc
    push bx
    mov bl, 1Fh        ; BG=1 (azul) <<4 | FG=0Fh (blanco brillante)
    call cls_attr_10h
    pop bx
    ret
cls_azul_10h endp

end
