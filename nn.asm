.8086
.model small
.stack 100h

.data
msg_inicio db "Ingrese una letra (A, B o C): ",0dh,0ah,'$'
msg_ok     db 0dh,0ah,"Letra ingresada correctamente!",0dh,0ah,'$'

.code
extrn imprimir_pantalla:proc
extrn leer_caracter_abc:proc

main proc
    mov ax, @data
    mov ds, ax

    lea dx, msg_inicio
    call imprimir_pantalla

    call leer_caracter_abc     ; ← devuelve AL = 'A', 'B' o 'C'

    lea dx, msg_ok
    call imprimir_pantalla

    mov ax, 4C00h
    int 21h
main endp
end main
