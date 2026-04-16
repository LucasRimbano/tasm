;=========================================================
; LIBRERÍA: util.asm
; Convierte el valor numérico en AL a ASCII.
;=========================================================

.8086
.model small
.stack 100h

.data
    extrn nroAscii:byte    ; declarada en main.asm

.code

public reg2ascii

;---------------------------------------------------------
; reg2ascii
; Entrada : AL = valor (0–9)
; Salida  : nroAscii = cadena con ese dígito en ASCII
;---------------------------------------------------------
reg2ascii proc
    push ax
    mov ah, 0
    add al, 30h
    mov nroAscii, al
    mov nroAscii+1, '$'
    pop ax
    ret
reg2ascii endp

end
