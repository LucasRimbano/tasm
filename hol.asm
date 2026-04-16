.8086
.model small
.stack 100h

.data
    cartel db "Bienvenido al programa...." ,0dh,0ah
           db "Prorama hecho por lucas rimbano..." ,0dh,0ah 
           db "Ingrese una oracion..." ,0dh,0ah
           db "Para cambiar minusc a mayusc" ,0dh,0ah
           db "Luego en otra variable cambiar los espacios por _" ,0dh,0ah,'$'
    enters db 0 ,0dh,0ah,'$'
    texto_a_ingresar db 256  dup(24h) ,0dh,0ah,'$'
    texto_modificado db 256 dup (24h) ,0dh,0ah,'$'
    texto_con_guion_bajo db 256 dup (24h) , 0dh,0ah,'$'
    

.code
main proc
    mov ax , @data
    mov ds , ax 
   
    mov ah , 09h
    lea dx , cartel
    int 21h
    
    mov bx , 0
    carga_texto:
        mov ah , 01h
        int 21h

        cmp al , 0dh
        je fin_carga


        mov texto_a_ingresar [bx] , al
        mov texto_modificado [bx] ,al
        inc bx
    jmp carga_texto

    fin_carga:
        mov texto_a_ingresar[bx] ,24h
        mov texto_modificado [bx] ,24h
        mov bx , 0

    comparar:
        mov al , texto_modificado [bx]
        cmp al , 24h
        je fin_comparar

        cmp al , 'a'
        jb no_cambio
        cmp al , 'z'
        ja no_cambio
        sub al , 20h
   

    no_cambio:
        mov texto_modificado[bx] ,al 
        inc bx 
    jmp comparar


    fin_comparar:
        mov texto_modificado[bx], 24h
        mov bx , 0

    comparar_espacio:
        mov al , texto_a_ingresar [bx]
        cmp al , 24h
        je fin_espacio

        cmp al , 20h
        jne copiar_normal
        mov al , '_'
        
        

    copiar_normal:
        mov texto_con_guion_bajo[bx] ,al 
        inc bx 
        jmp comparar_espacio
    fin_espacio:
        mov texto_con_guion_bajo [bx] ,24h

    fin_programa:
     
        mov ah , 09h
        lea dx , texto_a_ingresar 
        int 21h

        mov ah , 09h
        lea dx , enters
        int 21h

        mov ah , 09h
        lea dx, texto_modificado
        int 21h 

        mov ah , 09h
        lea dx, enters
        int 21h

        mov ah , 09h
        lea dx, texto_con_guion_bajo
        int 21h

         mov ax , 4c00h 
         int 21h



    main endp
end    