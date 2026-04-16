;3. Ingrese un texto e imprímalo con la primer letra de cada palabra en mayúscula
.8086
.model small
.data
    cartel db "Bienvenido al programa NINO GUEY!..." ,0dh,0ah
           db "Ingrese un texto...." ,0dh,0ah
           db "Para luego cambiar las primeras palabras de cada letra..." ,0dh,0ah, '$'
    texto_ingresado db 256 dup (24h) ,0dh,0ah,'$'
    enters db 0 ,0dh,0ah,'$'
    cartel_final db 256 dup (24h) ,0dh,0ah,'$'
 

.code
    main proc

        mov ax , @data
        mov ds ,ax

         
        mov ah ,09h 
        lea dx , cartel 
        int 21h
    jmp fin_programa    
   
        mov bx , 0
   texto:
        mov ah , 01h
        int 21h
        

        cmp al , 0dh
        je fin_carga
        
        jmp primerLetra

        
        mov texto_ingresado [bx] ,al 
        cmp al , 20h ; comparando con el espacio 
        je Es_Espacio
        inc bx
    jmp texto    

    fin_carga:
        mov bx , 0  

  
   
    
    Es_Espacio:
        sub texto_ingresado[bx] , 20h
        mov cartel_final[bx],al 
    jmp texto    

    
    fin_programa:
        mov ah ,09h
        lea dx , texto_ingresado
        int 21h

        mov ah ,09h
        lea dx , enters
        int 21h
         
        mov ax , 4c00h
        int 21h



    main endp
end    