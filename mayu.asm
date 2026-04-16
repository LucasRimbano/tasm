.8086
.model small
.stack 100h

.data
public texto_mayusculizado
extrn texto_a_ingresar:byte

texto_mayusculizado db 256 dup(0), '$'

.code
public mayusculizar_texto

mayusculizar_texto proc
    push ax
    push bx
    xor bx, bx

convertir:
    mov al, texto_a_ingresar[bx]
    cmp al, '$'
    je fin

  
    cmp al, 'a'
    jb copiar
    cmp al, 'z'
    ja copiar
    sub al, 20h  

copiar:
    mov texto_mayusculizado[bx], al
    inc bx
    jmp convertir

fin:
    mov texto_mayusculizado[bx], '$'
    pop bx
    pop ax
    ret
mayusculizar_texto endp

end
