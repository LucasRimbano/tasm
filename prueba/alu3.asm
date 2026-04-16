;============================================================
; UNIDAD: ARITMETICO-LOGICA (ALU)
;------------------------------------------------------------
; - Igual formato que MEMORIA PRINCIPAL
; - Usa temporizador 10 s (INT 1Ah)
; - Usa pantalla con mensaje de estado (Correcto / Incorrecto / Tiempo)
; - No depende de carga.asm
;============================================================

.8086
.model small
.stack 100h

; --- Librerías externas ---
extrn imprimir_pantalla:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn actualizar_puntaje:proc
extrn puntaje_total:byte
extrn cls_azul_10h:proc

.data
msg_intro      db 0dh,0ah,"[UNIDAD: ARITMETICO-LOGICA (ALU)]",0dh,0ah,'$'
msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto!",0dh,0ah,'$'
msg_tiempo     db 0dh,0ah,"Tiempo agotado: se toma como INCORRECTA.",0dh,0ah,'$'
msg_final      db 0dh,0ah,"Fin de la unidad de ALU!",0dh,0ah,'$'
msg_aprobado_1 db 0dh,0ah,"Excelente! Dominio solido de la ALU.",0dh,0ah,'$'
msg_reprobo_1  db 0dh,0ah,"Repasar operaciones aritmeticas y logicas.",0dh,0ah,'$'
msg_invalida   db 0dh,0ah,"Solo se permiten A, B o C.",0dh,0ah,'$'
nl             db 0dh,0ah,'$'

preg1 db 0dh,0ah,"1) Que funcion cumple la ALU?",0dh,0ah
      db "A) Controlar la memoria",0dh,0ah
      db "B) Ejecutar operaciones aritmeticas y logicas",0dh,0ah
      db "C) Coordinar perifericos",0dh,0ah,'$'

preg2 db 0dh,0ah,"2) Que registros intervienen en la ALU?",0dh,0ah
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
;============================================================
; PANTALLA: muestra mensaje de estado y próxima pregunta
; EN: DX = mensaje de estado, BX = pregunta siguiente
;============================================================
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
    pop dx
    call imprimir_pantalla      ; mensaje (Correcto / Incorrecto / Tiempo)
    lea dx, nl
    call imprimir_pantalla
    mov dx, bx
    call imprimir_pantalla      ; siguiente pregunta
    pop bx
    pop ax
    ret
alu_screen_next_with_status endp

;============================================================
; Lector con timeout (10 s)
; OUT: AL='A'/'B'/'C' → válida,  AL=0 → timeout
;============================================================
public leer_abc_timeout_alu
leer_abc_timeout_alu proc
    push bx
    push cx
    push dx

    mov ah,00h
    int 1Ah
    mov bx,dx            ; tiempo inicial

bucle:
    mov ah,01h
    int 16h
    jz revisar_tiempo

    mov ah,00h
    int 16h              ; leer tecla

    ; convertir a mayúscula
    cmp al,'a'
    jb validar
    cmp al,'z'
    ja validar
    and al,11011111b

validar:
    cmp al,'A'
    je listo
    cmp al,'B'
    je listo
    cmp al,'C'
    je listo
    mov al,0FFh          ; tecla inválida
    jmp salir

revisar_tiempo:
    mov ah,00h
    int 1Ah
    mov cx,dx
    sub cx,bx
    cmp cx,182
    jb bucle
    mov al,0
    jmp salir

listo:
salir:
    pop dx
    pop cx
    pop bx
    ret
leer_abc_timeout_alu endp

;============================================================
; PROCESO PRINCIPAL: JUGAR ALU
;============================================================
public jugar_alu
jugar_alu proc
    push ax
    push bx
    push dx
    mov bl,0

    call cls_azul_10h
    call actualizar_puntaje
    lea dx,msg_intro
    call imprimir_pantalla
    lea dx,preg1
    call imprimir_pantalla
    call sonido_presentacion

;==================== PREGUNTA 1 ======================
p1:
    call leer_abc_timeout_alu
    cmp al,0
    je p1_tarde
    cmp al,0FFh
    je p1_invalida
    cmp al,'B'
    je p1_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg2
    call alu_screen_next_with_status
    jmp p2
p1_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg2
    call alu_screen_next_with_status
    jmp p2
p1_invalida:
    call sonido_error
    lea dx,msg_invalida
    lea bx,preg1
    call alu_screen_next_with_status
    jmp p1
p1_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg2
    call alu_screen_next_with_status

;==================== PREGUNTA 2 ======================
p2:
    call leer_abc_timeout_alu
    cmp al,0
    je p2_tarde
    cmp al,0FFh
    je p2_invalida
    cmp al,'A'
    je p2_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg3
    call alu_screen_next_with_status
    jmp p3
p2_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg3
    call alu_screen_next_with_status
    jmp p3
p2_invalida:
    call sonido_error
    lea dx,msg_invalida
    lea bx,preg2
    call alu_screen_next_with_status
    jmp p2
p2_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg3
    call alu_screen_next_with_status

;==================== PREGUNTA 3 ======================
p3:
    call leer_abc_timeout_alu
    cmp al,0
    je p3_tarde
    cmp al,0FFh
    je p3_invalida
    cmp al,'B'
    je p3_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg4
    call alu_screen_next_with_status
    jmp p4
p3_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg4
    call alu_screen_next_with_status
    jmp p4
p3_invalida:
    call sonido_error
    lea dx,msg_invalida
    lea bx,preg3
    call alu_screen_next_with_status
    jmp p3
p3_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg4
    call alu_screen_next_with_status

;==================== PREGUNTA 4 ======================
p4:
    call leer_abc_timeout_alu
    cmp al,0
    je p4_tarde
    cmp al,0FFh
    je p4_invalida
    cmp al,'A'
    je p4_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg5
    call alu_screen_next_with_status
    jmp p5
p4_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg5
    call alu_screen_next_with_status
    jmp p5
p4_invalida:
    call sonido_error
    lea dx,msg_invalida
    lea bx,preg4
    call alu_screen_next_with_status
    jmp p4
p4_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg5
    call alu_screen_next_with_status

;==================== PREGUNTA 5 ======================
p5:
    call leer_abc_timeout_alu
    cmp al,0
    je p5_tarde
    cmp al,0FFh
    je p5_invalida
    cmp al,'A'
    je p5_ok
    call sonido_error
    lea dx,msg_incorrecto
    jmp alu_fin
p5_tarde:
    call sonido_error
    lea dx,msg_tiempo
    jmp alu_fin
p5_invalida:
    call sonido_error
    lea dx,msg_invalida
    lea bx,preg5
    call alu_screen_next_with_status
    jmp p5
p5_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto

;==================== FINAL ===========================
alu_fin:
    call cls_azul_10h
    call actualizar_puntaje
    lea dx,msg_final
    call imprimir_pantalla
    cmp bl,3
    jb alu_repro
    lea dx,msg_aprobado_1
    call imprimir_pantalla
    jmp alu_out
alu_repro:
    lea dx,msg_reprobo_1
    call imprimir_pantalla
alu_out:
    pop dx
    pop bx
    pop ax
    ret
jugar_alu endp

end
