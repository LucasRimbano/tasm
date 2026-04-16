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
; Título SOLO (sin textos extra)
msg_intro db 0dh,0ah,"[UNIDAD: UNIDAD DE CONTROL]",0dh,0ah,'$'

msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto!",0dh,0ah,'$'
msg_final      db 0dh,0ah,"Fin de la unidad de CONTROL!",0dh,0ah,'$'
msg_aprobado   db 0dh,0ah,"Excelente! Dominas el flujo de control del CPU",0dh,0ah,'$'
msg_reprobo    db 0dh,0ah,"Repasa la logica de control y el ciclo de instruccion",0dh,0ah,'$'
nl             db 0dh,0ah,'$'

; Preguntas con opciones (cada una termina en '$')
preg1 db 0dh,0ah,"1) Que funcion cumple la Unidad de Control?",0dh,0ah
      db "A) Ejecutar calculos aritmeticos",0dh,0ah
      db "B) Coordinar y dirigir el funcionamiento del CPU",0dh,0ah
      db "C) Almacenar datos",0dh,0ah,'$'

preg2 db 0dh,0ah,"2) Que elementos controla la Unidad de Control?",0dh,0ah
      db "A) Registros, ALU y buses",0dh,0ah
      db "B) Solo la memoria",0dh,0ah
      db "C) Solo las interrupciones",0dh,0ah,'$'

preg3 db 0dh,0ah,"3) Cual es la caracterastica de la arquitectura RISC?",0dh,0ah
      db "A) Emplea instrucciones complejas que requieren microprogramacion  ",0dh,0ah
      db "B) Utiliza instrucciones simples que se ejecutan en un solo ciclo de reloj" ,0dh,0ah ;correcta
      db "C) Prioriza la compatibilidad con software heredado sobre la eficiencia",0dh,0ah,'$'

preg4 db 0dh,0ah,"4)Cual es el orden del ciclo instruccion correcto?",0dh,0ah
      db "A) IF , ID , OF ,EX ",0dh,0ah
      db "B) ID, IF , OF ,EX ",0dh,0ah
      db "C) IF ,ID , DX , EX ",0dh,0ah,'$'

preg5 db 0dh,0ah,"5) Donde se guarda la direccion de la proxima instruccion a ejecutar?",0dh,0ah
      db "A) En el registro IP",0dh,0ah
      db "B) En el registro AX",0dh,0ah
      db "C) En la ALU",0dh,0ah,'$'

.code


; Helper: limpia + HUD + título + pregunta
; EN: DX = ptr a PREGUNTA ($)

uc_screen_pregunta proc
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
uc_screen_pregunta endp


; Helper: limpia + HUD + título + estado + pregunta siguiente
; EN: DX = ptr a MENSAJE (Correcto/Incorrecto, $)
;     BX = ptr a PREGUNTA SIGUIENTE ($)

uc_screen_next_with_status proc
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
uc_screen_next_with_status endp

public jugar_uc
jugar_uc proc
    push ax
    push bx
    push dx

    mov bl, 0

    ; Pantalla inicial con P1
    lea dx, preg1
    call uc_screen_pregunta
    call sonido_presentacion

;-------------------- PREGUNTA 1 --------------------
    call leer_caracter_abc
    cmp al, 'B'
    je  uc_ok1
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg2
    call uc_screen_next_with_status
    jmp uc_p2
uc_ok1:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg2
    call uc_screen_next_with_status

;-------------------- PREGUNTA 2 --------------------
uc_p2:
    call leer_caracter_abc
    cmp al, 'A'
    je  uc_ok2
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg3
    call uc_screen_next_with_status
    jmp uc_p3
uc_ok2:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg3
    call uc_screen_next_with_status

;-------------------- PREGUNTA 3 --------------------
uc_p3:
    call leer_caracter_abc
    cmp al, 'B'
    je  uc_ok3
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg4
    call uc_screen_next_with_status
    jmp uc_p4
uc_ok3:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg4
    call uc_screen_next_with_status

;-------------------- PREGUNTA 4 --------------------
uc_p4:
    call leer_caracter_abc
    cmp al, 'A'
    je  uc_ok4
    call sonido_error
    lea dx, msg_incorrecto
    lea bx, preg5
    call uc_screen_next_with_status
    jmp uc_p5
uc_ok4:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    lea bx, preg5
    call uc_screen_next_with_status

;-------------------- PREGUNTA 5 --------------------
uc_p5:
    call leer_caracter_abc
    cmp al, 'A'
    je  uc_ok5
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp uc_result
uc_ok5:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

;-------------------- RESULTADO FINAL --------------------
uc_result:
    call cls_azul_10h
    call actualizar_puntaje
    lea dx, msg_final
    call imprimir_pantalla
    call actualizar_puntaje

    cmp bl, 3
    jb  uc_repro
    lea dx, msg_aprobado
    call imprimir_pantalla
    jmp uc_fin

uc_repro:
    lea dx, msg_reprobo
    call imprimir_pantalla

uc_fin:
    mov al, bl

    pop dx
    pop bx
    pop ax
    ret
jugar_uc endp

end
