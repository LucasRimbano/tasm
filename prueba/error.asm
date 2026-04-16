; Reproduce un doble pip (grave + agudo) para indicar error.
.8086
.model small
.stack 100h

.code
public sonido_error

sonido_error proc
    push ax
    push bx
    push cx
    push dx

    
    ; 1° PIP GRAVE
    
    mov al, 0B6h
    out 43h, al

    mov ax, 3000          ; divisor => tono grave (~398 Hz)
    out 42h, al
    mov al, ah
    out 42h, al

    in al, 61h
    or al, 00000011b
    out 61h, al

    mov cx, 18000         ; duración pip 1
espera1:
    loop espera1

    
    ; Silencio breve entre pips
    
    in al, 61h ;61h es el parlante 
    and al, 11111100b
    out 61h, al

    mov cx, 8000
pausa:
    loop pausa

    
    ; 2° PIP AGUDO
    
    mov al, 0B6h
    out 43h, al

    mov ax, 1000          ; divisor => tono agudo (~1193 Hz)
    out 42h, al
    mov al, ah
    out 42h, al

    in al, 61h
    or al, 00000011b
    out 61h, al

    mov cx, 12000         ; duración pip 2
espera2:
    loop espera2

    
    ; Apagar altavoz
    
    in al, 61h
    and al, 11111100b
    out 61h, al

    pop dx
    pop cx
    pop bx
    pop ax
    ret
sonido_error endp

end
