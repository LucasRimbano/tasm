;ingresa una oracion 
;luego contamos los espacios(pasa reg2ascii)
;y ademas cambiamos ! , ? , , ,
.8086
.model small
.stack 100h

.data
    cartel db "Bienvenido al programa..." ,0dh,0ah
           db "Ingrese una oracion...." ,0dh,0ah
           db "Para luego contar espacios..." ,0dh,0ah
           db "Y ademas cambiar los ! , ? , por espacio" ,0dh,0ah,'$'
    enters db 0 ,0dh,0ah,'$'
    texto_ingresado db 256 dup(24h) ,0dh,0ah,'$'
    texto_modificado db 256 dup (24h) ,0dh,0ah ,'$'
    contador_espacios db 0 ,0dh,0ah,'$'


.code
    main proc
        mov ax , @data
        mov ds , ax 
        
        mov ah , 09h
        lea dx, cartel
        int 21h

        mov bx , 0
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
        mov bx , 0    
       
    comparar:
        mov al , texto_modificado[bx]
        cmp texto_ingresado[bx] , 24h
        je fin_programa
        cmp texto_ingresado[bx] , 20h
        je es_Espacio
        cmp al , '?'
        je  es_Espacio
     incrementa:
        inc bx
    jmp comparar    

    es_Espacio:
        mov texto_modificado[bx] , 20h
        inc contador_espacios 
    jmp incrementa

   
    fin_programa: 
        
        mov ah ,09h
        lea dx , texto_ingresado
        int 21h
        
        mov ah ,09h
        lea dx, enters
        int 21h
    
        ;convertir en ascii
        mov al, contador_espacios
        add al , 30h
        mov dl , al 
       

        mov ah , 02h
        int 21h

        mov ah , 09h
        lea dx , enters
        int 21h
        
        mov ah , 09h
        lea dx, texto_modificado
        int 21h

        
    
        mov ax , 4c00h
        int 21h

    main endp

end    