;===========================================================
; MAIN - PROGRAMA DE PRUEBA CONTADOR DE VOCALES
;-----------------------------------------------------------
; Usa rutinas externas:
;   cargar_texto
;   contar_vocales
;   reg2ascii
;   imprimir_pantalla
;===========================================================

.8086
.model small
.stack 100h

.data
msg_inicio  db "Ingrese un texto:",0dh,0ah,'$'
msg_result  db 0dh,0ah,"Cantidad de vocales detectadas: ",'$'
msg_result_cons db 0dh,0ah,"Cantidad de consonantes detectadas: ",'$'
nroAscii    db '000','$'

extrn texto_a_ingresar:byte

.code
extrn imprimir_pantalla:proc
extrn cargar_texto:proc
extrn reg2ascii:proc
extrn contar_vocales:proc
extrn contar_consonantes:proc

main proc
    mov ax, @data
    mov ds, ax

    ;-------------------------------------
    lea dx, msg_inicio
    call imprimir_pantalla

    ;-------------------------------------
    call cargar_texto

    ;-------------------------------------
    call contar_vocales        ; CX ← cantidad de vocales
    mov al, cl                 ; mover a AL
    lea bx, nroAscii
    call reg2ascii

    lea dx, msg_result
    call imprimir_pantalla

    lea dx, nroAscii
    call imprimir_pantalla


        ;-------------------------------------
    ; Contar consonantes
    ;-------------------------------------
    call contar_consonantes          ; CX ← cantidad de consonantes
    mov ax, cx                       ; pasar resultado a AX
    lea bx, nroAscii                 ; buffer para reg2ascii
    call reg2ascii

    lea dx, msg_result_cons
    call imprimir_pantalla

    lea dx, nroAscii
    call imprimir_pantalla

    mov ax, 4C00h
    int 21h
main endp

end main
