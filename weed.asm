.8086
.model small
.stack 100h

.data
    Menu db "Bienvenido a mi programa..." ,0dh,0ah
    db "Ingrese un texto para poder cambiar las a por X" ,0dh,0ah,'$'
    texto_ingresado db 256 dup (24h) , 0dh,0ah,'$'
    texto_modificado db 256 dup (24h) ,0dh, 0ah,'$'
    


.code

    main proc
        mov ax , @data
        mov ds , ax

        mov ah , 09h
        mov dx , offset Menu
        int 21h
   
    mov bx ,0 ; inicializa la memoria en la poosicion 0

    carga_texto:  
        mov ah , 01h
        int 21h
        cmp al , 0dh    
        je fin_carga
        mov texto_ingresado[bx] , al
        mov texto_modificado[bx] ,al
        inc bx
    jmp carga_texto    
 
    fin_carga:
        mov bx ,0
   
    comparar:
    cmp texto_modificado[bx] , 24h  
    je fin_programa
    cmp texto_modificado [bx] , 'a'
    je cambiar_minusc
    cmp texto_modificado[bx] , 'A'
    je cambiar_mayusc
    
    incrementa:
        inc bx
    jmp comparar    

    cambiar_minusc:
        mov texto_modificado[bx] , 'x'
        jmp incrementa

    cambiar_mayusc:
        mov texto_modificado[bx] , 'X'
        jmp incrementa        

    fin_programa:
        mov ah , 09h
        mov dx , offset texto_modificado
        int 21h

        

        mov ax , 4c00h 
        int 21h 
    main endp
end    