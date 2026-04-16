.8086
.model small
.stack 100h

extrn imprimir_pantalla:proc
extrn leer_caracter_abc:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn reg2ascii:proc

.data
msg_intro db 0dh,0ah,"[UNIDAD: ARITMETICO-LOGICA (ALU)]",0dh,0ah
          db "Responde las 5 preguntas del parcial (A, B o C) -.",0dh,0ah,'$'

msg_correcto db 0dh,0ah," Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah," Incorrecto!",0dh,0ah,'$'
msg_final db 0dh,0ah,"Fin de la unidad de ALU!",0dh,0ah,'$'
msg_aprobado db 0dh,0ah,"Excelente! Dominas la logica y las operaciones de la CPU ",0dh,0ah,'$'
msg_reprobo db 0dh,0ah,"Necesitas repasar operaciones logicas y aritmeticas de la ALU ",0dh,0ah,'$'


; Preguntas

preg1 db 0dh,0ah,"1) Que funcion cumple la ALU?",0dh,0ah
      db "A) Controlar la memoria",0dh,0ah
      db "B) Ejecutar operaciones aritmeticas y logicas",0dh,0ah
      db "C) Coordinar perifericos",0dh,0ah,'$'

preg2 db 0dh,0ah,"2 Que registros intervienen en las operaciones de la ALU?",0dh,0ah
      db "A) AX, BX, CX, DX",0dh,0ah
      db "B) CS, DS, SS, ES",0dh,0ah
      db "C) IP, SP, BP",0dh,0ah,'$'

preg3 db 0dh,0ah,"3) Que hace el bit de 'carry' (CF)?",0dh,0ah
      db "A) Indica error en el programa",0dh,0ah
      db "B) Indica desbordamiento de suma/resta",0dh,0ah
      db "C) Activa la memoria",0dh,0ah,'$'

preg4 db 0dh,0ah,"4) Que instruccion realiza una suma en ensamblador?",0dh,0ah
      db "A) ADD",0dh,0ah
      db "B) CMP",0dh,0ah
      db "C) MOV",0dh,0ah,'$'

preg5 db 0dh,0ah,"5) Que instruccion realiza una comparacion logica?",0dh,0ah
      db "A) CMP",0dh,0ah
      db "B) XOR",0dh,0ah
      db "C) JMP",0dh,0ah,'$'

nroAscii db '000','$'

.code
public jugar_alu

jugar_alu proc
    push ax
    push bx
    push dx

    mov bl, 0              ;Contador de respuestas correctas

    lea dx, msg_intro
    call imprimir_pantalla
    call sonido_presentacion

; PREGUNTA 1 
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

; PREGUNTA 2 
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

; PREGUNTA 3 
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

; PREGUNTA 4 
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

; PREGUNTA 5 
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

; RESULTADO 
resultado:
    lea dx, msg_final
    call imprimir_pantalla

    ; Mostrar mensaje segun resultado
    cmp bl, 3
    jb reprobo
    lea dx, msg_aprobado
    call imprimir_pantalla
    jmp fin

reprobo:
    lea dx, msg_reprobo
    call imprimir_pantalla

; SALIDA 
fin:
    mov al, bl      ; devuelve el puntaje (0–5 al main)
    pop dx
    pop bx
    pop ax
    ret
jugar_alu endp

end
