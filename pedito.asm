.8086
.model small
.stack 100h


.code 

 lea dx , cartel
    call mostrar_cartel

    mov ax , 4c00h
    int 21h

mostrar_cartel proc  

    mov ah , 09h 
    int 21h
    ret
mostrar_cartel endp