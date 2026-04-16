;============================================================
; UNIDAD: ARITMETICO-LOGICA (ALU)
; - Preguntas 1 a 4: teclado con timeout (INT 1Ah)
; - Pregunta 5: SOLO mouse (leer_opcion_mouse_abc)
;============================================================

.8086
.model small
.stack 100h

; --- externas ---
extrn imprimir_pantalla:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn actualizar_puntaje:proc
extrn puntaje_total:byte
extrn cls_azul_10h:proc
extrn leer_opcion_mouse_abc:proc



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

preg1 db 0dh,0ah,"1)   Que funcion cumple la ALU?",0dh,0ah
      db "A)     Controlar la memoria",0dh,0ah
      db "B)     Ejecutar operaciones aritmeticas y logicas",0dh,0ah
      db "C)     Coordinar perifericos",0dh,0ah,'$'

preg2 db 0dh,0ah,"2) Que registros intervienen en la ALU?",0dh,0ah
      db "A)     AX, BX, CX, DX",0dh,0ah
      db "B)     CS, DS, SS, ES",0dh,0ah
      db "C)     IP, SP, BP",0dh,0ah,'$'

preg3 db 0dh,0ah,"3) Que indica el bit de carry (CF)?",0dh,0ah
      db "A)     Error de programa",0dh,0ah
      db "B)     Desbordamiento de suma/resta",0dh,0ah
      db "C)     Activa la memoria",0dh,0ah,'$'

preg4 db 0dh,0ah,"4) Cual instruccion realiza una suma?",0dh,0ah
      db "A)     ADD",0dh,0ah
      db "B)     CMP",0dh,0ah
      db "C)     MOV",0dh,0ah,'$'

preg5 db 0dh,0ah,"5) Cual instruccion realiza una comparacion?",0dh,0ah
      db "A)     CMP",0dh,0ah
      db "B)     XOR",0dh,0ah
      db "C)     JMP",0dh,0ah,'$'

.code

;------------------------------------------------------------
; PANTALLA: muestra mensaje de estado y próxima pregunta
; EN: DX = mensaje de estado, BX = puntero a pregunta siguiente
;------------------------------------------------------------
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

    pop dx                    ; mensaje estado
    call imprimir_pantalla

    lea dx, nl
    call imprimir_pantalla

    mov dx, bx                ; pregunta siguiente
    call imprimir_pantalla

    pop bx
    pop ax
    ret
alu_screen_next_with_status endp

;------------------------------------------------------------
; Lector con timeout (10 s) para A/B/C
; OUT:
;   AL = 'A','B','C' → OK
;   AL = 0           → tiempo agotado
;   AL = 0FFh        → tecla inválida
;------------------------------------------------------------
public leer_abc_timeout_alu
leer_abc_timeout_alu proc
    push bx
    push cx
    push dx

    ; leer tiempo inicial
    mov ah, 00h
    int 1Ah
    mov bx, dx

bucle_alu:
    ; hay tecla?
    mov ah, 01h
    int 16h
    jz  revisar_tiempo

    ; leer tecla
    mov ah, 00h
    int 16h              ; AL = ASCII

    ; convertir a mayúscula si es minúscula
    cmp al, 'a'
    jb  validar
    cmp al, 'z'
    ja  validar
    and al, 11011111b    ; limpiar bit de minúscula

validar:
    cmp al, 'A'
    je  listo
    cmp al, 'B'
    je  listo
    cmp al, 'C'
    je  listo
    mov al, 0FFh         ; inválida
    jmp salir

revisar_tiempo:
    mov ah, 00h
    int 1Ah
    mov cx, dx
    sub cx, bx           ; diferencia en ticks
    cmp cx, 182          ; ~10 s
    jb  bucle_alu
    mov al, 0            ; timeout
    jmp salir

listo:
    ; AL ya tiene 'A','B' o 'C'
salir:
    pop dx
    pop cx
    pop bx
    ret
leer_abc_timeout_alu endp

;------------------------------------------------------------
; PROCESO PRINCIPAL: JUGAR ALU
;------------------------------------------------------------
public jugar_alu
jugar_alu proc
    push ax
    push bx
    push dx

    mov bl, 0       ; aciertos en esta unidad

    call cls_azul_10h
    call actualizar_puntaje
    lea dx, msg_intro
    call imprimir_pantalla
    lea dx, preg1
    call imprimir_pantalla
    call sonido_presentacion

