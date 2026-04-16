.8086
.model tiny
.code
org 100h

start:                      ; ← entrada EN 0100h, esto quiere TLINK
    jmp instalar_tsr        ; saltamos el bloque de datos

;---------------- DATOS (después del salto) -----------------
linea_vacia db 0Dh,0Ah,'$'
marco_sup   db "        +-------------------------------------------------------------+",0Dh,0Ah,'$'
marco_inf   db "        +-------------------------------------------------------------+",0Dh,0Ah,'$'
espacio_linea db "        |                                                             |",0Dh,0Ah,'$'

titulo_centro db "        |         SISTEMA DE PREGUNTAS Y DESAFIOS                     |",0Dh,0Ah,'$'
titulo1 db       "        |         Bienvenido al EXAMEN FINAL de SPD                   |",0Dh,0Ah,'$'
titulo2 db       "        |         Pone a prueba tus conocimientos tecnicos!           |",0Dh,0Ah,'$'
menu_linea1 db   "        |         1.ALU     2.MEMORIA     3.INTERRUPCIONES            |",0Dh,0Ah,'$'
menu_linea2 db   "        |                   4.UC      5.E/S                           |",0Dh,0Ah,'$'
espacio_inf db   "        |                                                             |",0Dh,0Ah,'$'

msg_anim   db "                 Cargando parcial...",0Dh,0Ah,'$'
msg_carga  db "                Ingresar solamente numeros del 1 al 5",0Dh,0Ah,'$'
msg_tiempo db "               Si tardas 10 segundos automaticamente",0Dh,0Ah
           db "               se da como respuesta incorrecta",0Dh,0Ah,'$'
msg_mouse  db "               Recorda que la quinta pregunta de todas las unidades" ,0dh,0ah
           db "               se responden con el mouse seleccionando la opcion" ,0dh,0ah
           db "               clickeando la respuesta que crea correcta" ,0dh,0ah   
           db "               para el mouse tenes 15 segundos para responder,",0dh,0ah
           db "               o automaticamente se da como respuesta incorrecta" ,0dh,0ah, '$'  
msg_instalado db 0Dh,0Ah,"INT 60h instalada para pantalla de INTRO.",0Dh,0Ah,'$'

old_off dw 0
old_seg dw 0

;------------------------------------------------------------
; Rutina de la INT 60h: muestra la intro
;------------------------------------------------------------
nueva_int proc far
    push ax
    push bx
    push cx
    push dx
    push ds
    push es

    mov ax, cs
    mov ds, ax

    ; Modo texto 80x25
    mov ax, 0003h
    int 10h

    ; Fondo azul texto amarillo
    mov ah, 09h
    mov al, ' '
    mov bh, 0
    mov bl, 1Eh
    mov cx, 2000
    int 10h

    ; Marco + textos
    lea dx, marco_sup
    mov ah, 09h
    int 21h

    lea dx, espacio_linea
    mov ah, 09h
    int 21h

    lea dx, titulo_centro
    mov ah, 09h
    int 21h

    lea dx, espacio_linea
    mov ah, 09h
    int 21h

    lea dx, titulo1
    mov ah, 09h
    int 21h

    lea dx, titulo2
    mov ah, 09h
    int 21h

    lea dx, espacio_linea
    mov ah, 09h
    int 21h

    lea dx, menu_linea1
    mov ah, 09h
    int 21h

    lea dx, menu_linea2
    mov ah, 09h
    int 21h

    lea dx, espacio_inf
    mov ah, 09h
    int 21h

    lea dx, marco_inf
    mov ah, 09h
    int 21h

    lea dx, msg_anim
    mov ah, 09h
    int 21h

    lea dx, msg_carga
    mov ah, 09h
    int 21h

    lea dx, msg_tiempo
    mov ah, 09h
    int 21h

    lea dx , msg_mouse
    mov ah , 09h
    int 21h

    ; Esperar una tecla
    mov ah, 00h
    int 16h

    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret
nueva_int endp

;------------------------------------------------------------
; PROGRAMA PRINCIPAL DEL .COM (TSR)
;------------------------------------------------------------
instalar_tsr:
    cli
    mov ax, cs
    mov ds, ax
    mov es, ax

    ; Guardar vector original de INT 60h (opcional)
    mov ax, 3560h
    int 21h
    mov old_off, bx
    mov old_seg, es

    ; Instalar nuestra INT 60h
    mov dx, offset nueva_int
    mov ax, 2560h
    int 21h
    sti

    ; Mensaje de instalación
    lea dx, msg_instalado
    mov ah, 09h
    int 21h

    ; Dejar residente este .COM
    mov dx, offset fin_residente
    sub dx, 100h
    mov ah, 31h
    int 21h

fin_residente label byte

end start
