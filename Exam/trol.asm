.8086
.model small
.stack 100h

extrn imprimir_pantalla:proc
extrn leer_caracter_abc:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc

.data
msg_intro db 0dh,0ah,"[UNIDAD: UNIDAD DE CONTROL]",0dh,0ah
          db "Responde las 5 preguntas del parcial (A, B o C).",0dh,0ah,'$'

msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto!",0dh,0ah,'$'
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

preg3 db 0dh,0ah,"3) Que señal indica el tipo de operacion a ejecutar?",0dh,0ah
      db "A) Señal de reloj",0dh,0ah
      db "B) Señal de control",0dh,0ah
      db "C) Señal de datos",0dh,0ah,'$'

preg4 db 0dh,0ah,"4) Que realiza el ciclo de instruccion?",0dh,0ah
      db "A) Busca, decodifica y ejecuta instrucciones",0dh,0ah
      db "B) Repite operaciones lógicas",0dh,0ah
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

    mov bl, 0              ;  Contador de respuestas correctas

    lea dx, msg_intro
    call imprimir_pantalla
    call sonido_presentacion

;-------------------- PREGUNTA 1 --------------------
    lea dx, preg1
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, 'B'
    je bien1
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p2
bien1:
    inc bl
    lea dx, msg_correcto
    call imprimir_pantalla

;-------------------- PREGUNTA 2 --------------------
p2:
    lea dx, preg2
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, 'A'
    je bien2
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p3
bien2:
    inc bl
    lea dx, msg_correcto
    call imprimir_pantalla

;-------------------- PREGUNTA 3 --------------------
p3:
    lea dx, preg3
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, 'B'
    je bien3
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p4
bien3:
    inc bl
    lea dx, msg_correcto
    call imprimir_pantalla

;-------------------- PREGUNTA 4 --------------------
p4:
    lea dx, preg4
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, 'A'
    je bien4
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p5
bien4:
    inc bl
    lea dx, msg_correcto
    call imprimir_pantalla

;-------------------- PREGUNTA 5 --------------------
p5:
    lea dx, preg5
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, 'A'
    je bien5
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp resultado
bien5:
    inc bl
    lea dx, msg_correcto
    call imprimir_pantalla

;-------------------- RESULTADO FINAL --------------------
resultado:
    lea dx, msg_final
    call imprimir_pantalla

    cmp bl, 3
    jb reprobo
    lea dx, msg_aprobado
    call imprimir_pantalla
    jmp fin

reprobo:
    lea dx, msg_reprobo
    call imprimir_pantalla

;-------------------- SALIDA --------------------
fin:
    mov al, bl      ;devuelve el puntaje (0–5) al main
    pop dx
    pop bx
    pop ax
    ret
jugar_uc endp

end
