;============================================================
; LIB: miunidad_alu.asm  — Opción 3 (DS sólo en el main)
;------------------------------------------------------------
; Exporta:  jugar_alu -> AL = aciertos (0..5)
; Requiere: imprimir_pantalla, leer_caracter_abc,
;           sonido_error, sonido_presentacion,
;           actualizar_puntaje, puntaje_total
; NOTA: Este módulo NO inicializa DS. Lo hace el main.
;============================================================

.8086
.model small
.stack 100h

extrn imprimir_pantalla:proc
extrn leer_caracter_abc:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn actualizar_puntaje:proc
extrn puntaje_total:byte

.data
msg_intro      db 0dh,0ah,"[UNIDAD: ARITMETICO-LOGICA (ALU)]",0dh,0ah
               db "Responde las 5 preguntas del parcial (A, B o C).",0dh,0ah,'$'

msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto!",0dh,0ah,'$'
db 47h,50h,54h,32h,35h
msg_final      db 0dh,0ah,"Fin de la unidad de ALU!",0dh,0ah,'$'
msg_aprobado   db 0dh,0ah,"Excelente! Dominio solido de la ALU.",0dh,0ah,'$'
msg_reprobo    db 0dh,0ah,"Repasar operaciones aritmeticas y logicas.",0dh,0ah,'$'

; Preguntas
preg1 db 0dh,0ah,"1) Que funcion cumple la ALU?",0dh,0ah
      db "A) Controlar la memoria",0dh,0ah
      db "B) Ejecutar operaciones aritmeticas y logicas",0dh,0ah
      db "C) Coordinar perifericos",0dh,0ah,'$'

preg2 db 0dh,0ah,"2) Que registros intervienen en las operaciones de la ALU?",0dh,0ah
      db "A) AX, BX, CX, DX",0dh,0ah
      db "B) CS, DS, SS, ES",0dh,0ah
      db "C) IP, SP, BP",0dh,0ah,'$'

preg3 db 0dh,0ah,"3) Que indica el bit de carry (CF)?",0dh,0ah
      db "A) Error de programa",0dh,0ah
      db "B) Desbordamiento de suma/resta",0dh,0ah
      db "C) Activa la memoria",0dh,0ah,'$'

preg4 db 0dh,0ah,"4) Cual instruccion realiza una suma?",0dh,0ah
      db "A) ADD",0dh,0ah
      db "B) CMP",0dh,0ah
      db "C) MOV",0dh,0ah,'$'

preg5 db 0dh,0ah,"5) Cual instruccion realiza una comparacion?",0dh,0ah
      db "A) CMP",0dh,0ah
      db "B) XOR",0dh,0ah
      db "C) JMP",0dh,0ah,'$'

.code
public jugar_alu

jugar_alu proc
    push ax
    push bx
    push dx

    mov bl, 0                    ; aciertos locales (0..5)

    ; Intro + HUD
    call actualizar_puntaje
    lea dx, msg_intro
    call imprimir_pantalla
    call sonido_presentacion

;==================== PREGUNTA 1 ======================
    lea dx, preg1
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, 'B'
    je  ok1
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p2
ok1:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

;==================== PREGUNTA 2 ======================
p2:
    lea dx, preg2
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, 'A'
    je  ok2
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p3
ok2:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

;==================== PREGUNTA 3 ======================
p3:
    lea dx, preg3
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, 'B'
    je  ok3
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p4
ok3:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

;==================== PREGUNTA 4 ======================
p4:
    lea dx, preg4
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, 'A'
    je  ok4
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p5
ok4:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

;==================== PREGUNTA 5 ======================
p5:
    lea dx, preg5
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, 'A'
    je  ok5
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp fin
ok5:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

;==================== FINAL ===========================
fin:
    lea dx, msg_final
    call imprimir_pantalla
    call actualizar_puntaje

    cmp bl, 3
    jb  alu_repro
    lea dx, msg_aprobado
    call imprimir_pantalla
    jmp alu_out

alu_repro:
    lea dx, msg_reprobo
    call imprimir_pantalla

alu_out:
    mov al, bl                 ; devolver aciertos al main
    pop dx
    pop bx
    pop ax
    ret
jugar_alu endp

end
