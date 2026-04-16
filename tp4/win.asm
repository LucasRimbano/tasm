;============================================================
; WIN.ASM  (TSR con INT 62h)
;------------------------------------------------------------
; Instala la interrupción 62h para reproducir una melodía
; simple DO - RE - MI (2~3 segundos) cuando se hace:
;       int 62h
;
; Compilación en DOSBox:
;   tasm win.asm
;   tlink /t win.obj
;
; Uso:
;   C:\>win       ; instala INT 62h (DO-RE-MI)
;   C:\>tp4       ; tu juego (que en aprobado_ok llama int 62h)
;============================================================

.8086
.model tiny
.code
org 100h

start:
    cli
    mov ax, cs
    mov ds, ax
    mov es, ax

    ; Guardar vector original de INT 62h (por prolijidad)
    mov ax, 3562h        ; AH=35h, AL=62h
    int 21h              ; ES:BX = vector viejo
    mov old_off, bx
    mov old_seg, es

    ; Instalar nuestro handler en INT 62h
    mov dx, offset int62_handler
    mov ax, 2562h        ; AH=25h, AL=62h
    int 21h
    sti

    ; Mensaje de instalación
    mov dx, offset msg_ok
    mov ah, 09h
    int 21h

    ; Dejar el programa residente
    mov dx, offset fin_residente
    sub dx, 100h          ; tamaño en bytes desde 100h
    mov ah, 31h           ; Terminate and Stay Resident
    int 21h

;------------------------------------------------------------
; INT 62h - Handler: reproduce DO-RE-MI
;------------------------------------------------------------
int62_handler proc far
    push ax
    push bx
    push cx
    push dx

    call melodia_do_re_mi

    pop dx
    pop cx
    pop bx
    pop ax
    iret
int62_handler endp

;------------------------------------------------------------
; Rutina: tono
; ENTRADA:
;   DX = divisor del PIT (frecuencia)
;   CX = "duración" (cuanto más grande, más dura)
;------------------------------------------------------------
tono proc
    push ax
    push bx
    push cx
    push dx

    ; Programar canal 2 del PIT (altavoz PC)
    mov al, 0B6h          ; canal 2, modo 3 (square wave)
    out 43h, al
    mov ax, dx
    out 42h, al           ; low byte
    mov al, ah
    out 42h, al           ; high byte

    ; Encender parlante (bits 0 y 1 de puerto 61h)
    in  al, 61h
    or  al, 03h
    out 61h, al

duracion_tono:
    mov bx, 400           ; si querés más larga la nota, subí este valor
inner_loop:
    dec bx
    jnz inner_loop
    loop duracion_tono

    ; Apagar parlante
    in  al, 61h
    and al, 0FCh          ; apagar bits 0 y 1
    out 61h, al

    pop dx
    pop cx
    pop bx
    pop ax
    ret
tono endp

;------------------------------------------------------------
; Melodía: DO - RE - MI
;   DO4 ~ divisor 4560
;   RE4 ~ divisor 4063
;   MI4 ~ divisor 3620
;------------------------------------------------------------
melodia_do_re_mi proc
    push cx
    push dx

    ; DO
    mov dx, 4560          ; DO4 aprox
    mov cx, 200
    call tono

    ; pequeña pausa
    mov cx, 80
pausa1:
    nop
    loop pausa1

    ; RE
    mov dx, 4063          ; RE4 aprox
    mov cx, 200
    call tono

    mov cx, 80
pausa2:
    nop
    loop pausa2

    ; MI
    mov dx, 3620          ; MI4 aprox
    mov cx, 200
    call tono

    pop dx
    pop cx
    ret
melodia_do_re_mi endp

;------------------------------------------------------------
; Datos
;------------------------------------------------------------
msg_ok      db 0Dh,0Ah,'INT 62h DO-RE-MI instalada!',0Dh,0Ah,'$'
old_off     dw 0
old_seg     dw 0

fin_residente label byte

end start
