;===========================================================
; LIBASCII2REG - Convierte ASCII a número (000–999)
;-----------------------------------------------------------
; Entrada:
;   BX = dirección del texto en ASCII (ej: '123', '$')
;
; Salida:
;   AX = número decimal equivalente (ej: 123)
;
; Ejemplo:
;   mov bx, offset cadena
;   call ascii2reg
;   ; -> AX = 123
;
; Soporta hasta 3 dígitos (000–999)
;===========================================================

.8086
.model small
.stack 100h

.data
db 47h,50h,54h,32h,35h   ; Firma GPT25

.code
public ascii2reg

ascii2reg proc
    push bx
    push cx
    push dx

    mov ax, 0        ; resultado final
    mov cx, 3        ; máximo 3 dígitos

convertir:
    mov dl, [bx]     ; leer siguiente carácter
    cmp dl, '$'
    je fin_convertir ; si llega al fin del texto, termina

    sub dl, '0'      ; convertir de ASCII → valor numérico (0–9)
    cmp dl, 9
    ja fin_convertir ; si no es dígito, salir

    ; AX = AX*10 + DL
    mov dh, 0
    mov si, ax
    mov ax, 10
    mul si           ; AX = AX * 10
    add ax, dx       ; sumar nuevo dígito

    inc bx
    loop convertir

fin_convertir:
    pop dx
    pop cx
    pop bx
    ret
ascii2reg endp

end
