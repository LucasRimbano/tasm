.8086
.model small
.stack 100h

extrn imprimir_pantalla:proc
extrn leer_caracter_abc:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn actualizar_puntaje:proc
extrn puntaje_total:byte
extrn cls_azul_10h:proc
extrn cambiar_color_amarillo:proc


.data
msg_intro      db 0dh,0ah,"[UNIDAD: ARITMETICO-LOGICA (ALU)]",0dh,0ah,'$'

msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto!",0dh,0ah,'$'
msg_final      db 0dh,0ah,"Fin de la unidad de ALU!",0dh,0ah,'$'
msg_aprobado   db 0dh,0ah,"Excelente! Dominio solido de la ALU.",0dh,0ah,'$'
msg_reprobo    db 0dh,0ah,"Repasar operaciones aritmeticas y logicas.",0dh,0ah,'$'
nl             db 0dh,0ah,'$'     ; separador/espacio


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


; Helper local: limpia + HUD + título + pregunta
; EN: DX = ptr a PREGUNTA ($)

alu_screen_pregunta proc
    push ax
    push dx
    call cls_azul_10h
    call actualizar_puntaje
    lea dx, msg_intro
    call imprimir_pantalla
    lea dx, nl
    call imprimir_pantalla
    pop dx
    call imprimir_pantalla
    pop ax
    ret
alu_screen_pregunta endp


; Helper local: limpia + HUD + título + estado + pregunta siguiente
; EN: DX = ptr a MENSAJE (Correcto/Incorrecto, $)
;     BX = ptr a PREGUNTA SIGUIENTE ($)

alu_screen_next_with_status proc
    push ax
    push bx
    push dx
    call cls_azul_10h
    call actualizar_puntaje
    lea dx, msg_intro
    call imprimir_pantalla
    lea dx, nl
    call imprimir_pantalla
    pop dx                 ; estado
    call imprimir_pantalla
    lea dx, nl
    call imprimir_pantalla
    mov dx, bx             ; pregunta siguiente
    call imprimir_pantalla
    pop bx
    pop ax
    ret
alu_screen_next_with_status endp

public jugar_alu
jugar_alu proc
    push ax
    push bx
    push dx

    mov bl, 0                ; contador local de aciertos (0..5)

    ; Pantalla inicial con P1
    lea dx, preg1
    call alu_screen_pregunta
    call sonido_presentacion

;==================== PREGUNTA 1 ======================
    call leer_caracter_abc
    cmp al, 'B'
    je  alu_ok1
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg2
    call alu_screen_next_with_status
    jmp alu_p2
alu_ok1:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg2
    call alu_screen_next_with_status

;==================== PREGUNTA 2 ======================
alu_p2:
    call leer_caracter_abc
    cmp al, 'A'
    je  alu_ok2
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg3
    call alu_screen_next_with_status
    jmp alu_p3
alu_ok2:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg3
    call alu_screen_next_with_status

;==================== PREGUNTA 3 ======================
alu_p3:
    call leer_caracter_abc
    cmp al, 'B'
    je  alu_ok3
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg4
    call alu_screen_next_with_status
    jmp alu_p4
alu_ok3:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg4
    call alu_screen_next_with_status

;==================== PREGUNTA 4 ======================
alu_p4:
    call leer_caracter_abc
    cmp al, 'A'
    je  alu_ok4
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg5
    call alu_screen_next_with_status
    jmp alu_p5
alu_ok4:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg5
    call alu_screen_next_with_status

;==================== PREGUNTA 5 ======================
alu_p5:
    call leer_caracter_abc
    cmp al, 'A'
    je  alu_ok5
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp alu_fin_pantalla
alu_ok5:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

;==================== FINAL ===========================
alu_fin_pantalla:
    call cls_azul_10h
    call actualizar_puntaje
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
