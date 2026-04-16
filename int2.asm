.8086
.model small
.stack 100h

extrn imprimir_pantalla:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn leer_caracter_abc:proc
extrn actualizar_puntaje:proc
extrn puntaje_total:byte
extrn cls_azul_10h:proc
extrn cambiar_color_amarillo:proc

.data
; Título SOLO
msg_intro      db 0dh,0ah,"[UNIDAD: INTERRUPCIONES]",0dh,0ah,'$'

msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto...",0dh,0ah,'$'
msg_final      db 0dh,0ah,"Fin de la unidad de INTERRUPCIONES!",0dh,0ah,'$'
msg_aprobado   db 0dh,0ah,"Excelente! Dominio solido de las interrupciones.",0dh,0ah,'$'
msg_reprobo    db 0dh,0ah,"Repasar interrupciones.",0dh,0ah,'$'
nl             db 0dh,0ah,'$'

; Preguntas + opciones separadas
preg1 db 0dh,0ah,"1) Que hace una interrupcion?",0dh,0ah,'$'
opc1  db "A) Detiene el CPU permanentemente",0dh,0ah
      db "B) Suspende el flujo y atiende un evento",0dh,0ah
      db "C) Reinicia el programa desde cero",0dh,0ah,'$'
resp1 db 'B'

preg2 db 0dh,0ah,"2) Que instruccion finaliza una ISR?",0dh,0ah,'$'
opc2  db "A) RET",0dh,0ah
      db "B) IRET",0dh,0ah
      db "C) JMP",0dh,0ah,'$'
resp2 db 'B'

preg3 db 0dh,0ah,"3) Que hace la instruccion STI?",0dh,0ah,'$'
opc3  db "A) Deshabilita las interrupciones",0dh,0ah
      db "B) Habilita las interrupciones enmascarables",0dh,0ah
      db "C) Llama a una ISR directamente",0dh,0ah,'$'
resp3 db 'B'

preg4 db 0dh,0ah,"4) Que tipo de interrupcion NO puede ser enmascarada?",0dh,0ah,'$'
opc4  db "A) NMI",0dh,0ah
      db "B) INT 21h",0dh,0ah
      db "C) INT 10h",0dh,0ah,'$'
resp4 db 'A'

preg5 db 0dh,0ah,"5) Que registro usa el CPU para saber si puede atender una interrupcion?",0dh,0ah,'$'
opc5  db "A) AX",0dh,0ah
      db "B) FLAGS",0dh,0ah
      db "C) CS",0dh,0ah,'$'
resp5 db 'B'

.code


; Helper: limpia + HUD + título + (pregunta + opciones)
; EN: DX = ptr pregunta ($) | BX = ptr opciones ($)

int_screen_preg_y_opc proc
    push ax
    push bx
    push dx
    call cls_azul_10h
    call cambiar_color_amarillo
    call actualizar_puntaje
    lea dx, msg_intro
    call imprimir_pantalla
    lea dx, nl
    call imprimir_pantalla
    pop dx              ; pregunta
    call imprimir_pantalla
    mov dx, bx          ; opciones
    call imprimir_pantalla
    pop bx
    pop ax
    ret
int_screen_preg_y_opc endp

; Helper: limpia + HUD + título + estado + línea + (pregunta+opc)
; EN: DX = ptr estado ($) | SI = ptr pregunta ($) | BX = ptr opciones ($)

int_screen_status_y_preg proc
    push ax
    push bx
    push si
    push dx
    call cls_azul_10h
    call actualizar_puntaje
    lea dx, msg_intro
    call imprimir_pantalla
    lea dx, nl
    call imprimir_pantalla
    pop dx              ; estado (Correcto/Incorrecto)
    call imprimir_pantalla
    lea dx, nl
    call imprimir_pantalla
    mov dx, si          ; pregunta
    call imprimir_pantalla
    mov dx, bx          ; opciones
    call imprimir_pantalla
    pop si
    pop bx
    pop ax
    ret
int_screen_status_y_preg endp

public jugar_int
jugar_int proc
    push ax
    push bx
    push dx
    push si

    mov bl, 0                    ; aciertos locales (0..5)

    ; Pantalla inicial con P1
    lea dx, preg1
    lea bx, opc1
    call int_screen_preg_y_opc
    call sonido_presentacion

;---------------- PREGUNTA 1 ----------------
    call leer_caracter_abc
    cmp al, [resp1]
    je  int_ok1
    call sonido_error
    lea dx, msg_incorrecto
    lea si, preg2
    lea bx, opc2
    call int_screen_status_y_preg
    jmp int_p2
int_ok1:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea si, preg2
    lea bx, opc2
    call int_screen_status_y_preg

;---------------- PREGUNTA 2 ----------------
int_p2:
    call leer_caracter_abc
    cmp al, [resp2]
    je  int_ok2
    call sonido_error
    lea dx, msg_incorrecto
    lea si, preg3
    lea bx, opc3
    call int_screen_status_y_preg
    jmp int_p3
int_ok2:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea si, preg3
    lea bx, opc3
    call int_screen_status_y_preg

;---------------- PREGUNTA 3 ----------------
int_p3:
    call leer_caracter_abc
    cmp al, [resp3]
    je  int_ok3
    call sonido_error
    lea dx, msg_incorrecto
    lea si, preg4
    lea bx, opc4
    call int_screen_status_y_preg
    jmp int_p4
int_ok3:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea si, preg4
    lea bx, opc4
    call int_screen_status_y_preg

;---------------- PREGUNTA 4 ----------------
int_p4:
    call leer_caracter_abc
    cmp al, [resp4]
    je  int_ok4
    call sonido_error
    lea dx, msg_incorrecto
    lea si, preg5
    lea bx, opc5
    call int_screen_status_y_preg
    jmp int_p5
int_ok4:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea si, preg5
    lea bx, opc5
    call int_screen_status_y_preg

;---------------- PREGUNTA 5 ----------------
int_p5:
    call leer_caracter_abc
    cmp al, [resp5]
    je  int_ok5
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp int_final
int_ok5:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

;---------------- FINAL ---------------------
int_final:
    call cls_azul_10h
    call actualizar_puntaje
    lea dx, msg_final
    call imprimir_pantalla
    call actualizar_puntaje

    cmp bl, 3
    jb  int_repro
    lea dx, msg_aprobado
    call imprimir_pantalla
    jmp int_fin

int_repro:
    lea dx, msg_reprobo
    call imprimir_pantalla

int_fin:
    mov al, bl                 ; devolver puntaje en AL
    pop si
    pop dx
    pop bx
    pop ax
    ret
jugar_int endp

end
