;===============================================================
; UNIDAD: MEMORIA PRINCIPAL (MEM) — versión con barra fija
;---------------------------------------------------------------
; - Incrementa puntaje_total en cada acierto (INC byte ptr [puntaje_total])
; - Llama a actualizar_puntaje antes y después de imprimir
; - Devuelve en AL la cantidad de aciertos (0..5) al main
;===============================================================

.8086
.model small
.stack 100h

; --- Externs ---
extrn imprimir_pantalla:proc
extrn leer_caracter_abc:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn actualizar_puntaje:proc
extrn puntaje_total:byte

.data
msg_intro_mem  db 0dh,0ah,"[UNIDAD: MEMORIA PRINCIPAL]",0dh,0ah
               db "Responde las 5 preguntas del parcial (A, B o C).",0dh,0ah,'$'

msg_ok_mem     db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_bad_mem    db 0dh,0ah,"Incorrecto!",0dh,0ah,'$'
msg_fin_mem    db 0dh,0ah,"Fin de la unidad de MEMORIA!",0dh,0ah,'$'
msg_apr_mem    db 0dh,0ah,"Aprobado! Excelente manejo de la memoria.",0dh,0ah,'$'
msg_rep_mem    db 0dh,0ah,"Repasar conceptos de memoria (RAM/ROM/Buses).",0dh,0ah,'$'

;-------------------- Preguntas MEM --------------------
preg1_mem db 0dh,0ah,"1) Que tipo de memoria es volatil?",0dh,0ah
         db "A) ROM",0dh,0ah,"B) RAM",0dh,0ah,"C) Disco Duro",0dh,0ah,'$'

preg2_mem db 0dh,0ah,"2) Donde se almacenan datos en ejecucion?",0dh,0ah
         db "A) RAM",0dh,0ah,"B) CPU",0dh,0ah,"C) Registro de Control",0dh,0ah,'$'

preg3_mem db 0dh,0ah,"3) Que sucede con los datos de la RAM al apagar la PC?",0dh,0ah
         db "A) Se guardan en ROM",0dh,0ah,"B) Se pierden",0dh,0ah,"C) Se copian al cache",0dh,0ah,'$'

preg4_mem db 0dh,0ah,"4) Que bus se usa para acceder a direcciones de memoria?",0dh,0ah
         db "A) Bus de Datos",0dh,0ah,"B) Bus de Control",0dh,0ah,"C) Bus de Direcciones",0dh,0ah,'$'

preg5_mem db 0dh,0ah,"5) Cual de estas es NO volatil?",0dh,0ah
         db "A) ROM",0dh,0ah,"B) RAM",0dh,0ah,"C) Cache",0dh,0ah,'$'

.code
public jugar_mem

jugar_mem proc
    push ax
    push bx
    push dx

    mov ax, @data
    mov ds, ax
    mov bl, 0                     ; contador local de aciertos

    ; Intro
    call actualizar_puntaje
    lea dx, msg_intro_mem
    call imprimir_pantalla
    call sonido_presentacion
    call actualizar_puntaje

;==================== PREGUNTA 1 ==============================
    call actualizar_puntaje
    lea dx, preg1_mem
    call imprimir_pantalla
    call actualizar_puntaje

    call leer_caracter_abc
    cmp al, 'B'
    je  mem_ok1
    call sonido_error
    lea dx, msg_bad_mem
    call imprimir_pantalla
    call actualizar_puntaje
    jmp mem_p2
mem_ok1:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_ok_mem
    call imprimir_pantalla
    call actualizar_puntaje

;==================== PREGUNTA 2 ==============================
mem_p2:
    call actualizar_puntaje
    lea dx, preg2_mem
    call imprimir_pantalla
    call actualizar_puntaje

    call leer_caracter_abc
    cmp al, 'A'
    je  mem_ok2
    call sonido_error
    lea dx, msg_bad_mem
    call imprimir_pantalla
    call actualizar_puntaje
    jmp mem_p3
mem_ok2:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_ok_mem
    call imprimir_pantalla
    call actualizar_puntaje

;==================== PREGUNTA 3 ==============================
mem_p3:
    call actualizar_puntaje
    lea dx, preg3_mem
    call imprimir_pantalla
    call actualizar_puntaje

    call leer_caracter_abc
    cmp al, 'B'
    je  mem_ok3
    call sonido_error
    lea dx, msg_bad_mem
    call imprimir_pantalla
    call actualizar_puntaje
    jmp mem_p4
mem_ok3:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_ok_mem
    call imprimir_pantalla
    call actualizar_puntaje

;==================== PREGUNTA 4 ==============================
mem_p4:
    call actualizar_puntaje
    lea dx, preg4_mem
    call imprimir_pantalla
    call actualizar_puntaje

    call leer_caracter_abc
    cmp al, 'C'
    je  mem_ok4
    call sonido_error
    lea dx, msg_bad_mem
    call imprimir_pantalla
    call actualizar_puntaje
    jmp mem_p5
mem_ok4:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_ok_mem
    call imprimir_pantalla
    call actualizar_puntaje

;==================== PREGUNTA 5 ==============================
mem_p5:
    call actualizar_puntaje
    lea dx, preg5_mem
    call imprimir_pantalla
    call actualizar_puntaje

    call leer_caracter_abc
    cmp al, 'A'
    je  mem_ok5
    call sonido_error
    lea dx, msg_bad_mem
    call imprimir_pantalla
    call actualizar_puntaje
    jmp mem_result
mem_ok5:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_ok_mem
    call imprimir_pantalla
    call actualizar_puntaje

;==================== RESULTADO FINAL =========================
mem_result:
    call actualizar_puntaje
    lea dx, msg_fin_mem
    call imprimir_pantalla
    call actualizar_puntaje

    cmp bl, 3
    jb  mem_repro
    lea dx, msg_apr_mem
    call imprimir_pantalla
    call actualizar_puntaje
    jmp mem_fin

mem_repro:
    lea dx, msg_rep_mem
    call imprimir_pantalla
    call actualizar_puntaje

mem_fin:
    mov al, bl                 ; devolver aciertos al main
    pop dx
    pop bx
    pop ax
    ret
jugar_mem endp

end
