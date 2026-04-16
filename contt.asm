.8086
.model small
.stack 100h

.data
    extrn texto_a_ingresar:byte    

.code

public contar_vocales

;---------------------------------------------------------
; contar_vocales
; Entrada : DS: apunta a segmento de datos
;           texto_a_ingresar contiene el texto terminado en '$'
; Salida  : AL = cantidad total de vocales encontradas
;---------------------------------------------------------
contar_vocales proc
    push bx
    push cx
    push si

    mov si, offset texto_a_ingresar   ; inicio del texto
    xor cx, cx                        ; contador de vocales = 0

siguiente:
    mov al, [si]
    cmp al, '$'                       ; fin del texto
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
    mov al, cl          ; pasa el conteo a AL
    pop si
    pop cx
    pop bx
    ret
contar_vocales endp

end
