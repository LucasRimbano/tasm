.8086
.model small
.stack 100h

.data
    cartel db "ingrese un cartel pa que no sea tan falopa o si...", 0Dh, 0Ah, '$'
    texto_a_ingresar db 256 dup (0), 0Dh, 0Ah, '$' ; Asegúrate de que el texto se termine correctamente
    texto_modificado db 256 dup (0), 0Dh, 0Ah, '$'
    enters db 0Dh, 0Ah, '$'

extrn texto_a_ingresar:byte
extrn texto_modificado:byte
.code
    extrn mostrar_cartel:proc
    extrn cargar_texto:proc

main:
    mov ax, @data
    mov ds, ax

    ; Mostrar el cartel
    lea dx, cartel
    call mostrar_cartel

    ; Cargar texto
    call cargar_texto

    ; Mostrar salto de línea
    lea dx, enters
    call mostrar_cartel

    ; Mostrar el texto ingresado
    lea dx, texto_a_ingresar
    call mostrar_cartel

    ; Mostrar salto de línea
    lea dx, enters
    call mostrar_cartel

    ; Mostrar el texto modificado
    lea dx, texto_modificado
    call mostrar_cartel

    ; Terminar el programa
    mov ax, 4C00h
    int 21h

end main
