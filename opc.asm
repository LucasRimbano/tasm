.8086
.model small
.stack 100h

.data
msg_error db 0dh,0ah,"Opcion invalida. Solo se permiten numeros del 1 al 5.",0dh,0ah,'$'
msg_ok1   db 0dh,0ah,"Has elegido la opcion 1: ALU",0dh,0ah,'$'
msg_ok2   db 0dh,0ah,"Has elegido la opcion 2: Memoria ",0dh,0ah,'$'
msg_ok3   db 0dh,0ah,"Has elegido la opcion 3: Interrupciones",0dh,0ah,'$'
msg_ok4   db 0dh,0ah,"Has elegido la opcion 4: Unidad de Control",0dh,0ah,'$'
msg_ok5   db 0dh,0ah,"Has elegido la opcion 5: Entrada y Salida",0dh,0ah,'$'

.code
public leer_opcion_menu
extrn imprimir_pantalla:proc
extrn sonido_error:proc 
extrn sonido_presentacion:proc 


leer_opcion_menu proc
    push dx

pedir:
    mov ah, 01h        
    int 21h          

    cmp al, '1'
    jb invalido
    cmp al, '5'
    ja invalido

    ; Mostrar mensaje segun la opcion elegida
 
    cmp al, '1'
    je opcion1
    cmp al, '2'
    je opcion2
    cmp al, '3'
    je opcion3
    cmp al, '4'
    je opcion4
    cmp al, '5'
    je opcion5

opcion1:
    lea dx, msg_ok1
    call imprimir_pantalla
    call sonido_presentacion   
    jmp fin
opcion2:
    lea dx, msg_ok2
    call imprimir_pantalla
    call sonido_presentacion   
    jmp fin
opcion3:
    lea dx, msg_ok3
    call imprimir_pantalla
    call sonido_presentacion   
    jmp fin
opcion4:
    lea dx, msg_ok4
    call imprimir_pantalla
    call sonido_presentacion   
    jmp fin
opcion5:
    lea dx, msg_ok5
    call imprimir_pantalla
    call sonido_presentacion   
    jmp fin


invalido:
    lea dx, msg_error
    call imprimir_pantalla
     call sonido_error  
    jmp pedir

fin:
    pop dx
    ret
leer_opcion_menu endp

end
