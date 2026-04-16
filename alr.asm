; LIBRERIA: INVERTIR_TEXTO.ASM 
.8086
.model small
.stack 100h
.data
extrn texto_a_ingresar:byte
buffer_invertido db 255 dup('$')   ; espacio para el texto invertido

.code
public invertir_texto
extrn imprimir_pantalla:proc

invertir_texto proc
    push ax
    push bx
    push si
    push di
    push dx

    mov si, offset texto_a_ingresar
    mov di, offset buffer_invertido
    xor bx, bx                ; índice del buffer

; 1  Buscar el final del texto original

buscar_fin:
    mov al, [si]
    cmp al, '$'
    je fin_encontrado
    inc si
    jmp buscar_fin

fin_encontrado:
    dec si                     ; ahora SI apunta al último carácter válido

; 2️ Copiar en orden inverso

invertir:
    cmp si, offset texto_a_ingresar
    jb listo
    mov al, [si]
    mov buffer_invertido[bx], al
    inc bx
    dec si
    jmp invertir

listo:
    mov buffer_invertido[bx], '$'   ; terminador DOS obligatorio

; 3️ Mostrar texto invertido

    lea dx, buffer_invertido
    call imprimir_pantalla


; 4️ Restaurar registros

    pop dx
    pop di
    pop si
    pop bx
    pop ax
    ret
invertir_texto endp

end
