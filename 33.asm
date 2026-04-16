;===========================================================
; LIBTEXT - Carga de texto desde teclado (con buffer auxiliar)
;-----------------------------------------------------------
; Lee texto hasta presionar ENTER y lo copia a texto_a_ingresar
; terminando en '$' para impresión con int 21h / ah=09h
;===========================================================

.8086
.model small
.stack 100h

.data
    public texto_a_ingresar
    texto_a_ingresar db 256 dup(0), '$'
    texto_temp db 256 dup(0)    ; buffer auxiliar

.code
public cargar_texto

cargar_texto proc
    push ax
    push bx
    push si

    xor bx, bx                  ; índice de lectura
    xor si, si                  ; índice de copia

leer_caracter:
    mov ah, 01h
    int 21h                     ; leer un carácter
    cmp al, 0Dh                 ; ENTER → fin
    je copiar_texto

    mov texto_temp[bx], al      ; guardar en buffer temporal
    inc bx
    cmp bx, 255
    je copiar_texto
    jmp leer_caracter

copiar_texto:
    mov cx, bx                  ; CX = longitud del texto
    xor bx, bx                  ; índice 0 para copiar

copiar_loop:
    cmp bx, cx
    je fin_copia
    mov al, texto_temp[bx]
    mov texto_a_ingresar[bx], al
    inc bx
    jmp copiar_loop

fin_copia:
    mov texto_a_ingresar[bx], '$'   ; terminador válido

    pop si
    pop bx
    pop ax
    ret
cargar_texto endp

end
