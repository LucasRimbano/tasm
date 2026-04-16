;============================================================
; UNIDAD: MEMORIA PRINCIPAL (MEMORIA.ASM)
;------------------------------------------------------------
; - Preguntas 1 a 4: teclado con timeout (INT 1Ah)
; - Pregunta 5: SOLO mouse (leer_opcion_mouse_abc)
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
extrn leer_opcion_mouse_abc:proc    ; <<-- agregado para la P5 con mouse


.data
msg_intro_mem db 0dh,0ah,"[UNIDAD: MEMORIA PRINCIPAL]",0dh,0ah,'$'

msg_ok_mem    db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_bad_mem   db 0dh,0ah,"Incorrecto!",0dh,0ah,'$'
msg_time_mem  db 0dh,0ah,"Tiempo agotado: se toma como INCORRECTA.",0dh,0ah,'$'
msg_inv_mem   db 0dh,0ah,"Solo se permiten las letras A, B o C.",0dh,0ah,'$'
msg_fin_mem   db 0dh,0ah,"Fin de la unidad de MEMORIA!",0dh,0ah,'$'
msg_apr_mem   db 0dh,0ah,"Aprobado! Excelente manejo de la memoria.",0dh,0ah,'$'
msg_rep_mem   db 0dh,0ah,"Repasar conceptos de RAM, ROM y Buses.",0dh,0ah,'$'
nl            db 0dh,0ah,'$'

preg1_mem db 0dh,0ah,"1) Que tipo de memoria es volatil?",0dh,0ah
          db "A)    ROM",0dh,0ah,"B)    RAM",0dh,0ah,"C)    Disco Duro",0dh,0ah,'$'
preg2_mem db 0dh,0ah,"2)    Donde se almacenan datos en ejecucion?",0dh,0ah
          db "A)     RAM",0dh,0ah,"B)     CPU",0dh,0ah,"C)    Registro de Control",0dh,0ah,'$'
preg3_mem db 0dh,0ah,"3) Que sucede con los datos de la RAM al apagar la PC?",0dh,0ah
          db "A)     Se guardan en ROM",0dh,0ah,"B)    Se pierden",0dh,0ah,"C)    Se copian al cache",0dh,0ah,'$'
preg4_mem db 0dh,0ah,"4) Que bus se usa para acceder a direcciones de memoria?",0dh,0ah
          db "A)    Bus de Datos",0dh,0ah,"B)    Bus de Control",0dh,0ah,"C)    Bus de Direcciones",0dh,0ah,'$'
preg5_mem db 0dh,0ah,"5) Cual de estas es NO volatil?",0dh,0ah
          db "A)    ROM",0dh,0ah,"B)    RAM",0dh,0ah,"C)    Cache",0dh,0ah,'$'

.code
;============================================================
; Helper: pantalla con estado + siguiente pregunta
; EN: DX = ptr mensaje, BX = ptr pregunta siguiente
;============================================================
mem_screen_next_with_status proc
    push ax
    push bx
    push dx
    call cls_azul_10h
    call actualizar_puntaje
    lea dx,msg_intro_mem
    call imprimir_pantalla
    lea dx,nl
    call imprimir_pantalla
    pop dx
    call imprimir_pantalla      ; mensaje Correcto / Incorrecto / Tiempo
    lea dx,nl
    call imprimir_pantalla
    mov dx,bx
    call imprimir_pantalla      ; siguiente pregunta
    pop bx
    pop ax
    ret
mem_screen_next_with_status endp

;============================================================
; Lector con timeout (10 s)
; OUT: AL='A'/'B'/'C' → válida, AL=0 → timeout, AL=0FFh → inválida
;============================================================
public leer_abc_timeout_memoria
leer_abc_timeout_memoria proc
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
leer_abc_timeout_memoria endp

;============================================================
; PROCESO PRINCIPAL
;============================================================
public jugar_mem
jugar_mem proc
    push ax
    push bx
    push dx
    mov bl,0

    call cls_azul_10h
    call actualizar_puntaje
    lea dx,msg_intro_mem
    call imprimir_pantalla
    lea dx,preg1_mem
    call imprimir_pantalla
    call sonido_presentacion

;==================== PREGUNTA 1 ==============================
p1:
    call leer_abc_timeout_memoria
    cmp al,0
    je  p1_tarde
    cmp al,0FFh
    je  p1_inv
    cmp al,'B'
    je  p1_ok
    call sonido_error
    lea dx,msg_bad_mem
    lea bx,preg2_mem
    call mem_screen_next_with_status
    jmp p2
