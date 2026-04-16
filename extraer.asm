;============================================================
; EXTRAER.COM  -  TSR que suprime una tecla (INT 09h)
; -----------------------------------------------------------
; - Se instala sobre la interrupción 09h (teclado)
; - Pide una tecla, toma su SCAN CODE y luego:
;       si se presiona esa tecla → la descarta
; - Para “desinstalar”, reiniciar DOSBox (o la máquina)
;
; Compilar:
;   tasm extraer.asm
;   tlink /t extraer.obj
;
; Ejecutar:
;   extraer.com
;============================================================

.8086
.model tiny
.code
org 100h

start:  jmp main          ; saltamos el código residente

;------------------------------------------------------------
; *** PARTE RESIDENTE: nueva ISR 09h + datos ***
;------------------------------------------------------------

new09 proc far
    jmp continuar_isr     ; truquito para tener dato "Letra" justo después
Letra   db 20h            ; aquí guardamos el SCAN CODE a suprimir

continuar_isr:
    sti                   ; re-habilito interrupciones
    push ax
    push dx
    push bx               ; ahora también salvamos BX

    in   al, 60h          ; leo SCAN CODE desde el puerto 60h

    ; ¿Es la tecla que debo suprimir?
    lea  bx, Letra        ; BX = &Letra
    cmp  al, cs:[bx]      ; comparar con el scancode guardado
    je   DoNothing        ; si coincide → NO llamo a la ISR vieja

    ; Si no es la tecla, paso a la ISR vieja
    pop  bx
    pop  dx
    pop  ax
    jmp  cs:ViejaInt09    ; salto a la antigua INT 09h

DoNothing:
    ; rutina estándar para "acknowledge" y descartar la tecla
    cli
    in   al, 61h
    mov  ah, al
    or   al, 80h
    out  61h, al
    mov  al, ah
    out  61h, al
    mov  al, 20h
    out  20h, al
    sti

    pop  bx
    pop  dx
    pop  ax
    iret
new09 endp


; puntero viejo de INT 09h
ViejaInt09 label dword
old09_ofs  dw 0
old09_seg  dw 0

FinResidente label byte      ; marca el final del código residente

;------------------------------------------------------------
; *** PARTE NO RESIDENTE: instalador del TSR ***
;------------------------------------------------------------

AskKey   db 'Ingrese la tecla que se suprimira: $'
MsgOK    db 0Dh,0Ah,'Programa instalado. Tecla suprimida -> $'
MsgTail  db 0Dh,0Ah,'(Reinicie DOSBox para restaurar el teclado)',0Dh,0Ah,'$'

main:
    ; unificar segmentos
    mov ax, cs
    mov ds, ax
    mov es, ax

    ; pedir tecla al usuario
    mov dx, offset AskKey
    mov ah, 09h
    int 21h

    ; esperar una tecla por BIOS (AH=0, INT 16h)
    xor ah, ah
    int 16h               ; AL = ASCII, AH = SCAN CODE

    ; guardar SCAN CODE en "Letra"
    lea bx, Letra
    mov cs:[bx], ah

    ; obtener vector actual de INT 09h
    mov ax, 3509h
    int 21h               ; ES:BX → vieja ISR 09h
    mov old09_ofs, bx
    mov old09_seg, es

    ; instalar nuestra ISR
    mov dx, offset new09
    mov ax, 2509h
    int 21h

    ; cartel de confirmación
    mov dx, offset MsgOK
    mov ah, 09h
    int 21h

    ; mostrar la tecla que se suprimirá (ASCII en AL)
    mov dl, al
    mov ah, 02h
    int 21h

    mov dx, offset MsgTail
    mov ah, 09h
    int 21h

    ; dejar el programa residente
    mov ax, offset FinResidente
    add ax, 15
    shr ax, 4              ; bytes → parágrafos
    mov dx, ax
    mov ax, 3100h          ; terminate & stay resident
    int 21h

end start
