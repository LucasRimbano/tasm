;===========================================================
; LIBVOC - Contador de Vocales (versión compatible)
;-----------------------------------------------------------
; Entrada: texto_a_ingresar (terminado en '$')
; Salida:  CX ← cantidad de vocales detectadas (A,E,I,O,U)
;===========================================================

.8086
.model small
.stack 100h

extrn texto_a_ingresar:byte

.code
public contar_vocaless

contar_vocaless proc
    push ax
    push si

    xor cx, cx                     ; CX = contador = 0
    mov si, offset texto_a_ingresar

siguiente:
    mov al, [si]                   ; leer carácter
    cmp al, '$'                    ; fin del texto
    je fin

    cmp al, 0                      ; ignora nulos
    je avanzar
    cmp al, 0Dh                    ; ignora Enter
    je avanzar

    ; pasar a mayúscula si es minúscula
    cmp al, 'a'
    jb verificar
    cmp al, 'z'
    ja verificar
    sub al, 20h

verificar:
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
    jmp avanzar

sumar:
    inc cx

avanzar:
    inc si
    jmp siguiente

fin:
    pop si
    pop ax
    ret
contar_vocaless endp

end
