.8086
.model small
.stack 100h

extrn imprimir_pantalla:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn leer_caracter_abc:proc

.data
msg_intro db 0dh,0ah,"[INTERRUPCIONES] Responde las siguientes preguntas!",0dh,0ah,'$'

preg1 db 0dh,0ah,"1) Que hace una interrupcion?",0dh,0ah,'$'
opc1  db "a) Detiene el CPU permanentemente",0dh,0ah
       db "b) Suspende el flujo y atiende un evento",0dh,0ah
       db "c) Reinicia el programa desde cero",0dh,0ah,'$'
resp1 db 'B'

preg2 db 0dh,0ah,"2) Que instruccion finaliza una ISR?",0dh,0ah,'$'
opc2  db "a) RET",0dh,0ah
       db "b) IRET",0dh,0ah
       db "c) JMP",0dh,0ah,'$'
resp2 db 'B'

preg3 db 0dh,0ah,"3) Que hace la instruccion STI?",0dh,0ah,'$'
opc3  db "a) Deshabilita las interrupciones",0dh,0ah
       db "b) Habilita las interrupciones enmascarables",0dh,0ah
       db "c) Llama a una ISR directamente",0dh,0ah,'$'
resp3 db 'B'

preg4 db 0dh,0ah,"4) Que tipo de interrupcion NO puede ser enmascarada?",0dh,0ah,'$'
opc4  db "a) NMI",0dh,0ah
       db "b) INT 21h",0dh,0ah
       db "c) INT 10h",0dh,0ah,'$'
resp4 db 'A'

preg5 db 0dh,0ah,"5) Que registro usa el CPU para saber si puede atender una interrupcion?",0dh,0ah,'$'
opc5  db "a) AX",0dh,0ah
       db "b) FLAGS",0dh,0ah
       db "c) CS",0dh,0ah,'$'
resp5 db 'B'

msg_correcto   db 0dh,0ah,"Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah,"Incorrecto...",0dh,0ah,'$'
msg_final      db 0dh,0ah,"Fin de la unidad de INTERRUPCIONES!",0dh,0ah,'$'

.code
public jugar_int

jugar_int proc
    push ax
    push bx
    push dx

    mov bl, 0              ; Contador de respuestas correctas (0–5)

    lea dx, msg_intro
    call imprimir_pantalla
    call sonido_presentacion


; PREGUNTA 1

    lea dx, preg1
    call imprimir_pantalla
    lea dx, opc1
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, [resp1]
    je ok1
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p2
ok1:
    inc bl
    lea dx, msg_correcto
    call imprimir_pantalla


; PREGUNTA 2

p2:
    lea dx, preg2
    call imprimir_pantalla
    lea dx, opc2
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, [resp2]
    je ok2
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p3
ok2:
    inc bl
    lea dx, msg_correcto
    call imprimir_pantalla


; PREGUNTA 3

p3:
    lea dx, preg3
    call imprimir_pantalla
    lea dx, opc3
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, [resp3]
    je ok3
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p4
ok3:
    inc bl
    lea dx, msg_correcto
    call imprimir_pantalla

; PREGUNTA 4

p4:
    lea dx, preg4
    call imprimir_pantalla
    lea dx, opc4
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, [resp4]
    je ok4
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p5
ok4:
    inc bl
    lea dx, msg_correcto
    call imprimir_pantalla


; PREGUNTA 5

p5:
    lea dx, preg5
    call imprimir_pantalla
    lea dx, opc5
    call imprimir_pantalla
    call leer_caracter_abc
    cmp al, [resp5]
    je ok5
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp fin_preguntas
ok5:
    inc bl
    lea dx, msg_correcto
    call imprimir_pantalla


; FINAL

fin_preguntas:
    lea dx, msg_final
    call imprimir_pantalla

    mov al, bl      ;  DEVOLVER PUNTAJE EN AL AL MAIN
    pop dx
    pop bx
    pop ax
    ret
jugar_int endp

end
