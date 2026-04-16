;ingfresar una oracion 
;mosrtrarrla en efecto espejo 
; ej gola alog 
.8086
.model small
.stack 100h

.data
   cartel db "Ingrese una oracion..." ,0dh,0ah
          db "Para luego mostrarla en efecto espejo..." ,0dh,0ah,'$'
   texto_ingresado db 256 dup (24h) ,0dh,0ah,'$'
   numeros_espacios db 0 ,0dh,0ah,'$'
   
   


.code
    main proc
        mov ax , @data
        mov ds, ax 
        

        mov ah , 09h
        mov dx , offset cartel
        int 21h

        mov bx, 0  
    carga_texto:
        mov ah ,01h    
        int 21h
        cmp al , 0dh 
        je fin_carga
        cmp al , 20h ; espacio
        jne no_espacio
        mov texto_ingresado[bx], al
        inc bx
        inc numeros_espacios


    no_espacio:
        jmp carga_texto    

    fin_carga:
        mov bx, 0 
    jmp fin_programa     

            

    fin_programa:
        
       ; +1 bin
        mov al , numeros_espacios ;valor guardo en contador de epsacio 2 :D 
        add al , 30h ;0001
        mov dl , al

        mov ah, 02h ;print caracater a caracter 
        int 21h
        
          
        mov ax ,4c00h
        int 21h

    main endp
end    