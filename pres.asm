;===========================================================
; LIBOPCIONES - Lee una opción válida (1–5)
;-----------------------------------------------------------
; Entrada: ninguna
; Salida:  AL = opción elegida ('1'..'5')
;-----------------------------------------------------------
; Opción válida → texto amarillo brillante + sonido presentación
; Opción inválida → texto gris + pip de error
;===========================================================

.8086
.model small
.stack 100h

.data
msg_error db 0dh,0ah,"Opcion invalida. Solo se permiten numeros del 1 al 5.",0dh,0ah,'$'
msg_ok1   db 0dh,0ah,"Has elegido la opcion 1: Futbol",0dh,0ah,'$'
msg_ok2   db 0dh,0ah,"Has elegido la opcion 2: Pelicula",0dh,0ah,'$'
msg_ok3   db 0dh,0ah,"Has elegido la opcion 3: Presidente",0dh,0ah,'$'
msg_ok4   db 0dh,0ah,"Has elegido la opcion 4: Actor",0dh,0ah,'$'
msg_ok5   db 0dh,0ah,"Has elegido la opcion 5: Musica",0dh,0ah,'$'

.code
public leer_opcion_menu
extrn imprimir_pantalla:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc

leer_opcion_menu proc
    push dx
    push bx
    push ax

pedir:
    mov ah, 01h        ; Leer carácter (eco automático)
    int 21h            ; Resultado en AL

    ;-----------------------------------------
    ; Verificar si está entre '1' y '5'
    ;-----------------------------------------
    cmp al, '1'
    jb invalido
    cmp al, '5'
    ja invalido

    ;-----------------------------------------
    ; Opción válida → color amarillo (0Eh)
    ;-----------------------------------------
    mov ah, 09h
    mov al, 0
    mov bh, 0
    mov bl, 0Eh        ; amarillo brillante sobre negro
    mov cx, 1
    int 10h

    ;-----------------------------------------
    ; Mostrar mensaje y sonido presentación
    ;-----------------------------------------
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

;-----------------------------------------
; ERROR → gris sobre negro (07h)
;-----------------------------------------
invalido:
    call sonido_error

    mov ah, 09h
    mov al, 0
    mov bh, 0
    mov bl, 07h        ; gris sobre negro
    mov cx, 1
    int 10h

    lea dx, msg_error
    call imprimir_pantalla
    jmp pedir

;-----------------------------------------
; Fin
;-----------------------------------------
fin:
    pop ax
    pop bx
    pop dx
    ret
leer_opcion_menu endp

end
