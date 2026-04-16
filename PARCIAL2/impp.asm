.8086
.model small
.stack 100h

.data
    extrn texto_a_ingresar:byte

.code

public imprimir_pantalla
public imprimir_texto




imprimir_pantalla proc
    mov ah, 09h
    int 21h
    ret
imprimir_pantalla endp



imprimir_texto proc
    lea dx, texto_a_ingresar
    call imprimir_pantalla

    lea dx, salto
    call imprimir_pantalla
    ret
imprimir_texto endp

salto db 0dh,0ah,'$'

end
