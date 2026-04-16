.8086
.model small
.stack 100h

.data
cartel1 db "Ingrese un texto:",0dh,0ah,'$'
cartel2 db 0dh,0ah,"Texto original:",0dh,0ah,'$'
cartel3 db 0dh,0ah,"Texto en mayusculas:",0dh,0ah,'$'
cartel4 db 0dh,0ah,"Texto con espacios reemplazados:",0dh,0ah,'$'
cartel5 db 0dh,0ah,"Cantidad de palabras detectadas: ",'$'
cartel6 db 0dh,0ah,"Cantidad de vocales detectadas: ",'$'
nroAscii db '000','$'

extrn texto_a_ingresar:byte
extrn texto_mayusculizado:byte


.code
extrn imprimir_pantalla:proc
extrn cargar_texto:proc
extrn mayusculizar_texto:proc
extrn reemplazar_espacios:proc
extrn contador_palabras:proc
extrn reg2ascii:proc
extrn contador_letras:proc
extrn contador_vocales:proc 


main proc
    mov ax, @data
    mov ds, ax

    lea dx, cartel1
    call imprimir_pantalla

    call cargar_texto

    lea dx, cartel2
    call imprimir_pantalla
    lea dx, texto_a_ingresar
    call imprimir_pantalla

    call mayusculizar_texto

    lea dx, cartel3
    call imprimir_pantalla
    lea dx, texto_mayusculizado
    call imprimir_pantalla

    call reemplazar_espacios

    lea dx, cartel4
    call imprimir_pantalla
    lea dx, texto_a_ingresar
    call imprimir_pantalla

    lea si, texto_a_ingresar   
    call contador_palabras    

    mov al, cl                 ; pasamos resultado (0..255) a AL
    lea bx, nroAscii          
    call reg2ascii             ; convierte número a ASCII

    lea dx, cartel5
    call imprimir_pantalla
    lea dx, nroAscii
    call imprimir_pantalla
     call contador_vocales        ; CX ← cantidad de vocales
    mov al, cl                   ; pasar resultado (0..255) a AL
    lea bx, nroAscii             ; buffer destino
    call reg2ascii               ; convertir número a ASCII

    lea dx, cartel6
    call imprimir_pantalla

    lea dx, nroAscii
    call imprimir_pantalla

    mov ax,4C00h
    int 21h
main endp

end main
