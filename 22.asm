.8086
.model small
.stack 100h


.code
public imprimir_pantallaa

    imprimir_pantallaa proc
    push bx
    push si 
    mov ah ,09h
    int 21h

    pop si
    pop bx 
    ret 
    imprimir_pantallaa endp
end    