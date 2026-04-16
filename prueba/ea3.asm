;============================================================
; UNIDAD: ENTRADA / SALIDA (E/S)
;------------------------------------------------------------
; - Igual formato visual que las otras unidades
; - Timeout 10 s (INT 1Ah)
; - Valida A/B/C
; - Mensaje fijo arriba (Correcto / Incorrecto / Tiempo / Inválido)
; - HUD azul y puntaje global sincronizado
;============================================================

.8086
.model small
.stack 100h

extrn imprimir_pantalla:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn reg2ascii:proc
extrn actualizar_puntaje:proc 
extrn puntaje_total:byte
extrn cls_azul_10h:proc

.data
msg_intro db 0dh,0ah,"[UNIDAD: ENTRADA / SALIDA (E/S)]",0dh,0ah,'$'

msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto!",0dh,0ah,'$'
msg_tiempo     db 0dh,0ah,"Tiempo agotado: se toma como INCORRECTA.",0dh,0ah,'$'
msg_invalido   db 0dh,0ah,"Solo se permiten las letras A, B o C.",0dh,0ah,'$'
msg_final      db 0dh,0ah,"Fin de la unidad de ENTRADA/SALIDA!",0dh,0ah,'$'
msg_aprobado   db 0dh,0ah,"Excelente! Dominas la comunicacion CPU ↔ perifericos.",0dh,0ah,'$'
msg_reprobo    db 0dh,0ah,"Repasa los modos de E/S y el mapeo de direcciones.",0dh,0ah,'$'
nl             db 0dh,0ah,'$'
nroAscii       db '000','$'

preg1 db 0dh,0ah,"1) Cual es la funcion de la Unidad de Entrada/Salida?",0dh,0ah
      db "A) Realizar calculos matematicos",0dh,0ah
      db "B) Permitir la comunicacion entre CPU y perifericos",0dh,0ah
      db "C) Controlar la memoria RAM",0dh,0ah,'$'

preg2 db 0dh,0ah,"2) Que es el mapeo a memoria?",0dh,0ah
      db "A) Los dispositivos comparten espacio de direcciones con la memoria",0dh,0ah
      db "B) Cada periferico tiene un canal exclusivo",0dh,0ah
      db "C) La memoria se guarda en disco",0dh,0ah,'$'

preg3 db 0dh,0ah,"3) Que diferencia hay entre mapeo aislado y mapeo a memoria?",0dh,0ah
      db "A) En el aislado la CPU usa instrucciones especiales IN/OUT",0dh,0ah
      db "B) En el de memoria se usa una EEPROM",0dh,0ah
      db "C) Son equivalentes",0dh,0ah,'$'

preg4 db 0dh,0ah,"4) Que linea indica si una direccion pertenece a E/S o a memoria?",0dh,0ah
      db "A) M/!IO",0dh,0ah
      db "B) RD",0dh,0ah
      db "C) WR",0dh,0ah,'$'

preg5 db 0dh,0ah,"5) Que instruccion permite leer un dato de un puerto de E/S?",0dh,0ah
      db "A) MOV",0dh,0ah
      db "B) IN",0dh,0ah
      db "C) OUT",0dh,0ah,'$'

.code
;============================================================
; Helper: muestra mensaje de estado + pregunta siguiente
; EN: DX = ptr mensaje estado, BX = ptr pregunta siguiente
;============================================================
io_screen_next_with_status proc
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
io_screen_next_with_status endp

;============================================================
; Lector con timeout (10 s)
; OUT: AL='A'/'B'/'C' → válida, AL=0 → timeout, AL=0FFh → inválida
;============================================================
public leer_abc_timeout_entrada_salida
leer_abc_timeout_entrada_salida proc
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
leer_abc_timeout_entrada_salida endp

;============================================================
; PROCESO PRINCIPAL - UNIDAD ENTRADA/SALIDA
;============================================================
public jugar_io
jugar_io proc
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
    call leer_abc_timeout_entrada_salida
    cmp al,0
    je  p1_tarde
    cmp al,0FFh
    je  p1_inv
    cmp al,'B'
    je  p1_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg2
    call io_screen_next_with_status
    jmp p2
p1_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg2
    call io_screen_next_with_status
    jmp p2
p1_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg1
    call io_screen_next_with_status
    jmp p1
p1_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg2
    call io_screen_next_with_status

;==================== PREGUNTA 2 ======================
p2:
    call leer_abc_timeout_entrada_salida
    cmp al,0
    je  p2_tarde
    cmp al,0FFh
    je  p2_inv
    cmp al,'A'
    je  p2_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg3
    call io_screen_next_with_status
    jmp p3
p2_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg3
    call io_screen_next_with_status
    jmp p3
p2_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg2
    call io_screen_next_with_status
    jmp p2
p2_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg3
    call io_screen_next_with_status

;==================== PREGUNTA 3 ======================
p3:
    call leer_abc_timeout_entrada_salida
    cmp al,0
    je  p3_tarde
    cmp al,0FFh
    je  p3_inv
    cmp al,'A'
    je  p3_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg4
    call io_screen_next_with_status
    jmp p4
p3_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg4
    call io_screen_next_with_status
    jmp p4
p3_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg3
    call io_screen_next_with_status
    jmp p3
p3_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg4
    call io_screen_next_with_status

;==================== PREGUNTA 4 ======================
p4:
    call leer_abc_timeout_entrada_salida
    cmp al,0
    je  p4_tarde
    cmp al,0FFh
    je  p4_inv
    cmp al,'A'
    je  p4_ok
    call sonido_error
    lea dx,msg_incorrecto
    lea bx,preg5
    call io_screen_next_with_status
    jmp p5
p4_tarde:
    call sonido_error
    lea dx,msg_tiempo
    lea bx,preg5
    call io_screen_next_with_status
    jmp p5
p4_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg4
    call io_screen_next_with_status
    jmp p4
p4_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto
    lea bx,preg5
    call io_screen_next_with_status

;==================== PREGUNTA 5 ======================
p5:
    call leer_abc_timeout_entrada_salida
    cmp al,0
    je  p5_tarde
    cmp al,0FFh
    je  p5_inv
    cmp al,'B'
    je  p5_ok
    call sonido_error
    lea dx,msg_incorrecto
    jmp io_final
p5_tarde:
    call sonido_error
    lea dx,msg_tiempo
    jmp io_final
p5_inv:
    call sonido_error
    lea dx,msg_invalido
    lea bx,preg5
    call io_screen_next_with_status
    jmp p5
p5_ok:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx,msg_correcto

;==================== RESULTADO FINAL ======================
io_final:
    call cls_azul_10h
    call actualizar_puntaje
    lea dx,msg_final
    call imprimir_pantalla

    ; Mostrar puntaje obtenido
    mov dl,bl
    mov bx,offset nroAscii
    call reg2ascii
    lea dx,nroAscii
    call imprimir_pantalla
    lea dx,nl
    call imprimir_pantalla

    cmp bl,3
    jb  io_repro
    lea dx,msg_aprobado
    call imprimir_pantalla
    jmp io_fin
io_repro:
    lea dx,msg_reprobo
    call imprimir_pantalla
io_fin:
    mov al,bl
    pop dx
    pop bx
    pop ax
    ret
jugar_io endp

end
