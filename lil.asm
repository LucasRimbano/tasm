;=========================================================
; 2do Parcial - SPD - Assembler 8086
; Autor: [Tu Nombre]
;---------------------------------------------------------
; Main principal: muestra menú, gestiona opciones
; Usa librerías externas:
;   txt.asm   → cargar_texto
;   letr.asm  → cargar_letras
;   voca.asm  → contar_vocales
;   imp.asm   → imprimir_texto / imprimir_pantalla
;   r2a.asm   → reg2ascii
;=========================================================

.8086
.model small
.stack 100h

.data
;---------------------------------------------------------
cartel_menu db 0dh,0ah,"------------------------------",0dh,0ah
             db "   MENU PRINCIPAL",0dh,0ah
             db "------------------------------",0dh,0ah
             db "1. Leer un texto (hasta 255 caracteres)",0dh,0ah
             db "2. Cargar texto solo con letras",0dh,0ah
             db "3. Contar y mostrar cantidad total de vocales",0dh,0ah
             db "4. Imprimir el último texto ingresado",0dh,0ah
             db "5. Mostrar total de cargas de texto realizadas",0dh,0ah
             db "6. Salir",0dh,0ah
             db "------------------------------",0dh,0ah
             db "Seleccione opción: $"

msg_ingrese db 0dh,0ah,"Ingrese un texto (finalice con ENTER): $"
msg_ok      db 0dh,0ah,"Texto cargado correctamente.$"
msg_vocales db 0dh,0ah,"Cantidad de vocales del texto actual: $"
msg_total   db 0dh,0ah,"Total de cargas realizadas: $"
msg_salida  db 0dh,0ah,"Saliendo del programa...$"
salto       db 0dh,0ah,'$'

nroAscii db '000','$'
cant_cargas db 0

;---------------------------------------------------------
extrn texto_a_ingresar:byte       ; variable global de letr.asm

; funciones externas
extrn cargar_texto:proc
extrn cargar_letras:proc
extrn contar_vocales:proc
extrn imprimir_texto:proc
extrn imprimir_pantalla:proc
extrn reg2ascii:proc

.code
main proc
    mov ax, @data
    mov ds, ax

menu_principal:
    lea dx, cartel_menu
    call imprimir_pantalla

    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    cmp bl, 1
    je opcion1
    cmp bl, 2
    je opcion2
    cmp bl, 3
    je opcion3
    cmp bl, 4
    je opcion4
    cmp bl, 5
    je opcion5
    cmp bl, 6
    je salir
    jmp menu_principal

;---------------------------------------------------------
opcion1:
    lea dx, msg_ingrese
    call imprimir_pantalla

    lea dx, texto_a_ingresar
    call cargar_texto

    inc cant_cargas
    lea dx, msg_ok
    call imprimir_pantalla
    jmp menu_principal

;---------------------------------------------------------
opcion2:
    lea dx, msg_ingrese
    call imprimir_pantalla

    lea dx, texto_a_ingresar
    call cargar_letras

    inc cant_cargas
    lea dx, msg_ok
    call imprimir_pantalla
    jmp menu_principal

;---------------------------------------------------------
opcion3:
    lea dx, texto_a_ingresar
    call contar_vocales           ; AL = cantidad

    mov ah, 0
    mov bl, 10
    call reg2ascii                ; convierte AL a ASCII → nroAscii

    lea dx, msg_vocales
    call imprimir_pantalla

    lea dx, nroAscii
    call imprimir_pantalla
    jmp menu_principal

;---------------------------------------------------------
opcion4:
    call imprimir_texto
    jmp menu_principal

;---------------------------------------------------------
opcion5:
    mov al, cant_cargas
    mov ah, 0
    mov bl, 10
    call reg2ascii

    lea dx, msg_total
    call imprimir_pantalla

    lea dx, nroAscii
    call imprimir_pantalla
    jmp menu_principal

;---------------------------------------------------------
salir:
    lea dx, msg_salida
    call imprimir_pantalla

    mov ax, 4C00h
    int 21h
main endp

end main
