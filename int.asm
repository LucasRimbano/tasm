;============================================================
; LIB: miunidad_interrupcion.asm (limpia + HUD correcto)
;------------------------------------------------------------
; Exporta: jugar_int (devuelve AL=aciertos 0..5)
; Requiere: imprimir_pantalla, sonido_error, sonido_presentacion,
;           leer_caracter_abc, actualizar_puntaje, puntaje_total
; El llamador debe tener DS iniciado.
;============================================================

.8086
.model small
.stack 100h

extrn imprimir_pantalla:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn leer_caracter_abc:proc
extrn actualizar_puntaje:proc
extrn puntaje_total:byte

.data
msg_intro db 0dh,0ah,"[INTERRUPCIONES] Responde las siguientes preguntas!",0dh,0ah,'$'

msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto...",0dh,0ah,'$'
msg_final      db 0dh,0ah,"Fin de la unidad de INTERRUPCIONES!",0dh,0ah,'$'
msg_aprobado   db 0dh,0ah,"Excelente! Dominio solido de las interrupciones.",0dh,0ah,'$'
msg_reprobo    db 0dh,0ah,"Repasar interrupciones.",0dh,0ah,'$'


preg1 db 0dh,0ah,"1) Que hace una interrupcion?",0dh,0ah,'$'
opc1  db "a) Detiene el CPU permanentemente",0dh,0ah
       db "b) Suspende el flujo y atiende un evento",0dh,0ah
       db "c) Reinicia el programa desde cero",0dh,0ah,'$'
resp1 db 'B'

preg2 db 0dh,0ah,"2) Que instruccion finaliza una ISR?",0dh,0ah,'$'
opc2  db "a) RET",0dh,0ah
       db "b) IRET",0dh,0ah
       db "c) JMP",0dh,0ah,'$'
resp2 db 'B'

preg3 db 0dh,0ah,"3) Que hace la instruccion STI?",0dh,0ah,'$'
opc3  db "a) Deshabilita las interrupciones",0dh,0ah
       db "b) Habilita las interrupciones enmascarables",0dh,0ah
       db "c) Llama a una ISR directamente",0dh,0ah,'$'
resp3 db 'B'
db 47h,50h,54h,32h,35h
preg4 db 0dh,0ah,"4) Que tipo de interrupcion NO puede ser enmascarada?",0dh,0ah,'$'
opc4  db "a) NMI",0dh,0ah
       db "b) INT 21h",0dh,0ah
       db "c) INT 10h",0dh,0ah,'$'
resp4 db 'A'

preg5 db 0dh,0ah,"5) Que registro usa el CPU para saber si puede atender una interrupcion?",0dh,0ah,'$'
opc5  db "a) AX",0dh,0ah
       db "b) FLAGS",0dh,0ah
       db "c) CS",0dh,0ah,'$'
resp5 db 'B'


.code
public jugar_int

jugar_int proc
    push ax
    push bx
    push dx
    
    mov ax ,@data 
    mov dx ,ax 

    mov bl, 0                    ; aciertos locales (0..5)

    ; Intro + HUD
    call actualizar_puntaje
    lea dx, msg_intro
    call imprimir_pantalla
    call sonido_presentacion
    call actualizar_puntaje

    ;---------------- PREGUNTA 1 ----------------
    call actualizar_puntaje
    lea dx, preg1
    call imprimir_pantalla
    call actualizar_puntaje

    lea dx, opc1
    call imprimir_pantalla
    call actualizar_puntaje

    call leer_caracter_abc
    cmp al, [resp1]
    je  ok1
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    call actualizar_puntaje
    jmp p2
ok1:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

    ;---------------- PREGUNTA 2 ----------------
p2:
    call actualizar_puntaje
    lea dx, preg2
    call imprimir_pantalla
    call actualizar_puntaje

    lea dx, opc2
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, [resp2]
    je  ok2
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    call actualizar_puntaje
    jmp p3
ok2:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla
    call actualizar_puntaje

    ;---------------- PREGUNTA 3 ----------------
p3:
    call actualizar_puntaje
    lea dx, preg3
    call imprimir_pantalla
    call actualizar_puntaje

    lea dx, opc3
    call imprimir_pantalla
    call actualizar_puntaje

    call leer_caracter_abc
    cmp al, [resp3]
    je  ok3
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    call actualizar_puntaje
    jmp p4
ok3:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla
    call actualizar_puntaje

    ;---------------- PREGUNTA 4 ----------------
p4: 
    call actualizar_puntaje
    lea dx, preg4
    call imprimir_pantalla
    call actualizar_puntaje

    lea dx, opc4
    call imprimir_pantalla
    call actualizar_puntaje
    call leer_caracter_abc
    cmp al, [resp4]
    je  ok4
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    call actualizar_puntaje
    jmp p5
ok4:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla
    call actualizar_puntaje

    ;---------------- PREGUNTA 5 ----------------
p5:
    call actualizar_puntaje
    lea dx, preg5
    call imprimir_pantalla
    lea dx, opc5
    call imprimir_pantalla
    call actualizar_puntaje

    call leer_caracter_abc
    cmp al, [resp5]
    je  ok5
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    call actualizar_puntaje
    jmp fin_preguntas
ok5:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla
    call actualizar_puntaje

fin_preguntas:
    lea dx, msg_final
    call imprimir_pantalla
    call actualizar_puntaje

    ; Resultado textual (aprobado/reprobado)
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
    pop dx
    pop bx
    pop ax
    ret
jugar_int endp

end