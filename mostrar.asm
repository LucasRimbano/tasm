.8086
.model small
.code

public mostrar_cartel

mostrar_cartel proc
    push ax 
    push dx

    mov ah, 09h
    int 21h

    pop dx
    pop ax 
    ret
mostrar_cartel endp

end mostrar_cartel
