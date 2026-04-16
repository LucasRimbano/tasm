; MAIN - Juego de Adivinanzas SPD
; Usa librerías externas:
;   imprimir_pantalla
;   leer_opcion_menu
;   sonido_presentacion
;   sonido_error
;   cambiar_color_amarillo
;   cambiar_color_gris
;   jugar_alu / jugar_mem / jugar_int / jugar_uc / jugar_io


.8086
.model small
.stack 100h

.data
    cartel_bienvenida db "Bienvenido examen de SPD..." ,0dh,0ah
                      db "Donde vamos a poner a prueba tus conocimientos..." ,0dh,0ah
                      db "Elija una unidad para jugar:",0dh,0ah,'$'

    opcion_1 db "1. UNIDAD ARITMETICO-LOGICA (ALU)",0dh,0ah,'$' 
    opcion_2 db "2. MEMORIA PRINCIPAL",0dh,0ah,'$'
    opcion_3 db "3. INTERRUPCIONES",0dh,0ah,'$'    
    opcion_4 db "4. UNIDAD DE CONTROL",0dh,0ah,'$'
    opcion_5 db "5. ENTRADAS / SALIDAS",0dh,0ah,'$'

    cartel db 0dh,0ah,"Mucha suerte rick... ",0dh,0ah,'$'
    msg_error db 0dh,0ah,"Opcion invalida. Debes ingresar un numero del 1 al 5.",0dh,0ah,'$'
    msg_salir db 0dh,0ah,"Gracias por jugar y repasar SPD! ",0dh,0ah,'$'

.code
extrn imprimir_pantalla:proc  
extrn leer_opcion_menu:proc
extrn sonido_presentacion:proc
extrn sonido_error:proc
extrn cambiar_color_amarillo:proc
extrn cambiar_color_gris:proc
extrn jugar_alu:proc
extrn jugar_mem:proc
extrn jugar_int:proc
extrn jugar_uc:proc
extrn jugar_io:proc

main proc
    mov ax, @data
    mov ds, ax


    ; Configurar color amarillo y sonido inicial
 
    call cambiar_color_amarillo
    lea dx, cartel_bienvenida
    call imprimir_pantalla
    call sonido_presentacion

  
    ; Mostrar opciones del menu principal
  
    lea dx, opcion_1
    call imprimir_pantalla
    lea dx, opcion_2
    call imprimir_pantalla
    lea dx, opcion_3
    call imprimir_pantalla
    lea dx, opcion_4
    call imprimir_pantalla
    lea dx, opcion_5
    call imprimir_pantalla

    lea dx, cartel
    call imprimir_pantalla


; Leer opcion del usuario (solo 1–5)

leer_opcion:
    call leer_opcion_menu
    ; AL contiene la opcion elegida (‘1’..‘5’)

    cmp al, '1'
    je juego_alu
    cmp al, '2'
    je juego_mem
    cmp al, '3'
    je juego_int
    cmp al, '4'
    je juego_uc
    cmp al, '5'
    je juego_io


; Si el valor no esta entre 1–5 → error

    call cambiar_color_gris
    lea dx, msg_error
    call imprimir_pantalla
    call sonido_error
    call cambiar_color_amarillo
    jmp leer_opcion


; LLAMADAS A LOS SUBJUEGOS

juego_alu:
    call jugar_alu
    jmp fin

juego_mem:
    call jugar_mem
    jmp fin

juego_int:
    call jugar_int
    jmp fin

juego_uc:
    call jugar_uc
    jmp fin

juego_io:
    call jugar_io
    jmp fin

fin:
    lea dx, msg_salir
    call imprimir_pantalla

    mov ax, 4C00h
    int 21h
main endp

end main
