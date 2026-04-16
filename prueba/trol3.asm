;============================================================
; UNIDAD: UNIDAD DE CONTROL (UC.ASM)
;------------------------------------------------------------
; - Igual formato visual que ALU, MEMORIA e INTERRUPCIONES
; - Timeout 10 s con INT 1Ah
; - Valida A/B/C, muestra mensaje fijo arriba
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
msg_intro      db 0dh,0ah,"[UNIDAD: UNIDAD DE CONTROL]",0dh,0ah,'$'

msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto!",0dh,0ah,'$'
msg_tiempo     db 0dh,0ah,"Tiempo agotado: se toma como INCORRECTA.",0dh,0ah,'$'
msg_invalido   db 0dh,0ah,"Solo se permiten las letras A, B o C.",0dh,0ah,'$'
msg_final      db 0dh,0ah,"Fin de la unidad de CONTROL!",0dh,0ah,'$'
msg_aprobado   db 0dh,0ah,"Excelente! Dominas el flujo de control del CPU",0dh,0ah,'$'
msg_reprobo    db 0dh,0ah,"Repasa la logica de control y el ciclo de instruccion",0dh,0ah,'$'
nl             db 0dh,0ah,'$'

;==================== PREGUNTAS ==============================
preg1 db 0dh,0ah,"1) Que funcion cumple la Unidad de Control?",0dh,0ah
      db "A) Ejecutar calculos aritmeticos",0dh,0ah
      db "B) Coordinar y dirigir el funcionamiento del CPU",0dh,0ah
      db "C) Almacenar datos",0dh,0ah,'$'

preg2 db 0dh,0ah,"2) Que elementos controla la Unidad de Control?",0dh,0ah
      db "A) Registros, ALU y buses",0dh,0ah
      db "B) Solo la memoria",0dh,0ah
      db "C) Solo las interrupciones",0dh,0ah,'$'

preg3 db 0dh,0ah,"3) Cual es la caracteristica de la arquitectura RISC?",0dh,0ah
      db "A) Emplea instrucciones complejas que requieren microprogramacion",0dh,0ah
      db "B) Utiliza instrucciones simples que se ejecutan en un solo ciclo de reloj",0dh,0ah
      db "C) Prioriza la compatibilidad con software heredado sobre la eficiencia",0dh,0ah,'$'

preg4 db 0dh,0ah,"4) Cual es el orden del ciclo de instruccion correcto?",0dh,0ah
      db "A) IF, ID, OF, EX",0dh,0ah
      db "B) ID, IF, OF, EX",0dh,0ah
      db "C) IF, ID, DX, EX",0dh,0ah,'$'

preg5 db 0dh,0ah,"5) Donde se guarda la direccion de la proxima instruccion a ejecutar?",0dh,0ah
      db "A) En el registro IP",0dh,0ah
      db "B) En el registro AX",0dh,0ah
      db "C) En la ALU",0dh,0ah,'$'

.code
;============================================================
; Helper: pantalla con estado + pregunta siguiente
; EN: DX = ptr mensaje estado ($), BX = ptr pregunta siguiente ($)
;============================================================
uc_screen_next_with_status proc
    push ax
    push bx
    push dx
    call cls_azul_10h
    call actualizar_puntaje
    lea dx,msg_intro
    call imprimir_pantalla
    lea dx,nl
    call imprimir_pantalla
    pop dx
    call imprimir_pantalla
    lea dx,nl
    call imprimir_pantalla
    mov dx,bx
    call imprimir_pantalla
    pop bx
    pop ax
    ret
uc_screen_next_with_status endp

;============================================================
; Lector con timeout (10 s)
; OUT: AL='A'/'B'/'C' → válida, AL=0 → timeout, AL=0FFh → inválida
;============================================================
public leer_abc_timeout_control
leer_abc_timeout_control proc
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
leer_abc_timeout_control endp

;============================================================
; PROCESO PRINCIPAL - UNIDAD DE CONTROL
;============================================================
public jugar_uc
jugar_uc proc
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
    call leer_abc_timeout_control
    cmp al,0
    je  p1_tarde
    cmp al,0FFh
    je  p1_inv
    cmp al,'B'
    je  p1_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg2
    call uc_screen_next_with_status
    jmp p2
p1_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg2
    call uc_screen_next_with_status
    jmp p2
p1_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg1
    call uc_screen_next_with_status
    jmp p1
p1_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg2
    call uc_screen_next_with_status

;==================== PREGUNTA 2 ======================
p2:
    call leer_abc_timeout_control
    cmp al,0
    je  p2_tarde
    cmp al,0FFh
    je  p2_inv
    cmp al,'A'
    je  p2_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg3
    call uc_screen_next_with_status
    jmp p3
p2_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg3
    call uc_screen_next_with_status
    jmp p3
p2_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg2
    call uc_screen_next_with_status
    jmp p2
p2_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg3
    call uc_screen_next_with_status

;==================== PREGUNTA 3 ======================
p3:
    call leer_abc_timeout_control
    cmp al,0
    je  p3_tarde
    cmp al,0FFh
    je  p3_inv
    cmp al,'B'
    je  p3_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg4
    call uc_screen_next_with_status
    jmp p4
p3_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg4
    call uc_screen_next_with_status
    jmp p4
p3_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg3
    call uc_screen_next_with_status
    jmp p3
p3_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg4
    call uc_screen_next_with_status

;==================== PREGUNTA 4 ======================
p4:
    call leer_abc_timeout_control
    cmp al,0
    je  p4_tarde
    cmp al,0FFh
    je  p4_inv
    cmp al,'A'
    je  p4_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg5
    call uc_screen_next_with_status
    jmp p5
p4_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg5
    call uc_screen_next_with_status
    jmp p5
p4_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg4
    call uc_screen_next_with_status
    jmp p4
p4_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg5
    call uc_screen_next_with_status

;==================== PREGUNTA 5 ======================
p5:
    call leer_abc_timeout_control
    cmp al,0
    je  p5_tarde
    cmp al,0FFh
    je  p5_inv
    cmp al,'A'
    je  p5_ok
    call sonido_error
    lea dx,msg_incorrecto
    jmp uc_final
p5_tarde:
    call sonido_error
    lea dx,msg_tiempo
    jmp uc_final
p5_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg5
    call uc_screen_next_with_status
    jmp p5
p5_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto

;==================== RESULTADO FINAL ======================
uc_final:
    call cls_azul_10h
    call actualizar_puntaje
    lea dx,msg_final
    call imprimir_pantalla
    cmp bl,3
    jb  uc_repro
    lea dx,msg_aprobado
    call imprimir_pantalla
    jmp uc_fin
uc_repro:
    lea dx,msg_reprobo
    call imprimir_pantalla
uc_fin:
    mov al,bl
    pop dx
    pop bx
    pop ax
    ret
jugar_uc endp

end
