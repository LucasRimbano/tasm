;============================================================
; UNIDAD: INTERRUPCIONES
;------------------------------------------------------------
; - Igual formato visual que ALU y MEMORIA
; - Timeout 10 s con INT 1Ah
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

;================= PREGUNTAS Y OPCIONES ======================
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
;============================================================
; Helper: pantalla con estado + siguiente pregunta y opciones
; EN: DX = ptr mensaje estado, SI = ptr pregunta, BX = ptr opciones
;============================================================
int_screen_status_y_preg proc
    push ax
    push bx
    push si
    push dx
    call cls_azul_10h
    call actualizar_puntaje
    lea dx,msg_intro
    call imprimir_pantalla
    lea dx,nl
    call imprimir_pantalla
    pop dx
    call imprimir_pantalla     ; mensaje estado
    lea dx,nl
    call imprimir_pantalla
    mov dx,si
    call imprimir_pantalla     ; pregunta
    mov dx,bx
    call imprimir_pantalla     ; opciones
    pop si
    pop bx
    pop ax
    ret
int_screen_status_y_preg endp

;============================================================
; Lector con timeout (10 s)
; OUT: AL='A'/'B'/'C' → válida, AL=0 → timeout, AL=0FFh → inválida
;============================================================
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

;============================================================
; PROCESO PRINCIPAL: JUGAR INTERRUPCIONES
;============================================================
public jugar_int
jugar_int proc
    push ax
    push bx
    push dx
    push si
    mov bl,0

    call cls_azul_10h
    call actualizar_puntaje
    lea dx,msg_intro
    call imprimir_pantalla
    lea dx,preg1
    call imprimir_pantalla
    lea dx,opc1
    call imprimir_pantalla
    call sonido_presentacion

;==================== PREGUNTA 1 ======================
p1:
    call leer_abc_timeout_interrupcion
    cmp al,0
    je  p1_tarde
    cmp al,0FFh
    je  p1_inv
    cmp al,[resp1]
    je  p1_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea si,preg2
    lea bx,opc2
    call int_screen_status_y_preg
    jmp p2
p1_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea si,preg2
    lea bx,opc2
    call int_screen_status_y_preg
    jmp p2
p1_inv:
    call sonido_error
    lea dx,msg_invalido
    lea si,preg1
    lea bx,opc1
    call int_screen_status_y_preg
    jmp p1
p1_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea si,preg2
    lea bx,opc2
    call int_screen_status_y_preg

;==================== PREGUNTA 2 ======================
p2:
    call leer_abc_timeout_interrupcion
    cmp al,0
    je  p2_tarde
    cmp al,0FFh
    je  p2_inv
    cmp al,[resp2]
    je  p2_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea si,preg3
    lea bx,opc3
    call int_screen_status_y_preg
    jmp p3
p2_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea si,preg3
    lea bx,opc3
    call int_screen_status_y_preg
    jmp p3
p2_inv:
    call sonido_error
    lea dx,msg_invalido
    lea si,preg2
    lea bx,opc2
    call int_screen_status_y_preg
    jmp p2
p2_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea si,preg3
    lea bx,opc3
    call int_screen_status_y_preg

;==================== PREGUNTA 3 ======================
p3:
    call leer_abc_timeout_interrupcion
    cmp al,0
    je  p3_tarde
    cmp al,0FFh
    je  p3_inv
    cmp al,[resp3]
    je  p3_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea si,preg4
    lea bx,opc4
    call int_screen_status_y_preg
    jmp p4
p3_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea si,preg4
    lea bx,opc4
    call int_screen_status_y_preg
    jmp p4
p3_inv:
    call sonido_error
    lea dx,msg_invalido
    lea si,preg3
    lea bx,opc3
    call int_screen_status_y_preg
    jmp p3
p3_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea si,preg4
    lea bx,opc4
    call int_screen_status_y_preg

;==================== PREGUNTA 4 ======================
p4:
    call leer_abc_timeout_interrupcion
    cmp al,0
    je  p4_tarde
    cmp al,0FFh
    je  p4_inv
    cmp al,[resp4]
    je  p4_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea si,preg5
    lea bx,opc5
    call int_screen_status_y_preg
    jmp p5
p4_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea si,preg5
    lea bx,opc5
    call int_screen_status_y_preg
    jmp p5
p4_inv:
    call sonido_error
    lea dx,msg_invalido
    lea si,preg4
    lea bx,opc4
    call int_screen_status_y_preg
    jmp p4
p4_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea si,preg5
    lea bx,opc5
    call int_screen_status_y_preg

;==================== PREGUNTA 5 ======================
p5:
    call leer_abc_timeout_interrupcion
    cmp al,0
    je  p5_tarde
    cmp al,0FFh
    je  p5_inv
    cmp al,[resp5]
    je  p5_ok
    call sonido_error
    lea dx,msg_incorrecto
    jmp int_final
p5_tarde:
    call sonido_error
    lea dx,msg_tiempo
    jmp int_final
p5_inv:
    call sonido_error
    lea dx,msg_invalido
    lea si,preg5
    lea bx,opc5
    call int_screen_status_y_preg
    jmp p5
p5_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto

;==================== FINAL ===========================
int_final:
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
    pop si
    pop dx
    pop bx
    pop ax
    ret
jugar_int endp

end
