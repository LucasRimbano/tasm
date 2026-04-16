;============================================================
; UNIDAD: INTERRUPCIONES
;------------------------------------------------------------
; - Igual formato visual que ALU y MEMORIA
; - Preguntas 1 a 4: teclado con timeout (INT 1Ah)
; - Pregunta 5: SOLO mouse (leer_opcion_mouse_abc)
; - Muestra Correcto/Incorrecto/Tiempo/Inválido arriba
; - Puntaje global con HUD azul
;============================================================

.8086
.model small
.stack 100h

extrn imprimir_pantalla:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn actualizar_puntaje:proc
extrn puntaje_total:byte
extrn cls_azul_10h:proc
extrn leer_opcion_mouse_abc:proc

;--- mismas filas que en la librería de mouse ----------------
A_ROW  equ 9
B_ROW  equ 10
C_ROW  equ 11
ROW_H  equ 8

A_Y_TOP   equ (A_ROW * ROW_H)
A_Y_BOT   equ (A_ROW * ROW_H + ROW_H - 1)
B_Y_TOP   equ (B_ROW * ROW_H)
B_Y_BOT   equ (B_ROW * ROW_H + ROW_H - 1)
C_Y_TOP   equ (C_ROW * ROW_H)
C_Y_BOT   equ (C_ROW * ROW_H + ROW_H - 1)

.data
msg_intro      db 0dh,0ah,"[UNIDAD: INTERRUPCIONES]",0dh,0ah,'$'

msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto!",0dh,0ah,'$'
msg_tiempo     db 0dh,0ah,"Tiempo agotado: se toma como INCORRECTA.",0dh,0ah,'$'
msg_invalido   db 0dh,0ah,"Solo se permiten las letras A, B o C.",0dh,0ah,'$'
msg_final      db 0dh,0ah,"Fin de la unidad de INTERRUPCIONES!",0dh,0ah,'$'
msg_aprobado   db 0dh,0ah,"Excelente! Dominio solido de las interrupciones.",0dh,0ah,'$'
msg_reprobo    db 0dh,0ah,"Repasar interrupciones.",0dh,0ah,'$'
nl             db 0dh,0ah,'$'

preg1 db 0dh,0ah,"1) Que hace una interrupcion?",0dh,0ah
      db "A)       Detiene el CPU permanentemente",0dh,0ah
      db "B)       Suspende el flujo y atiende un evento",0dh,0ah
      db "C)       Reinicia el programa desde cero",0dh,0ah,'$'

preg2 db 0dh,0ah,"2) Que instruccion finaliza una ISR?",0dh,0ah
      db "A)       RET",0dh,0ah
      db "B)       IRET",0dh,0ah
      db "C)       JMP",0dh,0ah,'$'

preg3 db 0dh,0ah,"3) Que hace la instruccion STI?",0dh,0ah
      db "A)       Deshabilita las interrupciones",0dh,0ah
      db "B)       Habilita las interrupciones enmascarables",0dh,0ah
      db "C)       Llama a una ISR directamente",0dh,0ah,'$'

preg4 db 0dh,0ah,"4) Que tipo de interrupcion NO puede ser enmascarada?",0dh,0ah
      db "A)       NMI",0dh,0ah
      db "B)       INT 21h",0dh,0ah
      db "C)       INT 10h",0dh,0ah,'$'

preg5 db 0dh,0ah,"5) Que registro usa el CPU para saber si puede atender una interrupcion?",0dh,0ah
      db "A)       AX",0dh,0ah
      db "B)       FLAGS",0dh,0ah
      db "C)       CS",0dh,0ah,'$'

.code
;------------------------------------------------------------
; Helper: pantalla con estado + siguiente pregunta
; EN: DX = ptr mensaje estado, BX = ptr pregunta siguiente
;------------------------------------------------------------
int_screen_status_y_preg proc
    push ax
    push bx
    push dx

    call cls_azul_10h
    call actualizar_puntaje

    ; título de la unidad
    lea dx, msg_intro
    call imprimir_pantalla

    ; línea en blanco debajo del título
    lea dx, nl
    call imprimir_pantalla

    ; mensaje de estado
    pop dx
    call imprimir_pantalla

    ; UNA sola línea en blanco antes de la pregunta
    lea dx, nl
    call imprimir_pantalla

    ; pregunta + opciones
    mov dx, bx
    call imprimir_pantalla

    pop bx
    pop ax
    ret
int_screen_status_y_preg endp

