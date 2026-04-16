;============================================================
; TEMPORIZADOR_OK.COM
; Interrupción INT 61h → Temporizador de 10 s
; Cumple con el requisito de ser residente (.COM)
; y no interfiere con teclado ni reloj.
;------------------------------------------------------------
; AH = 0 → iniciar conteo
; AH = 1 → consultar (AL=1 si pasaron 10 s, AL=0 si no)
;============================================================

.8086
.model tiny
.code
org 100h

start:
    mov ax,cs
    mov ds,ax
    mov es,ax

    ; Instalar INT 61h
    mov dx,offset int61h
    mov ax,2561h
    int 21h

    mov dx,offset msg_ok
    mov ah,09h
    int 21h

    ; Dejar residente (cumple requisito)
    mov dx,offset fin
    sub dx,100h
    mov ah,31h
    int 21h

;------------------------------------------------------------
; INT 61h  → servicios del temporizador
;------------------------------------------------------------
int61h:
    cmp ah,0
    je start_timer
    cmp ah,1
    je check_timer
    iret

; AH=0 → iniciar conteo
start_timer:
    push ax
    push cx
    push dx
    mov ah,00h
    int 1Ah                ; hora BIOS
    mov word ptr cs:[t_inicio],dx
    pop dx
    pop cx
    pop ax
    iret

; AH=1 → consultar
check_timer:
    push ax
    push bx
    push cx
    push dx
    mov ah,00h
    int 1Ah
    mov bx,dx
    sub bx,word ptr cs:[t_inicio]
    mov al,0
    cmp bx,182             ; 182 ticks ≈ 10 s
    jb corto
    mov al,1
corto:
    pop dx
    pop cx
    pop bx
    pop ax
    iret

;------------------------------------------------------------
msg_ok db 0Dh,0Ah,'INT 61h (temporizador 10 s) instalada!$'
t_inicio dw 0
fin:
end start
