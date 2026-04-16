; TEMPORIZADOR.ASM
; Libreria de temporizador para preguntas
; Uso:
;   call iniciar_temporizador
;   ...
;   call tiempo_expirado
;   cmp al,1 → tiempo agotado
.8086
.model small
.stack 100h

.data
tick_inicio dw 0

.code
public iniciar_temporizador, tiempo_expirado


; Inicia conteo de tiempo

iniciar_temporizador proc
    push ax
    push dx
    mov ah,00h
    int 1Ah                ; obtener hora del BIOS
    mov tick_inicio,dx
    pop dx
    pop ax
    ret
iniciar_temporizador endp


; Verifica si pasaron 10 segundos
; Devuelve AL = 1 si sí, 0 si no

tiempo_expirado proc
    push ax
    push bx
    push cx
    push dx
    mov ah,00h
    int 1Ah
    mov bx,dx
    sub bx,tick_inicio
    mov al,0
    cmp bx,182             ; 182 ticks ≈ 10 s
    jb  no
    mov al,1
no:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
tiempo_expirado endp

end
