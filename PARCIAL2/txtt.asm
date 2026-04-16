;=========================================================
; LIBRERÍA: txt.asm
; Descripción:
;   Carga un texto libre desde teclado hasta ENTER.
;=========================================================

.8086
.model small
.stack 100h

.data
    extrn texto_a_ingresar:byte

.code

public cargar_texto

;---------------------------------------------------------
; cargar_texto
; Entrada : DS apunta al segmento de datos
; Acción  : Carga texto libre (hasta ENTER, 0Dh)
; Salida  : Guarda en texto_a_ingresar y finaliza con '$'
;---------------------------------------------------------
cargar_texto proc
    push ax
    push bx
    xor bx, bx
    lea si, texto_a_ingresar        ; puntero base válido

leer_caracter:
    mov ah, 01h
    int 21h
    cmp al, 0Dh                     ; ENTER → fin
    je fin_carga
    cmp bx, 255
    je fin_carga

    mov [bx+si], al                 ; ✅ combinación válida
    inc bx
    jmp leer_caracter

fin_carga:
    mov [bx+si], '$'                ; ✅ correcto
    pop bx
    pop ax
    ret
cargar_texto endp

end
