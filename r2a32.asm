;===========================================================
; LIBRERÍA: reg2ascii_div.asm (versión definitiva)
;-----------------------------------------------------------
; Convierte el número en AX (0–9999) a ASCII
; usando tabla de divisores: 1000,100,10,1
;
; Entrada:
;   AX = número (0–9999)
;   BX = dirección destino del texto
; Salida:
;   [BX] = texto ASCII terminado en '$'
;===========================================================

.8086
.model small
.data
divisores dw 1000,100,10,1

.code
public reg2ascii_div

reg2ascii_div proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov di, bx          ; destino → DI
    mov si, offset divisores
    mov cx, 4           ; 4 divisores
    mov bx, ax          ; BX = número original
    mov dx, 0

    mov ah, 0
    mov al, 0
    mov bl, 0           ; reiniciar flags de ceros
    mov ax, bx          ; número en AX

siguiente:
    mov dx, 0
    mov bx, [si]        ; cargar divisor (1000,100,10,1)
    div bx              ; AX / divisor → AL=cociente, DX=resto
    mov bx, dx          ; BX ← resto para la próxima iteración
    add al, '0'
    cmp al, '0'
    jne imprimir        ; si no es cero, imprime
    cmp cx, 1
    je imprimir         ; el último dígito se imprime siempre
    cmp bl, 0
    je saltar           ; aún no vimos un número distinto de cero

imprimir:
    mov [di], al
    inc di
    mov bl, 1           ; bandera → ya imprimimos algo
saltar:
    mov ax, bx          ; resto → AX
    add si, 2           ; siguiente divisor
    loop siguiente

    mov byte ptr [di], '$'

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
reg2ascii_div endp

end
