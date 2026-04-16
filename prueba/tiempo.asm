;============================================================
; LIBRERÍA: timeout.asm
;------------------------------------------------------------
; Exporta: leer_abc_timeout
; - Lee solo A/B/C con timeout de 10 s (~182 ticks BIOS)
; - Devuelve:
;       AL = 'A'/'B'/'C' → válida
;       AL = 0 → tiempo agotado
;       AL = 0FFh → tecla inválida
;============================================================

.8086
.model small
.stack 100h
.code

public leer_abc_timeout
leer_abc_timeout proc
    push bx
    push cx
    push dx

    ; obtener tick inicial
    mov ah,00h
    int 1Ah
    mov bx,dx

bucle:
    mov ah,01h
    int 16h
    jz revisar_tiempo

    mov ah,00h
    int 16h

    ; convertir minúsculas a mayúsculas
    cmp al,'a'
    jb validar
    cmp al,'z'
    ja validar
    and al,11011111b

validar:
    cmp al,'A'
    je listo
    cmp al,'B'
    je listo
    cmp al,'C'
    je listo

    mov al,0FFh        ; inválida
    jmp salir

revisar_tiempo:
    mov ah,00h
    int 1Ah
    mov cx,dx
    sub cx,bx
    cmp cx,182
    jb bucle

    mov al,0            ; timeout
    jmp salir

listo:
salir:
    pop dx
    pop cx
    pop bx
    ret
leer_abc_timeout endp

end
