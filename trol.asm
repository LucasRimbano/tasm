;============================================================
; LIB: miunidad_control.asm  — Unidad de Control con HUD
;------------------------------------------------------------
; Exporta:  jugar_uc  -> devuelve puntaje (0..5) en AL
; Usa:      imprimir_pantalla, leer_caracter_abc,
;          sonido_error, sonido_presentacion,
;          actualizar_puntaje, puntaje_total
; DS:       Se inicializa dentro del proc (seguro para librería)
;============================================================

.8086
.model small
.stack 100h

extrn imprimir_pantalla:proc
extrn leer_caracter_abc:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn actualizar_puntaje:proc
extrn puntaje_total:byte

.data
msg_intro db 0dh,0ah,"[UNIDAD: UNIDAD DE CONTROL]",0dh,0ah
          db "Responde las 5 preguntas del parcial (A, B o C).",0dh,0ah,'$'

msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto!",0dh,0ah,'$'
db 47h,50h,54h,32h,35h
msg_final      db 0dh,0ah,"Fin de la unidad de CONTROL!",0dh,0ah,'$'
msg_aprobado   db 0dh,0ah,"Excelente! Dominas el flujo de control del CPU ",0dh,0ah,'$'
msg_reprobo    db 0dh,0ah,"Repasa la logica de control y el ciclo de instruccion ",0dh,0ah,'$'

;--------------------------------------------
; Preguntas
;--------------------------------------------
preg1 db 0dh,0ah,"1) Que funcion cumple la Unidad de Control?",0dh,0ah
      db "A) Ejecutar calculos aritmeticos",0dh,0ah
      db "B) Coordinar y dirigir el funcionamiento del CPU",0dh,0ah
      db "C) Almacenar datos",0dh,0ah,'$'

preg2 db 0dh,0ah,"2) Que elementos controla la Unidad de Control?",0dh,0ah
      db "A) Registros, ALU y buses",0dh,0ah
      db "B) Solo la memoria",0dh,0ah
      db "C) Solo las interrupciones",0dh,0ah,'$'

preg3 db 0dh,0ah,"3) Que senial indica el tipo de operacion a ejecutar?",0dh,0ah
      db "A) Senial de reloj",0dh,0ah
      db "B) Senial de control",0dh,0ah
      db "C) Senial de datos",0dh,0ah,'$'

preg4 db 0dh,0ah,"4) Que realiza el ciclo de instruccion?",0dh,0ah
      db "A) Busca, decodifica y ejecuta instrucciones",0dh,0ah
      db "B) Repite operaciones logicas",0dh,0ah
      db "C) Genera interrupciones",0dh,0ah,'$'

preg5 db 0dh,0ah,"5) Donde se guarda la direccion de la proxima instruccion a ejecutar?",0dh,0ah
      db "A) En el registro IP",0dh,0ah
      db "B) En el registro AX",0dh,0ah
      db "C) En la ALU",0dh,0ah,'$'

.code
public jugar_uc

jugar_uc proc
    push ax
    push bx
    push dx

    mov ax, @data
    mov ds, ax

    mov bl, 0

    ; Intro + HUD
    call actualizar_puntaje
    lea dx, msg_intro
    call imprimir_pantalla
    call sonido_presentacion
    call actualizar_puntaje

;-------------------- PREGUNTA 1 --------------------
    lea dx, preg1
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, 'B'
    je  bien1
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p2
bien1:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla
    call actualizar_puntaje

;-------------------- PREGUNTA 2 --------------------
p2:
    lea dx, preg2
    call imprimir_pantalla
    call actualizar_puntaje
    call leer_caracter_abc
    cmp al, 'A'
    je  bien2
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p3
bien2:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla
    call actualizar_puntaje

;-------------------- PREGUNTA 3 --------------------
p3:
    lea dx, preg3
    call imprimir_pantalla
    call actualizar_puntaje
    call leer_caracter_abc
    cmp al, 'B'
    je  bien3
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p4
bien3:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

;-------------------- PREGUNTA 4 --------------------
p4:
    lea dx, preg4
    call imprimir_pantalla
    call actualizar_puntaje
    call leer_caracter_abc
    cmp al, 'A'
    je  bien4
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p5
bien4:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

;-------------------- PREGUNTA 5 --------------------
p5:
    lea dx, preg5
    call imprimir_pantalla
    call actualizar_puntaje 
    call leer_caracter_abc
    cmp al, 'A'
    je  bien5
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp resultado
bien5:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla

;-------------------- RESULTADO FINAL --------------------
resultado:
    lea dx, msg_final
    call imprimir_pantalla
    call actualizar_puntaje

    cmp bl, 3
    jb  reprobo
    lea dx, msg_aprobado
    call imprimir_pantalla
    jmp fin

reprobo:
    lea dx, msg_reprobo
    call imprimir_pantalla

;-------------------- SALIDA --------------------
fin:
    mov al, bl

    pop dx
    pop bx
    pop ax
    ret
jugar_uc endp

end
