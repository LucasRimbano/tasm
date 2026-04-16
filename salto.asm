; contar cuantos espacios hay en una oracion
; cambiar las vocales por mayuscula
.8086
.model small
.stack 100h

.data

    cartel_bienvenida db "Ingrese una oracion para luego poder contar los espacios" ,0dh,0ah,'$'
    texto_ingresado db 256  dup  (24h),0dh,0ah,'$'
    espacios db 0 ,0dh,0ah,'$'    ;cant espacios
   
    
.code

    main proc
        mov ax ,@data
        mov ds , ax

        mov ah, 09h
        mov dx, offset cartel_bienvenida
        int 21h   
        
        mov bx ,0 
    cargar:
        mov ah , 01h  ;ingresame algo por teclado
        int 21h
        cmp al , 0dh
        je fin_carga
        cmp al ,20h
        jne no_espacio 
        inc espacios

        mov texto_ingresado[bx] ,al 
        inc bx 
    no_espacio:    
        jmp cargar   ; caso de volver al loppp 
     
    

    fin_carga:
        mov bx , 0 
    jmp fin_programa 

    fin_programa:
        
        mov ah , 09h
        mov dx ,offset cartel_bienvenida
        int 21h
        
         ; ax registro acumuilador  ah , al 
      ; convertir en ASCII
        mov al , espacios ;copiame los espacios en al
        add al , 30h  ; sumo 1 en bin
        mov dl ,al ;copiame en al lo que esta en dl   

        mov ah , 02h ;imprimir 1 caracter solo
        int 21h
        
        mov ah ,09h
        mov dx , offset espacios
        int 21h

        mov ax ,4c00h
        int 21h     
    
    main endp
end    