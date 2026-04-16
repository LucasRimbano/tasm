.8086
.model small
.stack 100h

extrn imprimir_pantalla:proc
extrn leer_caracter_abc:proc
extrn sonido_error:proc
extrn sonido_presentacion:proc
extrn reg2ascii:proc

.data
msg_intro db 0dh,0ah,"[UNIDAD: ENTRADA / SALIDA (E/S)]",0dh,0ah
          db "Responde las 5 preguntas del parcial (A, B o C).",0dh,0ah,'$'

msg_correcto db 0dh,0ah," Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah," Incorrecto!",0dh,0ah,'$'
msg_final db 0dh,0ah,"Puntaje final: ",'$'
msg_aprobado db 0dh,0ah,"Excelente! Dominas la comunicacion del CPU con los perifericos ",0dh,0ah,'$'
msg_reprobo db 0dh,0ah,"Necesitas repasar los modos de E/S y el mapeo de direcciones ",0dh,0ah,'$'

; Preguntas

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

preg4 db 0dh,0ah,"4) Que lineea indica si una direccion pertenece a E/S o a memoria?",0dh,0ah
      db "A) M/!IO",0dh,0ah
      db "B) RD",0dh,0ah
      db "C) WR",0dh,0ah,'$'

preg5 db 0dh,0ah,"5) Que instruccion permite leer un dato de un puerto de E/S?",0dh,0ah
      db "A) MOV",0dh,0ah
      db "B) IN",0dh,0ah
      db "C) OUT",0dh,0ah,'$'

nroAscii db '000','$'

.code
public jugar_io

jugar_io proc
    push ax
    push bx
    push cx
    push dx

    mov bl, 0            

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
    cmp al, 'A'
    je bien3
    call sonido_presentacion
    lea dx, msg_correcto
    call imprimir_pantalla
    jmp p4
bien3:
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp p4


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
    cmp al, 'B'
    je bien5
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    jmp resultado
bien5:
    inc bl
    lea dx, msg_correcto
    call imprimir_pantalla


; RESULTADO FINAL

resultado:
    lea dx, msg_final
    call imprimir_pantalla

    xor ah, ah
    mov al, bl
    mov bx, offset nroAscii
    call reg2ascii

    lea dx, nroAscii
    call imprimir_pantalla

    mov dl, '/'
    mov ah, 02h
    int 21h
    mov dl, '5'
    int 21h

    cmp bl, 3
    jb reprobo
    lea dx, msg_aprobado
    call imprimir_pantalla
    jmp fin

reprobo:
    lea dx, msg_reprobo
    call imprimir_pantalla

fin:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
jugar_io endp

end
