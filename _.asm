.8086
.model small
.stack 100h

.data
extrn texto_a_ingresar:byte

.code
public reemplazar_espacios

reemplazar_espacios proc
    push ax
    push bx

    xor bx, bx
loop_espacios:
    mov al, texto_a_ingresar[bx]
    cmp al, '$'
    je fin
    cmp al, ' '
    jne seguir
    mov texto_a_ingresar[bx], '_'
seguir:
    inc bx
    jmp loop_espacios

fin:
    pop bx
    pop ax
    ret
reemplazar_espacios endp

end
