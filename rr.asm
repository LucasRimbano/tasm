;===========================================================
; MAIN - Conversión de texto a MAYÚSCULAS
;-----------------------------------------------------------
; Usa librerías externas:
;   cargar_texto.asm
;   imprimir_pantalla.asm
;   mayusculizar_texto.asm
;-----------------------------------------------------------
; El texto ingresado se convierte a mayúsculas
; y se muestra en pantalla.
;===========================================================

.8086
.model small
.stack 100h

.data
msg_intro   db "Ingrese un texto:",0dh,0ah,'$'
msg_result  db 0dh,0ah,"Texto convertido a MAYUSCULAS:",0dh,0ah,'$'

extrn texto_a_ingresar:byte
extrn texto_mayusculizado:byte

.code
extrn imprimir_pantalla:proc
extrn cargar_texto:proc
extrn mayusculizar_texto:proc

main proc
    mov ax, @data
    mov ds, ax

    ;-------------------------------------
    ; Mostrar mensaje inicial
    lea dx, msg_intro
    call imprimir_pantalla

    ; Leer texto ingresado por el usuario
    call cargar_texto

    ;-------------------------------------
    ; Convertir texto a mayúsculas
    call mayusculizar_texto

    ;-------------------------------------
    ; Mostrar resultado
    lea dx, msg_result
    call imprimir_pantalla

    lea dx, texto_mayusculizado
    call imprimir_pantalla

    ;-------------------------------------
    ; Salir del programa
    mov ax, 4C00h
    int 21h
main endp

end main
