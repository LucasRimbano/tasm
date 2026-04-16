.8086
.model small
.stack 100h
.code


; Cambiar a amarillo brillante (atributo 0Eh)

public cambiar_color_amarillo
cambiar_color_amarillo proc
    push ax
    push bx

    mov ah, 0Bh      ; INT 10h - Set Palette / Border Color
    mov bh, 0        ; página activa
    mov bl, 0Eh      ; 0Eh = amarillo brillante
    int 10h

    pop bx
    pop ax
    ret
cambiar_color_amarillo endp


; Cambiar a gris claro (atributo 07h)

public cambiar_color_gris
cambiar_color_gris proc
    push ax
    push bx

    mov ah, 0Bh
    mov bh, 0
    mov bl, 07h      ; 07h = gris claro sobre negro
    int 10h

    pop bx
    pop ax
    ret
cambiar_color_gris endp

end
