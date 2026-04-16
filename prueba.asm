.8086
.model small
.stack 100h

.data
    menu db "Bienvenido al programa..." , 0dh,0ah
         db "Ingrese una oracion para luego poder cambiar las b x J" ,0dh,0ah,'$'
    texto_a_ingresar db 256  dup (24h) ,0dh,0ah,'$'
    texto_ingresado db 256 dup (24h) ,0dh,0ah, '$'
  
.code

    main proc 
        mov ax, @data
        mov ds ,ax

    mov ah , 09h
    mov dx , offset menu 
    int 21h

    mov bx ,0

    carga:
        mov ah , 01h
        int 21h
        cmp al , 0dh
        je fin_carga
        mov texto_a_ingresar [bx] ,al
        mov texto_ingresado [bx] ,al
        inc bx   
    jmp carga    
    

    fin_carga:
        mov bx,0
 

    compara:
      cmp texto_ingresado[bx] , 24h
      je fin
      cmp texto_ingresado[bx] ,'b'
      je cambiar_b
      
    incrementa:
        inc bx
    jmp compara

    cambiar_b:
        mov texto_ingresado[bx]  , 'f'
        jmp incrementa

  

    fin:
        mov ah ,09h
        mov dx , offset texto_ingresado
        int 21h
        
        mov ax , 4c00h
        int 21h

    main endp
end    