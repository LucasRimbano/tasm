.8086
.model small
.stack 100h

.data
    extrn texto_a_ingresar:byte

.code

public contar_vocales


; contar_vocales
; Entrada : texto_a_ingresar con '$' al final
; Salida  : AL = cantidad de vocales encontradas

contar_vocales proc
    push bx
    push cx
    push si

    lea si, texto_a_ingresar
    xor cx, cx

siguiente:
    mov al, [si]
    cmp al, '$'
    je fin_vocales

    cmp al, 'a'
    je sumar
    cmp al, 'e'
    je sumar
    cmp al, 'i'
    je sumar
    cmp al, 'o'
    je sumar
    cmp al, 'u'
    je sumar
    cmp al, 'A'
    je sumar
    cmp al, 'E'
    je sumar
    cmp al, 'I'
    je sumar
    cmp al, 'O'
    je sumar
    cmp al, 'U'
    je sumar
    jmp continuar

sumar:
    inc cx
continuar:
    inc si
    jmp siguiente

fin_vocales:
    mov al, cl
    pop si
    pop cx
    pop bx
    ret
contar_vocales endp

end
