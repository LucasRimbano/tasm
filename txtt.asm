.8086
.model small
.stack 100h

.data
    extrn texto_a_ingresar:byte

.code

public cargar_texto


cargar_texto proc
    push ax
    push bx
    xor bx, bx
    lea si, texto_a_ingresar      

leer_caracter:
    mov ah, 01h
    int 21h
    cmp al, 0Dh                     
    je fin_carga
    cmp bx, 255
    je fin_carga

    mov [bx+si], al                 ;  combinación valida
    inc bx
    jmp leer_caracter

fin_carga:
    mov [bx+si], '$'                :correcto 
    pop bx
    pop ax
    ret
cargar_texto endp

end
