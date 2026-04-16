.8086
.model small
.stack 100h

.data
    cartel db "Ingrese un cartel pa que no sea tan falopa o si...", 0Dh, 0Ah, '$'

.code
main:
    mov ax, @data      ; Inicializar segmento de datos
    mov ds, ax

    lea dx, cartel     ; Cargar dirección del mensaje
    call mostrar_cartel

    mov ax, 4C00h      ; Terminar el programa
    int 21h

mostrar_cartel proc
    mov ah, 09h        ; Función DOS para mostrar cadena terminada en '$'
    int 21h
    ret
mostrar_cartel endp

end main