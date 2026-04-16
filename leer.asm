.8086
.model small
.data 
    texto_a_ingresar db 256 dup (0)
    texto_modificado db 256 dup (0)
    enters db 0Dh, 0Ah, '$'
.code

public cargar_texto

cargar_texto proc
    mov bx, 0

cargar_texto_ingresado:
    mov ah, 01h
    int 21h
    cmp al, 0dh
    je fin_cargar_texto_ingresado
    mov texto_a_ingresar[bx], al 
    mov texto_modificado[bx], al 
    inc bx 
    jmp cargar_texto_ingresado

fin_cargar_texto_ingresado:
    mov texto_a_ingresar[bx], '$' ; Terminar el texto ingresado
    mov texto_modificado[bx], '$' ; Terminar el texto modificado
    ret
cargar_texto endp

end cargar_texto
end