;------------------------------------------------------------
; Lector con timeout
;------------------------------------------------------------
public leer_abc_timeout_interrupcion
leer_abc_timeout_interrupcion proc
    push bx
    push cx
    push dx

    mov ah,00h
    int 1Ah
    mov bx,dx

bucle:
    mov ah,01h
    int 16h
    jz revisar_tiempo

    mov ah,00h
    int 16h
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
    mov al,0FFh
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
leer_abc_timeout_interrupcion endp

;------------------------------------------------------------
; PROCESO PRINCIPAL
;------------------------------------------------------------
public jugar_int
jugar_int proc
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

; P1
p1:
    call leer_abc_timeout_interrupcion
    cmp al,0
    je  p1_tarde
    cmp al,0FFh
    je  p1_inv
    cmp al,'B'
    je  p1_ok

    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg2
    call int_screen_status_y_preg
    jmp p2
p1_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg2
    call int_screen_status_y_preg
    jmp p2
p1_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg1
    call int_screen_status_y_preg
    jmp p1
p1_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg2
    call int_screen_status_y_preg

; P2
p2:
    call leer_abc_timeout_interrupcion
    cmp al,0
    je  p2_tarde
    cmp al,0FFh
    je  p2_inv
    cmp al,'B'
    je  p2_ok

    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg3
    call int_screen_status_y_preg
    jmp p3
p2_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg3
    call int_screen_status_y_preg
    jmp p3
p2_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg2
    call int_screen_status_y_preg
    jmp p2
p2_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg3
    call int_screen_status_y_preg

; P3
p3:
    call leer_abc_timeout_interrupcion
    cmp al,0
    je  p3_tarde
    cmp al,0FFh
    je  p3_inv
    cmp al,'B'
    je  p3_ok

    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg4
    call int_screen_status_y_preg
    jmp p4
p3_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg4
    call int_screen_status_y_preg
    jmp p4
p3_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg3
    call int_screen_status_y_preg
    jmp p3
p3_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg4
    call int_screen_status_y_preg

; P4
p4:
    call leer_abc_timeout_interrupcion
    cmp al,0
    je  p4_tarde
    cmp al,0FFh
    je  p4_inv
    cmp al,'A'
    je  p4_ok

    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg5
    call int_screen_status_y_preg
    jmp p5
p4_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg5
    call int_screen_status_y_preg
    jmp p5
p4_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg4
    call int_screen_status_y_preg
    jmp p4
p4_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg5
    call int_screen_status_y_preg

;------------------------------------------------------------
; P5 (solo mouse, usando Y real para decidir A/B/C)
;------------------------------------------------------------
p5:
    ; usamos la librería para inicializar/mostrar/limitar mouse
    call leer_opcion_mouse_abc      ; AL se ignora, nos importa Y

    ; leer posición actual del mouse
    mov ax, 3
    int 33h              ; BX=botones, CX=X, DX=Y
    mov ax, dx           ; AX = Y en píxeles

    ; ¿fuera del bloque A..C?  → volver a preguntar
    cmp ax, A_Y_TOP
    jb  p5               ; por encima de A
    cmp ax, C_Y_BOT
    ja  p5               ; por debajo de C

    ; ¿en la banda de B?  → correcta
    cmp ax, B_Y_TOP
    jb  p5_mal           ; está en A
    cmp ax, B_Y_BOT
    jbe p5_ok            ; dentro de B

    ; si no está en B, pero está entre A_Y_TOP y C_Y_BOT,
    ; solo queda que esté en C  → incorrecto
    jmp p5_mal

p5_ok:
    inc bl                          ; aciertos en esta unidad
    inc byte ptr [puntaje_total]    ; puntaje global
    call actualizar_puntaje
    lea dx,msg_correcto
    call imprimir_pantalla
    jmp int_final

p5_mal:
    call sonido_error
    lea dx,msg_incorrecto
    call imprimir_pantalla
    jmp int_final

; FINAL
int_final:
    mov ax,2
    int 33h

    call cls_azul_10h
    call actualizar_puntaje
    lea dx,msg_final
    call imprimir_pantalla
    cmp bl,3
    jb  int_repro
    lea dx,msg_aprobado
    call imprimir_pantalla
    jmp int_fin
int_repro:
    lea dx,msg_reprobo
    call imprimir_pantalla
int_fin:
    mov al,bl
    pop dx
    pop bx
    pop ax
    ret
jugar_int endp

end
