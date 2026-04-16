;============================================================
; LIB: miunidad_io.asm — pantalla limpia por pregunta (Opción 3)
;------------------------------------------------------------
; Exporta:  jugar_io  -> AL = aciertos (0..5)
; Requiere: imprimir_pantalla, leer_caracter_abc, sonido_error,
;           sonido_presentacion, reg2ascii, actualizar_puntaje,
;           puntaje_total, cls_azul_10h
; NOTA: Este módulo NO inicializa DS. Lo hace el main.
;============================================================

.8086
.model small
.stack 100h

extrn imprimir_pantalla:proc
extrn leer_caracter_abc:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn reg2ascii:proc
extrn actualizar_puntaje:proc 
extrn puntaje_total:byte
extrn cls_azul_10h:proc
extrn cambiar_color_amarillo:proc

.data
; Título SOLO (sin textos extra)
msg_intro db 0dh,0ah,"[UNIDAD: ENTRADA / SALIDA (E/S)]",0dh,0ah,'$'

msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto!",0dh,0ah,'$'
msg_final      db 0dh,0ah,"Puntaje final: ",'$'
msg_aprobado   db 0dh,0ah,"Excelente! Dominas la comunicacion del CPU con los perifericos.",0dh,0ah,'$'
msg_reprobo    db 0dh,0ah,"Necesitas repasar los modos de E/S y el mapeo de direcciones.",0dh,0ah,'$'
nl             db 0dh,0ah,'$'

; Preguntas (con opciones, terminan en '$')
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

nroAscii db '000','$'

.code


; Helper: limpia + HUD + título + pregunta
; EN: DX = ptr a PREGUNTA ($)

io_screen_pregunta proc
    push ax
    push dx
    call cls_azul_10h
    call cambiar_color_amarillo
    call actualizar_puntaje
    lea dx, msg_intro
    call imprimir_pantalla
    lea dx, nl
    call imprimir_pantalla
    pop dx
    call imprimir_pantalla
    pop ax
    ret
io_screen_pregunta endp


; Helper: limpia + HUD + título + estado + pregunta siguiente
; EN: DX = ptr a MENSAJE (Correcto/Incorrecto, $)
;     BX = ptr a PREGUNTA SIGUIENTE ($)

io_screen_next_with_status proc
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
io_screen_next_with_status endp

public jugar_io
jugar_io proc
    push ax
    push bx
    push cx
    push dx

    mov bl, 0

    ; Pantalla inicial con P1
    lea dx, preg1
    call io_screen_pregunta
    call sonido_presentacion

;-------------------- PREGUNTA 1 --------------------
    call leer_caracter_abc
    cmp al, 'B'
    je  io_ok1
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg2
    call io_screen_next_with_status
    jmp io_p2
io_ok1:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg2
    call io_screen_next_with_status

;-------------------- PREGUNTA 2 --------------------
io_p2:
    call leer_caracter_abc
    cmp al, 'A'
    je  io_ok2
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg3
    call io_screen_next_with_status
    jmp io_p3
io_ok2:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg3
    call io_screen_next_with_status

;-------------------- PREGUNTA 3 --------------------
io_p3:
    call leer_caracter_abc
    cmp al, 'A'
    je  io_ok3
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg4
    call io_screen_next_with_status
    jmp io_p4
io_ok3:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg4
    call io_screen_next_with_status

;-------------------- PREGUNTA 4 --------------------
io_p4:
    call leer_caracter_abc
    cmp al, 'A'
    je  io_ok4
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg5
    call io_screen_next_with_status
    jmp io_p5
io_ok4:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg5
    call io_screen_next_with_status

;-------------------- PREGUNTA 5 --------------------
io_p5:
    call leer_caracter_abc
    cmp al, 'B'
    je  io_ok5
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp io_result
io_ok5:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

;-------------------- RESULTADO FINAL --------------------
io_result:
    call cls_azul_10h
    call actualizar_puntaje
    lea dx, msg_final
    call imprimir_pantalla

    ; Mostrar BL como ASCII (reg2ascii: DL=valor, BX=buffer)
    mov dl, bl
    mov bx, offset nroAscii
    call reg2ascii
    lea dx, nroAscii
    call imprimir_pantalla

    ; imprimir "/5"
    mov dl, '/'
    mov ah, 02h
    int 21h
    mov dl, '5'
    int 21h

    ; Aprobado/Reprobado
    cmp bl, 3
    jb  io_repro
    lea dx, msg_aprobado
    call imprimir_pantalla
    jmp io_fin

io_repro:
    lea dx, msg_reprobo
    call imprimir_pantalla

io_fin:
    mov al, bl          ; devolver puntaje (0..5)

    pop dx
    pop cx
    pop bx
    pop ax
    ret
jugar_io endp

end
