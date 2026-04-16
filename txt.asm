.8086
.model small
.stack 100h
.data
    public texto_a_ingresar
    texto_a_ingresar db 256 dup (0) ,'$'

.code
    public cargar_texto
   
    
    cargar_texto proc
    push ax
    push  bx 

    
    xor bx, bx      
 

    cargar:
        mov ah , 01h
        int 21h
        cmp al , 0dh
        je fin_carga

        mov texto_a_ingresar[bx] ,al
        inc bx
    jmp cargar    

    fin_carga:
       mov al , '$'
        mov texto_a_ingresar[bx] , al
       

    pop bx
    pop ax 
    ret
    cargar_texto endp

end    
    
    