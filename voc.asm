.8086
.model small
.stack 100h
.data
    menu db "Bienvenido a mi programa..." , 0dh,0ah
         db "Ingrese una oracion para poder cambiar las vocales por mayusculas " ,0dh,0ah,'$'

    texto_ingresado db 256 dup (24h),0dh,04h,'$'
    texto_modificado db 256 dup (24h) ,0dh,0ah,'$'

.code

    main proc

        mov ax ,@data
        mov ds ,ax 

        mov ah ,09h
        mov dx, offset menu
        int 21h
        
        mov bx,0

    carga:
        mov ah , 01h
        int 21h
        cmp al , 0dh
        je fin_programa  
        mov texto_ingresado[bx] ,al
        mov texto_modificado [bx] ,al
        inc bx
    jmp carga      

    fin_carga:
        mov texto_ingresado[bx], '$'   ; terminador
        mov texto_modificado[bx], '$'  ; terminador
        mov bx,0 
    jmp carga       

    comparar:
        cmp texto_modificado[bx] , 24h
        je fin_programa
        cmp texto_modificado[bx] , 'a'
        je cambiar_a
        cmp texto_modificado[bx] , 'e'
        je cambiar_e
        cmp texto_modificado[bx] , 'i'
        je cambiar_i
        cmp texto_modificado[bx] ,  'o'
        je cambiar_o
        cmp texto_modificado[bx] , 'u'
        je cambiar_u 
    
    incrementa:
        inc bx 
    jmp comparar   

    cambiar_a:
        mov texto_modificado[bx] , 'A'
    jmp incrementa

    cambiar_e:
        mov texto_modificado[bx] , 'E'
    jmp incrementa   
    cambiar_i:
        mov texto_modificado[bx], 'I'
    jmp incrementa    
    cambiar_o:
        mov texto_modificado[bx], 'O'
    jmp incrementa

    cambiar_u:
        mov texto_modificado[bx] , 'U'
    jmp incrementa

    fin_programa:
        mov ah ,09h
        mov dx, offset texto_ingresado
        int 21h
        mov ah ,09h
        mov dx, offset texto_modificado
        int 21h
        mov ax, 4c00h
        int 21h
    main endp
end        