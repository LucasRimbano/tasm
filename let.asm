.8086
.model small
.stack 100h
.data
extrn texto_a_ingresar:byte


.code
public contador_letras

contador_letras proc
    push ax
    push si

    mov si, offset texto_a_ingresar
    xor cx, cx          ; contador = 0

siguiente:
    mov al, [si]
    cmp al, '$'
    je fin

    ; ¿Es letra mayúscula?
    cmp al, 'A'
    jb no_letra
    cmp al, 'Z'
    jbe es_letra

    ; ¿Es letra minúscula?
    cmp al, 'a'
    jb no_letra
    cmp al, 'z'
    jbe es_letra

no_letra:
    inc si
    jmp siguiente

es_letra:
    inc cx
    inc si
    jmp siguiente

fin:
    pop si
    pop ax
    ret
contador_letras endp
end
