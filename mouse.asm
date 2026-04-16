;============================================================
; MOUSE_ABC.ASM (calibrado por filas de texto + TIMEOUT)
; Devuelve en AL:
;   'A', 'B' o 'C' según la fila donde se hizo clic
;   'Z' si el clic queda fuera de las 3 filas
;   0  si pasan ~10 segundos sin clic  (timeout)
;   Si no hay mouse → lee A/B/C por teclado.
;
; Suposición: modo texto 80x25, 640x200 → 8 pixels por fila.
;============================================================

.8086
.model small
.stack 100h

;------------------------------------------------------------
; CONFIGURACION: FILAS DE TEXTO PARA A / B / C
;   (0 = fila superior de la pantalla)
;------------------------------------------------------------
A_ROW  equ 9      ; fila donde está la opción A
B_ROW  equ 10     ; fila donde está la opción B
C_ROW  equ 11     ; fila donde está la opción C

ROW_H  equ 8      ; alto de una fila en pixels (modo 200 líneas)

;--- bandas de Y calculadas en pixels -----------------------
A_Y_TOP   equ (A_ROW * ROW_H)
A_Y_BOT   equ (A_ROW * ROW_H + ROW_H - 1)

B_Y_TOP   equ (B_ROW * ROW_H)
B_Y_BOT   equ (B_ROW * ROW_H + ROW_H - 1)

C_Y_TOP   equ (C_ROW * ROW_H)
C_Y_BOT   equ (C_ROW * ROW_H + ROW_H - 1)

.code
public leer_opcion_mouse_abc

leer_opcion_mouse_abc proc
    ; NO salvo AX porque AL es el retorno
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
    or  ax, ax
    jnz tiene_mouse        ; si AX!=0 → hay mouse
    jmp sin_mouse          ; si no hay mouse → teclado

tiene_mouse:
    ;----------------------------------------
    ; Limitar área del puntero
    ;   X: 2 .. 45  (primeros caracteres de la línea)
    ;   Y: desde la fila A hasta la fila C (solo 3 filas)
    ;----------------------------------------
    mov ax, 7                ; limitar eje X
    mov cx, 2                ; X min
    mov dx, 45               ; X max
    int 33h

    mov ax, 8                ; limitar eje Y
    mov cx, A_Y_TOP          ; Y min = fila de A
    mov dx, C_Y_BOT          ; Y max = fila de C
    int 33h

    ; Mostrar puntero
    mov ax, 1
    int 33h

    ;----------------------------------------
    ; Tomar tiempo inicial (para timeout ~10s)
    ;----------------------------------------
    mov ah, 00h
    int 1Ah
    mov si, dx               ; si = tick inicial

;----------------------------------------
; Esperar clic (botón izquierdo) con TIMEOUT
;----------------------------------------
esperar_presion:
    mov ax, 3
    int 33h          ; BX=botones, CX=X, DX=Y
    test bx, 1
    jnz  esperar_suelta

    ; ---- chequear timeout (~10 s = 182 ticks) ----
    mov ah, 00h
    int 1Ah
    mov cx, dx        ; tick actual
    sub cx, si        ; cx = diferencia
    cmp cx, 273 ;15 segundos de espera 
    jb  esperar_presion

    ; TIMEOUT → devolvemos AL=0
    mov al, 0
    jmp fin_mouse

esperar_suelta:
    mov ax, 3
    int 33h
    test bx, 1
    jnz esperar_suelta

    ; DX = Y del clic
    mov ax, dx      ; usamos AX para comparar

    ;----------------------------------------
    ; Decidir A / B / C según la fila (Y)
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
    int 21h                  ; AL = tecla (sin eco)

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
