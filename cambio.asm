.8086 
.model small
.stack 100h

.data
    menu db "Bienvenidos al programa super galactico" ,0dh,0ah
         db "Ingrese un texto para poder cambiar las a  por las O..." ,0dh,0ah, '$'
    texto_a_ingresar db 256 dup (24h) ,0dh,0ah,'$'
    texto_modificado db 255 dup (24h), 0dh,0ah,'$'

.code
    main proc
        mov ax , @data
        mov ds ,ax 

        mov ah ,09h
        mov dx, offset  menu
        int 21h

        mov bx, 0 
    carga_texto:
        mov ah , 01h
        int 21h
        cmp al, 0dh
        je fin_carga_texto
        mov texto_a_ingresar[bx] , al
        mov texto_modificado[bx] , al
        inc bx 
    jmp carga_texto
    
    fin_carga_texto :
        mov bx, 0


    comparar:
        cmp texto_modificado [bx] , 24h
        je fin_programa
        cmp texto_modificado[bx] , 'a'
        je cambiar_minusc
        cmp texto_modificado [bx] , 'A'
        je cambiar_mayusc


    incrementar:
        inc bx
    jmp comparar

    cambiar_minusc:
        mov texto_modificado[bx] , 'o'
    jmp incrementar
    
    cambiar_mayusc:
        mov texto_modificado[bx] , 'O'
    jmp incrementar    
           




    

    fin_programa:

        mov ah ,09h
        mov dx , offset texto_a_ingresar
        int 21h

        mov ah , 09h
        mov dx ,offset texto_modificado
        int 21h

        mov ax , 4c00h
        int 21h

    main endp
end        