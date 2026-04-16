;===========================================================
; LIBRERÍA - lib.asm
;-----------------------------------------------------------
; Exporta:
;   texto_a_ingresar   (buffer del texto)
;   contar_vocales     (devuelve cantidad en AL)
;   modificar_a_asteriscos
;   limpiar_texto
;===========================================================

.8086
.model small
.stack 100h

.data
    public texto_a_ingresar
    texto_a_ingresar db 255 dup(0), '$'

.code

;===========================================================
; contar_vocales
;  Recorre texto_a_ingresar y devuelve en AL la cantidad
;  de vocales (mayúsculas y minúsculas).
;===========================================================
public contar_vocales
contar_vocales proc far
    push si
    push cx

    mov si, offset texto_a_ingresar
    xor cx, cx                  ; CX = contador

sig:
    mov al, [si]
    cmp al, '$'
    je listo                    ; fin de texto

    ; minúsculas
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

    ; mayúsculas
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

    jmp seguir

sumar:
    inc cx

seguir:
    inc si
    jmp sig

listo:
    mov al, cl                  ; resultado en AL

    pop cx
    pop si
    ret
contar_vocales endp


;===========================================================
; modificar_a_asteriscos
;  Reemplaza cada carácter del texto por '*'
;  hasta encontrar '$'.
;===========================================================
public modificar_a_asteriscos
modificar_a_asteriscos proc far
    push si

    mov si, offset texto_a_ingresar

conv:
    mov al, [si]
    cmp al, '$'
    je fin_conv

    mov byte ptr [si], '*'
    inc si
    jmp conv

fin_conv:
    pop si
    ret
modificar_a_asteriscos endp


;===========================================================
; limpiar_texto
;  Borra todo el buffer y lo deja así:
;      texto_a_ingresar = '$' + ceros
;===========================================================
public limpiar_texto
limpiar_texto proc far
    push si
    push cx

    mov si, offset texto_a_ingresar
    mov cx, 255

llenar:
    mov byte ptr [si], 0
    inc si
    loop llenar

    ; dejamos el primer byte como '$' (fin de cadena vacía)
    mov byte ptr texto_a_ingresar, '$'

    pop cx
    pop si
    ret
limpiar_texto endp

end