p1_tarde:
    call sonido_error
    lea dx,msg_time_mem
    lea bx,preg2_mem
    call mem_screen_next_with_status
    jmp p2
p1_inv:
    call sonido_error
    lea dx,msg_inv_mem
    lea bx,preg1_mem
    call mem_screen_next_with_status
    jmp p1
p1_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_ok_mem
    lea bx,preg2_mem
    call mem_screen_next_with_status

;==================== PREGUNTA 2 ==============================
p2:
    call leer_abc_timeout_memoria
    cmp al,0
    je  p2_tarde
    cmp al,0FFh
    je  p2_inv
    cmp al,'A'
    je  p2_ok
    call sonido_error
    lea dx,msg_bad_mem
    lea bx,preg3_mem
    call mem_screen_next_with_status
    jmp p3
p2_tarde:
    call sonido_error
    lea dx,msg_time_mem
    lea bx,preg3_mem
    call mem_screen_next_with_status
    jmp p3
p2_inv:
    call sonido_error
    lea dx,msg_inv_mem
    lea bx,preg2_mem
    call mem_screen_next_with_status
    jmp p2
p2_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_ok_mem
    lea bx,preg3_mem
    call mem_screen_next_with_status

;==================== PREGUNTA 3 ==============================
p3:
    call leer_abc_timeout_memoria
    cmp al,0
    je  p3_tarde
    cmp al,0FFh
    je  p3_inv
    cmp al,'B'
    je  p3_ok
    call sonido_error
    lea dx,msg_bad_mem
    lea bx,preg4_mem
    call mem_screen_next_with_status
    jmp p4
p3_tarde:
    call sonido_error
    lea dx,msg_time_mem
    lea bx,preg4_mem
    call mem_screen_next_with_status
    jmp p4
p3_inv:
    call sonido_error
    lea dx,msg_inv_mem
    lea bx,preg3_mem
    call mem_screen_next_with_status
    jmp p3
p3_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_ok_mem
    lea bx,preg4_mem
    call mem_screen_next_with_status

;==================== PREGUNTA 4 ==============================
p4:
    call leer_abc_timeout_memoria
    cmp al,0
    je  p4_tarde
    cmp al,0FFh
    je  p4_inv
    cmp al,'C'
    je  p4_ok
    call sonido_error
    lea dx,msg_bad_mem
    lea bx,preg5_mem
    call mem_screen_next_with_status
    jmp memoria_p5
p4_tarde:
    call sonido_error
    lea dx,msg_time_mem
    lea bx,preg5_mem
    call mem_screen_next_with_status
    jmp memoria_p5
p4_inv:
    call sonido_error
    lea dx,msg_inv_mem
    lea bx,preg4_mem
    call mem_screen_next_with_status
    jmp p4
p4_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_ok_mem
    lea bx,preg5_mem
    call mem_screen_next_with_status

;==================== PREGUNTA 5 (SOLO MOUSE) =================
; Pregunta ya mostrada por mem_screen_next_with_status (desde p4_x)

memoria_p5:
 
    ; Leer respuesta con el mouse
    call leer_opcion_mouse_abc      ; AL = 'A' / 'B' / 'C' (o 'Z' / teclado fallback)

mem_p5_eval:
    cmp al,'A'
    jne mem_p5_mal                  ; SOLO 'A' es correcta

mem_p5_ok:
    inc bl                          ; aciertos en esta unidad
    inc byte ptr [puntaje_total]    ; puntaje global
    call actualizar_puntaje
    lea dx,msg_ok_mem
    call imprimir_pantalla
    jmp mem_result

mem_p5_mal:
    call sonido_error
    lea dx,msg_bad_mem
    call imprimir_pantalla
    jmp mem_result

;==================== RESULTADO FINAL =========================
mem_result:
    mov ax, 2 ; ocultamos puntero mouse 
    int 33h 

    call cls_azul_10h
    call actualizar_puntaje
    lea dx,msg_fin_mem
    call imprimir_pantalla
    cmp bl,3
    jb  mem_repro
    lea dx,msg_apr_mem
    call imprimir_pantalla
    jmp mem_fin
mem_repro:
    lea dx,msg_rep_mem
    call imprimir_pantalla
mem_fin:
    mov al,bl
    pop dx
    pop bx
    pop ax
    ret
jugar_mem endp

end
