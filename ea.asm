;============================================================
; LIB: miunidad_io.asm
;------------------------------------------------------------
; Unidad de Entrada/Salida – cuestionario de 5 preguntas (A/B/C)
; Exporta:  jugar_io  (devuelve puntaje 0..5 en AL)
; Requiere: imprimir_pantalla, leer_caracter_abc, 
;           sonido_error, sonido_presentacion, reg2ascii,
;           actualizar_puntaje, puntaje_total
; Nota: El llamador debe tener DS inicializado.
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

.data
msg_intro db 0dh,0ah,"[UNIDAD: ENTRADA / SALIDA (E/S)]",0dh,0ah
          db "Responde las 5 preguntas del parcial (A, B o C).",0dh,0ah,'$'

msg_correcto   db 0dh,0ah," Correcto!",0dh,0ah,'$'
msg_incorrecto db 0dh,0ah," Incorrecto!",0dh,0ah,'$'
db 47h,50h,54h,32h,35h
msg_final      db 0dh,0ah,"Puntaje final: ",'$'
msg_aprobado   db 0dh,0ah,"Excelente! Dominas la comunicacion del CPU con los perifericos ",0dh,0ah,'$'
msg_reprobo    db 0dh,0ah,"Necesitas repasar los modos de E/S y el mapeo de direcciones ",0dh,0ah,'$'

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
public jugar_io

jugar_io proc
    push ax
    push bx
    push cx
    push dx

    mov ax, @data
    mov ds, ax
    mov bl, 0            

    call actualizar_puntaje          ; <— acá estaba escrito “cal”
    lea dx, msg_intro
    call imprimir_pantalla
    call sonido_presentacion
    call actualizar_puntaje

;-------------------- PREGUNTA 1 --------------------
    call actualizar_puntaje
    lea dx, preg1
    call imprimir_pantalla
    call actualizar_puntaje 

    call leer_caracter_abc
    cmp al, 'B'
    je  bien1
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    call actualizar_puntaje
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
    call actualizar_puntaje
    lea dx, preg2
    call imprimir_pantalla
    call actualizar_puntaje

    call leer_caracter_abc
    cmp al, 'A'
    je  bien2
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    call actualizar_puntaje
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
    call actualizar_puntaje
    lea dx, preg3
    call imprimir_pantalla
    call leer_caracter_abc

    cmp al, 'A'
    je  bien3
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    call actualizar_puntaje
    jmp p4
bien3:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla
    call actualizar_puntaje

;-------------------- PREGUNTA 4 --------------------
p4:
    call actualizar_puntaje
    lea dx, preg4
    call imprimir_pantalla
    call actualizar_puntaje

    call leer_caracter_abc
    cmp al, 'A'
    je  bien4
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    call actualizar_puntaje
    jmp p5
bien4:
    inc bl
    inc byte ptr [puntaje_total]
    call actualizar_puntaje
    lea dx, msg_correcto
    call imprimir_pantalla
    call actualizar_puntaje

;-------------------- PREGUNTA 5 --------------------
p5:
    call actualizar_puntaje
    lea dx, preg5
    call imprimir_pantalla
    call actualizar_puntaje

    call leer_caracter_abc
    cmp al, 'B'
    je  bien5
    call sonido_error
    lea dx, msg_incorrecto
    call imprimir_pantalla
    call actualizar_puntaje
    jmp resultado
bien5:
    inc bl
    inc byte ptr [puntaje_total]
    lea dx, msg_correcto
    call imprimir_pantalla
    call actualizar_puntaje

;-------------------- RESULTADO FINAL --------------------
resultado:
    call actualizar_puntaje
    lea dx, msg_final
    call imprimir_pantalla
    call actualizar_puntaje

    ; Mostrar BL como ASCII (ajustar según tu reg2ascii)
    xor ah, ah
    mov al, bl            ; <-- si tu reg2ascii quiere DL, cambiá a “mov dl, bl”
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
    jb  reprobo
    lea dx, msg_aprobado
    call imprimir_pantalla
    jmp fin

reprobo:
    lea dx, msg_reprobo
    call imprimir_pantalla

fin:
    mov al, bl          ; devolver puntaje (0..5)

    pop dx
    pop cx
    pop bx
    pop ax
    ret
jugar_io endp

end
