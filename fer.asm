;===========================================================
; MAIN - Prueba completa de reg2ascii y ascii2reg
;-----------------------------------------------------------
; Lee texto, cuenta palabras, convierte a ASCII y reconvierte
;===========================================================

.8086
.model small
.stack 100h

.data
msg_inicio db "Ingrese un texto:",0dh,0ah,'$'
msg_result db 0dh,0ah,"Cantidad de palabras detectadas: ",'$'
msg_confirm db 0dh,0ah,"Reconversión a número (ascii2reg): ",'$'

nroAscii db '000','$'       ; buffer de salida para reg2ascii
texto_a_ingresar db 255 dup (0),'$'   ; texto del usuario

.code
extrn imprimir_pantalla:proc
extrn cargar_texto:proc
extrn contador_palabras:proc
extrn reg2ascii:proc
extrn ascii2reg:proc

main proc
    mov ax, @data
    mov ds, ax

    ;-------------------------------------
    ; Ingresar texto
    lea dx, msg_inicio
    call imprimir_pantalla
    call cargar_texto

    ;-------------------------------------
    ; Contar palabras → CX = cantidad
    lea si, texto_a_ingresar
    call contador_palabras

    ;-------------------------------------
    ; Convertir número a ASCII
    mov ax, cx
    mov bx, offset nroAscii
    call reg2ascii

    lea dx, msg_result
    call imprimir_pantalla
    lea dx, nroAscii
    call imprimir_pantalla

    ;-------------------------------------
    ; Convertir ASCII → número (test)
    mov bx, offset nroAscii
    call ascii2reg   ; AX = valor reconvertido

    ;-------------------------------------
    ; Mostrar el número reconvertido
    mov bx, offset nroAscii
    call reg2ascii   ; vuelve a ASCII para mostrarlo

    lea dx, msg_confirm
    call imprimir_pantalla
    lea dx, nroAscii
    call imprimir_pantalla

    ;-------------------------------------
    mov ax, 4C00h
    int 21h
main endp

end main
