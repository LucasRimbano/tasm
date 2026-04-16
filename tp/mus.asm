;===========================================================
; LIBSONIDO - Sonido de Presentación Estilo Videojuego
;-----------------------------------------------------------
; Reproduce una breve melodía usando el altavoz del sistema
; (PC Speaker) mediante el PIT (Programmable Interval Timer)
;
; Uso:
;   extrn sonido_presentacion:proc
;   ...
;   call sonido_presentacion
;===========================================================

.8086
.model small
.stack 100h

.code
public sonido_presentacion

;-----------------------------------------------------------
; Procedimiento principal
;-----------------------------------------------------------
sonido_presentacion proc
    push ax
    push bx
    push cx
    push dx

    ;------------------------------------------
    ; Tocar una pequeña melodía (DO, MI, SOL)
    ;------------------------------------------
    mov ax, 1912     ; Nota DO (262 Hz aprox)
    call reproducir_nota

    mov ax, 1516     ; Nota MI (330 Hz aprox)
    call reproducir_nota

    mov ax, 1275     ; Nota SOL (392 Hz aprox)
    call reproducir_nota

    mov ax, 956      ; Nota DO alto (523 Hz aprox)
    call reproducir_nota

    jmp fin

;-----------------------------------------------------------
; Subrutina: reproducir_nota
; Entrada: AX = divisor de frecuencia
;-----------------------------------------------------------
reproducir_nota:
    push ax
    push bx
    push cx
    push dx

    mov bx, ax           ; Guardar el divisor

    ; Configurar canal 2 del PIT en modo de onda cuadrada
    mov al, 0B6h
    out 43h, al

    ; Enviar divisor al canal 2 (puerto 42h)
    mov ax, bx
    out 42h, al
    mov al, ah
    out 42h, al

    ; Activar altavoz (bits 0 y 1 del puerto 61h)
    in al, 61h
    or al, 00000011b
    out 61h, al

    ; Esperar duración (ajustar CX para más/menos tiempo)
    mov cx, 30000
espera:
    loop espera

    ; Apagar altavoz
    in al, 61h
    and al, 11111100b
    out 61h, al

    pop dx
    pop cx
    pop bx
    pop ax
    ret

;-----------------------------------------------------------
; Fin del procedimiento principal
;-----------------------------------------------------------
fin:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
sonido_presentacion endp

end
