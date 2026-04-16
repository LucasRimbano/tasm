.8086
.model small
.stack 100h

extrn texto_a_ingresar:byte

.code
public contar_vocales

contar_vocales proc
    push ax
    push si

    xor cx, cx
    mov si, offset texto_a_ingresar

siguiente:
    mov al, [si]
    cmp al, '$'
    je fin

    ; pasar a mayúscula si es minúscula
    cmp al, 'a'
    jb verificar
    cmp al, 'z'
    ja verificar
    sub al, 20h          

verificar:
    cmp al, 'A'
    je es_vocal
    cmp al, 'E'
    je es_vocal
    cmp al, 'I'
    je es_vocal
    cmp al, 'O'
    je es_vocal
    cmp al, 'U'
    je es_vocal
    jmp seguir

es_vocal:
    inc cx

seguir:
    inc si
    jmp siguiente

fin:
    pop si
    pop ax
    ret
contar_vocales endp

end
