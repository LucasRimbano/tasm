.8086
.model small
.stack 100h

.data
linea_vacia db 0dh,0ah,'$'
marco_sup db "        +-------------------------------------------------------------+",0dh,0ah,'$'
marco_inf db "        +-------------------------------------------------------------+",0dh,0ah,'$'
espacio_linea db "        |                                                             |",0dh,0ah,'$'

titulo_centro db "        |         SISTEMA DE PREGUNTAS Y DESAFIOS                     |",0dh,0ah,'$'
titulo1 db       "        |         Bienvenido al EXAMEN FINAL de SPD                   |",0dh,0ah,'$'
titulo2 db       "        |         Pone a prueba tus conocimientos tecnicos!           |",0dh,0ah,'$'
menu_linea1 db   "        |         1.ALU     2.MEMORIA     3.INTERRUPCIONES            |",0dh,0ah,'$'
menu_linea2 db   "        |               4.UC      5.E/S                               |",0dh,0ah,'$'
espacio_inf db   "        |                                                             |",0dh,0ah,'$'

msg_anim db "                 Cargando juego...",0dh,0ah,'$'
msg_carga db "                Ingresar solamente numeros del 1 al 5" ,0dh,0ah,'$'
.code
extrn imprimir_pantalla:proc
public intro

intro proc
    mov ax, @data
    mov ds, ax

    ; Modo texto 80x25
    mov ax, 03h
    int 10h

    ; Fondo azul, texto amarillo
    mov ah, 09h
    mov al, ' '
    mov bh, 0
    mov bl, 1Eh
    mov cx, 2000
    int 10h

    ; Mostrar cuadro
    lea dx, marco_sup
    call imprimir_pantalla
    lea dx, espacio_linea
    call imprimir_pantalla
    lea dx, titulo_centro
    call imprimir_pantalla
    lea dx, espacio_linea
    call imprimir_pantalla
    lea dx, titulo1
    call imprimir_pantalla
    lea dx, titulo2
    call imprimir_pantalla
    lea dx, espacio_linea
    call imprimir_pantalla
    lea dx, menu_linea1
    call imprimir_pantalla
    lea dx, menu_linea2
    call imprimir_pantalla
    lea dx, espacio_inf
    call imprimir_pantalla
    lea dx, marco_inf
    call imprimir_pantalla

    lea dx, msg_anim
    call imprimir_pantalla
    
    lea dx , msg_carga
    call imprimir_pantalla

    mov ah, 00h
    int 16h
    ret
intro endp

end intro
