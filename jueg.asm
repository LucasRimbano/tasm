.8086
.model small
.stack 100h

.data
    cartel_bienvenida db "Bienvenido al juego..." ,0dh,0ah
                      db "Elija una opcion por la cual queres jugar...",0dh,0ah,'$'
    opcion_1          db "Presione 1 para seleccionar futbol....",0dh,0ah,'$' 
    opcion_2          db "Presione 2 para seleccionar pelicula...",0dh,0ah,'$'
    opcion_3          db "Presione 3 para seleccionar...",0dh,0ah,'$'    
    opcion_4          db "Presione 4 para seleccionar...",0dh,0ah,'$'
    opcion_5          db "Presione 5 para seleccionar...",0dh,0ah,'$'
    opcion_6          db "Presione 6 para seleccionar...",0dh,0ah,'$'
    opcion_7          db "Presione 7 para seleccionar...",0dh,0ah,'$'

.code
main proc
    mov ax, @data      ; ✅ inicializa segmento de datos correctamente
    mov ds, ax

    ; Mostrar menú de opciones
    mov ah, 09h
    lea dx, cartel_bienvenida
    int 21h

    lea dx, opcion_1
    int 21h

    lea dx, opcion_2
    int 21h

    lea dx, opcion_3
    int 21h

    lea dx, opcion_4
    int 21h

    lea dx, opcion_5
    int 21h

    lea dx, opcion_6
    int 21h

    lea dx, opcion_7
    int 21h

    ; Terminar programa
    mov ax, 4C00h
    int 21h
main endp

end
