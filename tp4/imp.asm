.8086
.model small


.code  
    public imprimir_pantalla
    imprimir_pantalla proc
        push bx 
        push si

        mov ah , 09h
        
        int 21h    


        pop si
        pop bx 
    ret
    imprimir_pantalla endp
end    