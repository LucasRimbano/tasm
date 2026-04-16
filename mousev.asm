;============================================================
; MOUSE_ABC.ASM 
; Devuelve en AL:
;   'A', 'B' o 'C' según Y del clic
;   'Z' si clic fuera de las bandas
;   Si no hay mouse → lee A/B/C por teclado.
;============================================================

.8086
.model small
.stack 100h

A_Y_TOP   equ 70
A_Y_BOT   equ 82

B_Y_TOP   equ 83
B_Y_BOT   equ 95

C_Y_TOP   equ 96
C_Y_BOT   equ 108

.code
public leer_opcion_mouse_abc

leer_opcion_mouse_abc proc
    ; OJO: NO guardo AX porque AL es el valor de retorno
    push bx
    push cx
    push dx
    push si
    push di

    ;----------------------------------------
    ; Inicializar mouse
    ;----------------------------------------
    mov ax, 0
    int 33h
    cmp ax, 0
    je  sin_mouse            ; si no hay mouse → teclado

    ;----------------------------------------
    ; Limitar área del puntero
    ;   X: 2 .. 45
    ;   Y: 75 .. 90
    ;----------------------------------------
    mov ax, 7                ; limitar eje X
    mov cx, 2                ; X min
    mov dx, 45               ; X max
    int 33h

    mov ax, 8                ; limitar eje Y
    mov cx, 75               ; Y min
    mov dx, 90               ; Y max
    int 33h

    ; Mostrar puntero
    mov ax, 1
    int 33h

;----------------------------------------
; Esperar clic
;----------------------------------------
esperar_presion:
    mov ax, 3
    int 33h          ; BX=botones, CX=X, DX=Y
    test bx, 1
    jz  esperar_presion

esperar_suelta:
    mov ax, 3
    int 33h
    test bx, 1
    jnz esperar_suelta

    ; DX = Y del clic
    mov ax, dx      ; usamos AX como registro de trabajo

    ;----------------------------------------
    ; Decidir A / B / C según Y
    ;----------------------------------------

    ; ¿A?
    cmp ax, A_Y_TOP
    jb  no_A
    cmp ax, A_Y_BOT
    jbe es_A
no_A:

    ; ¿B?
    cmp ax, B_Y_TOP
    jb  no_B
    cmp ax, B_Y_BOT
    jbe es_B
no_B:

    ; ¿C?
    cmp ax, C_Y_TOP
    jb  click_fuera
    cmp ax, C_Y_BOT
    jbe es_C

    jmp click_fuera

es_A:
    mov al, 'A'
    jmp fin_mouse

es_B:
    mov al, 'B'
    jmp fin_mouse

es_C:
    mov al, 'C'
    jmp fin_mouse

click_fuera:
    mov al, 'Z'
    jmp fin_mouse

;----------------------------------------
; Fallback: NO hay mouse → leer teclado
;----------------------------------------
sin_mouse:
    mov ah, 08h
    int 21h                  ; AL = tecla

    ; pasar a mayúscula
    cmp al, 'a'
    jb  fin_mouse
    cmp al, 'z'
    ja  fin_mouse
    sub al, 20h              ; 'a'..'z' → 'A'..'Z'

;----------------------------------------
; Salida
;----------------------------------------
fin_mouse:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    ret
leer_opcion_mouse_abc endp

end
