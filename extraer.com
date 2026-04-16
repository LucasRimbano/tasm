;===============================================================
; HIDEKEY_SPD.COM
; --------------------------------------------------------------
; TSR que intercepta INT 09h (teclado)
; Bloquea las teclas 1..5 según la tabla "unidades_jugadas"
; del TP FINAL (leída vía seg_dgroup)
;
; COMPILAR:
;   tasm hidekey_spd.asm
;   tlink /t hidekey_spd.obj
;
; EJECUTAR:
;   hidekey_spd.com   → queda residente
;   luego ejecutar tu TP FINAL
;===============================================================

.8086
.model tiny
org 100h

start:
    jmp instalar

;---------------------------------------------------------------
; VARIABLES RESIDENTES
;---------------------------------------------------------------

old09_ofs dw ?
old09_seg dw ?

externSeg dw ?        ; seg_dgroup del TP FINAL
externOff dw ?        ; offset de unidades_jugadas

;---------------------------------------------------------------
; NUEVA ISR DEL TECLADO (INT 09h)
;---------------------------------------------------------------
new_int09 proc far
    pusha
    push ds

    ; Leer scancode del teclado (puerto 60h)
    in al, 60h

    ; ¿Es 1..5?  (scancodes: 1=02h 2=03h 3=04h 4=05h 5=06h)
    cmp al, 02h
    jb  go_old
    cmp al, 06h
    ja  go_old

    ; índice = scancode - 02h   (0..4)
    sub al, 02h
    mov si, ax

    ; DS ← seg_dgroup del TP (externSeg)
    mov ds, cs:[externSeg]

    ; DX ← offset unidades_jugadas + si
    mov dx, cs:[externOff]
    add dx, si

    ; ¿unidad jugada (1)? entonces bloquear
    cmp byte ptr ds:[dx], 1
    jne go_old     ; si es 0 → permitir

    ; BLOQUEAR TECLA
    pop ds
    popa
    jmp descartar

go_old:
    pop ds
    popa
    jmp cs:[old09_ofs]

;---------------------------------------------------------------
; Rutina estándar para descartar scancode
;---------------------------------------------------------------
descartar:
    cli
    in  al, 61h
    mov ah, al
    or  al, 80h
    out 61h, al
    mov al, ah
    out 61h, al
    mov al, 20h
    out 20h, al
    sti
    iret

new_int09 endp

;---------------------------------------------------------------
; INSTALADOR TSR
;---------------------------------------------------------------
instalar:
    ; DS = CS
    mov ax, cs
    mov ds, ax

    ; Leer seg_dgroup desde memoria del TP
    ; (tu TP FINAL hace mov [seg_dgroup], ds al iniciar)
    mov ax, cs
    mov es, ax
    mov ax, ds:[seg_dgroup]
    mov [externSeg], ax

    ; Guardar offset de unidades_jugadas
    mov [externOff], offset unidades_jugadas

    ; Obtener vieja INT 09h
    mov ax, 3509h
    int 21h
    mov [old09_ofs], bx
    mov [old09_seg], es

    ; Instalar nueva ISR
    mov dx, offset new_int09
    mov ax, 2509h
    int 21h

    ; Mostrar mensaje opcional
    mov dx, offset msgOK
    mov ah, 09h
    int 21h

    ; Dejar residente
    mov dx, (endResident - start + 15) / 16
    mov ax, 3100h
    int 21h

;---------------------------------------------------------------
; DATOS DE INSTALACIÓN
;---------------------------------------------------------------
msgOK db "HIDEKEY_SPD instalado! Teclas 1..5 protegidas.",13,10,'$'

; Esto NO importa su contenido, el TP real lo usa
unidades_jugadas db 0,0,0,0,0

seg_dgroup dw 0

endResident label byte

end start
