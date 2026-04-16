.8086
.model small
.stack 100h

.data
    extrn texto_a_ingresar:byte    

.code
    public imprimir_texto
    public imprimir_pantalla    


imprimir_pantalla proc
    mov ah, 09h
    int 21h
    ret
imprimir_pantalla endp




imprimir_texto proc
    push dx

    lea dx, texto_a_ingresar       ; cargar dirección del texto
    call imprimir_pantalla        

    mov ah, 09h                    ; salto de línea
    mov dx, offset salto
    int 21h

    pop dx
    ret
imprimir_texto endp




salto db 0dh,0ah,'$'

end