;==================== PREGUNTA 1 ======================
p1:
    call leer_abc_timeout_alu
    cmp al, 0
    je  p1_tarde
    cmp al, 0FFh
    je  p1_invalida
    cmp al, 'B'
    je  p1_ok

    ; incorrecta
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg2
    call alu_screen_next_with_status
    jmp p2

p1_tarde:
    call sonido_error
    lea dx, msg_tiempo
    lea bx, preg2
    call alu_screen_next_with_status
    jmp p2

p1_invalida:
    call sonido_error
    lea dx, msg_invalida
    lea bx, preg1
    call alu_screen_next_with_status
    jmp p1

p1_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg2
    call alu_screen_next_with_status

;==================== PREGUNTA 2 ======================
p2:
    call leer_abc_timeout_alu
    cmp al, 0
    je  p2_tarde
    cmp al, 0FFh
    je  p2_invalida
    cmp al, 'A'
    je  p2_ok

    ; incorrecta
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg3
    call alu_screen_next_with_status
    jmp p3

p2_tarde:
    call sonido_error
    lea dx, msg_tiempo
    lea bx, preg3
    call alu_screen_next_with_status
    jmp p3

p2_invalida:
    call sonido_error
    lea dx, msg_invalida
    lea bx, preg2
    call alu_screen_next_with_status
    jmp p2

p2_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg3
    call alu_screen_next_with_status

;==================== PREGUNTA 3 ======================
p3:
    call leer_abc_timeout_alu
    cmp al, 0
    je  p3_tarde
    cmp al, 0FFh
    je  p3_invalida
    cmp al, 'B'
    je  p3_ok

    ; incorrecta
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg4
    call alu_screen_next_with_status
    jmp p4

p3_tarde:
    call sonido_error
    lea dx, msg_tiempo
    lea bx, preg4
    call alu_screen_next_with_status
    jmp p4

p3_invalida:
    call sonido_error
    lea dx, msg_invalida
    lea bx, preg3
    call alu_screen_next_with_status
    jmp p3

p3_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg4
    call alu_screen_next_with_status

;==================== PREGUNTA 4 ======================
p4:
    call leer_abc_timeout_alu
    cmp al, 0
    je  p4_tarde
    cmp al, 0FFh
    je  p4_invalida
    cmp al, 'A'
    je  p4_ok

    ; incorrecta
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg5
    call alu_screen_next_with_status
    jmp alu_p5

p4_tarde:
    call sonido_error
    lea dx, msg_tiempo
    lea bx, preg5
    call alu_screen_next_with_status
    jmp alu_p5

p4_invalida:
    call sonido_error
    lea dx, msg_invalida
    lea bx, preg4
    call alu_screen_next_with_status
    jmp p4

p4_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg5
    call alu_screen_next_with_status

;==================== PREGUNTA 5 (con MOUSE) ======================
; Ya tenés la P5 mostrada en pantalla por alu_screen_next_with_status

alu_p5:
  
    ; Leer respuesta con el mouse
    call leer_opcion_mouse_abc      ; AL = 'A' / 'B' / 'C' (o teclado fallback)
  

alu_p5_eval:
    cmp al, 'A'
    jne alu_p5_mal                  ; SOLO 'A' es correcta

alu_p5_ok:
    inc bl                          ; aciertos en esta unidad
    inc byte ptr [puntaje_total]    ; puntaje global
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla
    jmp alu_fin

alu_p5_mal:
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp alu_fin

;==================== FINAL ==========================
alu_fin:
    mov ax, 2 ; ocultamos puntero mouse 
    int 33h 

    call cls_azul_10h
    call actualizar_puntaje
    lea dx, msg_final
    call imprimir_pantalla

    cmp bl, 3
    jb  alu_repro

    lea dx, msg_aprobado_1
    call imprimir_pantalla
    jmp alu_out

alu_repro:
    lea dx, msg_reprobo_1
    call imprimir_pantalla

alu_out:
    pop dx
    pop bx
    pop ax
    ret
jugar_alu endp

end
