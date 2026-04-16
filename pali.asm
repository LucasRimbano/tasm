.8086
.model small
.stack 100h

extrn texto_a_ingresar:byte

.code
public verificar_palindromo

verificar_palindromo proc
    push bx
    push cx
    push dx
    push si
    push di

    mov dx, offset texto_a_ingresar
    mov si, dx
    mov di, dx


; buscar fin antes del '$'

buscar_fin:
    mov al, [di]
    cmp al, '$'
    je listo
    inc di
    jmp buscar_fin
listo:
    dec di                 ; di apunta al ultimo caracter


; calcular longitud (cx = fin - inicio + 1)

mov cx, di
sub cx, si
inc cx


compara:
    cmp si, di
    jge es_palindromo

    mov al, [si]
    mov bl, [di]

    ; saltar espacios y ENTER (izquierda)
    cmp al, ' '
    je skip_izq
    cmp al, 0Dh
    je skip_izq

    ; saltar espacios y ENTER (derecha)
    cmp bl, ' '
    je skip_der
    cmp bl, 0Dh
    je skip_der

    ; pasar a mayúsculas (izquierda)
    cmp al, 'a'
    jb listo_izq
    cmp al, 'z'
    ja listo_izq
    sub al, 20h
listo_izq:

    ; pasar a mayúsculas (derecha)
    cmp bl, 'a'
    jb listo_der
    cmp bl, 'z'
    ja listo_der
    sub bl, 20h
listo_der:

    ; comparar
    cmp al, bl
    jne no_es_palindromo

    inc si
    dec di
    jmp compara

skip_izq:
    inc si
    jmp compara
skip_der:
    dec di
    jmp compara

; Resultado

es_palindromo:
    mov al, 1
    jmp fin

no_es_palindromo:
    mov al, 0

fin:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    ret
verificar_palindromo endp

end
