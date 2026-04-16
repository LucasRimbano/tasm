; TP FINAL - Juego de Adivinanzas SPD
.8086
.model small
.stack 100h

.data
cartel_bienvenida db "Selecciona una unidad para comenzar:",0dh,0ah,'$'

opcion_1 db "1. UNIDAD ARITMETICO-LOGICA (ALU)",0dh,0ah,'$'
opcion_2 db "2. MEMORIA PRINCIPAL",0dh,0ah,'$'
opcion_3 db "3. INTERRUPCIONES",0dh,0ah,'$'
opcion_4 db "4. UNIDAD DE CONTROL",0dh,0ah,'$'
opcion_5 db "5. ENTRADAS / SALIDAS",0dh,0ah,'$'

cartel db 0dh,0ah,"Mucha suerte Rick...",0dh,0ah,'$'
msg_error db 0dh,0ah,"Opcion invalida. Solo del 1 al 5.",0dh,0ah,'$'
msg_repetido db 0dh,0ah,"Esa unidad ya fue completada. Elegi otra, bro.",0dh,0ah,'$'
msg_final db 0dh,0ah,"Felicitaciones! Completaste todas las unidades de SPD!",0dh,0ah,'$'
msg_total db 0dh,0ah,"Tu puntaje final es: ",'$'
msg_aprobado db 0dh,0ah,"Aprobado! Excelente repaso de SPD!",0dh,0ah,'$'
msg_desaprobado db 0dh,0ah,"Desaprobado. Segui estudiando, Rick.",0dh,0ah,'$'
msg_salir db 0dh,0ah,"Gracias por jugar y repasar SPD!",0dh,0ah,'$'


nro_ascii db '000','$'          
unidades_jugadas db 0,0,0,0,0  
completadas db 0               
puntaje_total db 0              

.code
extrn imprimir_pantalla:proc
extrn leer_opcion_menu:proc
extrn sonido_presentacion:proc
extrn sonido_error:proc
extrn cambiar_color_amarillo:proc
extrn cambiar_color_gris:proc
extrn reg2ascii:proc
extrn jugar_alu:proc
extrn jugar_mem:proc
extrn jugar_int:proc
extrn jugar_uc:proc
extrn jugar_io:proc
extrn intro:proc



; PROGRAMA PRINCIPAL

main proc
    mov ax, @data
    mov ds, ax

    call intro

    call cambiar_color_amarillo
    lea dx, cartel_bienvenida
    call imprimir_pantalla
    call sonido_presentacion

 
; LOOP PRINCIPAL

menu_principal:
    mov al, [completadas]
    cmp al, 5
    jne continuar_menu
    jmp fin_juego

continuar_menu:
    call mostrar_menu_dinamico
    call leer_opcion_menu

    cmp al, '1'
    jne check2
    jmp unidad_1
check2:
    cmp al, '2'
    jne check3
    jmp unidad_2
check3:
    cmp al, '3'
    jne check4
    jmp unidad_3
check4:
    cmp al, '4'
    jne check5
    jmp unidad_4
check5:
    cmp al, '5'
    jne opcion_invalida
    jmp unidad_5


; OPCIÓN INVALIDA

opcion_invalida:
    call cambiar_color_gris
    lea dx, msg_error
    call imprimir_pantalla
    call sonido_error
    call cambiar_color_amarillo
    jmp menu_principal


; UNIDADES

unidad_1:
    mov bx, offset unidades_jugadas
    cmp byte ptr [bx], 1
    jne not_rep_1
    jmp repetida
not_rep_1:
    mov byte ptr [bx], 1
    inc byte ptr [completadas]
    call jugar_alu        ; devuelve AL = puntaje (0–5)
    add [puntaje_total], al
    jmp volver_menu

unidad_2:
    mov bx, offset unidades_jugadas
    add bx, 1
    cmp byte ptr [bx], 1
    jne not_rep_2
    jmp repetida
not_rep_2:
    mov byte ptr [bx], 1
    inc byte ptr [completadas]
    call jugar_mem
    add [puntaje_total], al
    jmp volver_menu

unidad_3:
    mov bx, offset unidades_jugadas
    add bx, 2
    cmp byte ptr [bx], 1
    jne not_rep_3
    jmp repetida
not_rep_3:
    mov byte ptr [bx], 1
    inc byte ptr [completadas]
    call jugar_int
    add [puntaje_total], al
    jmp volver_menu

unidad_4:
    mov bx, offset unidades_jugadas
    add bx, 3
    cmp byte ptr [bx], 1
    jne not_rep_4
    jmp repetida
not_rep_4:
    mov byte ptr [bx], 1
    inc byte ptr [completadas]
    call jugar_uc
    add [puntaje_total], al
    jmp volver_menu

unidad_5:
    mov bx, offset unidades_jugadas
    add bx, 4
    cmp byte ptr [bx], 1
    jne not_rep_5
    jmp repetida
not_rep_5:
    mov byte ptr [bx], 1
    inc byte ptr [completadas]
    call jugar_io
    add [puntaje_total], al
    jmp volver_menu


; UNIDAD REPETIDA

repetida:
    call cambiar_color_gris
    lea dx, msg_repetido
    call imprimir_pantalla
    call sonido_error
    call cambiar_color_amarillo
    jmp menu_principal


; VOLVER AL MENÚ

volver_menu:
    lea dx, cartel
    call imprimir_pantalla
    jmp menu_principal


; FINAL DEL JUEGO

fin_juego:
    lea dx, msg_final
    call imprimir_pantalla
    call sonido_presentacion

    lea dx, msg_total
    call imprimir_pantalla

    mov al, [puntaje_total]
    mov ah, 0
    mov bx, offset nro_ascii
    call reg2ascii
    lea dx, nro_ascii
    call imprimir_pantalla

    mov dl, '/'
    mov ah, 02h
    int 21h
    mov dl, '2'
    int 21h
    mov dl, '5'
    int 21h

    mov al, [puntaje_total]
    cmp al, 13
    jb desaprobado
    lea dx, msg_aprobado
    call imprimir_pantalla
    jmp fin

desaprobado:
    lea dx, msg_desaprobado
    call imprimir_pantalla

fin:
    lea dx, msg_salir
    call imprimir_pantalla
    mov ax, 4C00h
    int 21h
main endp

; SUBRUTINA: Mostrar unidades restantes

mostrar_menu_dinamico proc
    push bx
    push dx

    mov bx, offset unidades_jugadas 

    cmp byte ptr [bx], 1
    je skip1
    lea dx, opcion_1
    call imprimir_pantalla
skip1:
    cmp byte ptr [bx+1], 1  
    je skip2
    lea dx, opcion_2
    call imprimir_pantalla
skip2:
    cmp byte ptr [bx+2], 1
    je skip3
    lea dx, opcion_3
    call imprimir_pantalla
skip3:
    cmp byte ptr [bx+3], 1
    je skip4
    lea dx, opcion_4
    call imprimir_pantalla
skip4:
    cmp byte ptr [bx+4], 1
    je skip5
    lea dx, opcion_5
    call imprimir_pantalla
skip5:
    lea dx, cartel
    call imprimir_pantalla

    pop dx
    pop bx
    ret
mostrar_menu_dinamico endp

end main
