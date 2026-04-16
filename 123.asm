;ingrese una oracion cuento espacios y cambio las vocales mayusculas por minusculas
.8086
.model small
.stack 100h

.data 
    titulo db "Ingrese una oracion..." ,0dh,0ah
           db "1-Para luego contar espacios..." , 0dh,0ah
           db "2-Para cambiar vocales mayusc x minusc..." ,0dh,0ah
           db "Muchas gracias..." , 0dh,0ah,'$'
    texto_ingresado db  256 dup (24h) ,0dh,0ah,'$'       
    texto_modificado db 256 dup (24h) ,0dh,0ah,'$'
    contador db 0 
    reg2ascii db "000"
    datadiv db 100,10,1
    

.code

    main proc
        mov ax , @data
        mov ds, ax 
    
    mov ah ,09h
    lea dx , titulo
    int 21h 
    
    mov bx, 0

    carga_texto:
        mov ah ,01h
        int 21h
        cmp al, 0dh
        je fin_carga
        mov texto_ingresado[bx] , al 
        cmp al, 41h
        je esVocal
        cmp al, 45h
        je esVocal
        cmp al , 49h
        je esVocal
        cmp al , 4fh
        je esVocal
        cmp al , 55h
        je esVocal
        
        cmp al , 20h
        jne guardo_texto
        inc contador

     guardo_texto:
        mov texto_modificado[bx], al ; guardo el texto modificado
        inc bx
     jmp carga_texto 

    esVocal:
        ;sumar 32
        add al ,20h 
        jmp guardo_texto

    fin_carga:
        mov texto_ingresado[bx] , 24h
        mov texto_modificado [bx] ,24h
     
   
    



    convertidor:
        mov al , contador
        add al , 30h  ; convierto ascii
        mov dl ,al
        mov ah , 02h ;imprimir 1 caracter solo
        int 21h

        mov dl ,al ;copiame en al lo que esta en dl   

    jmp fin_programa   
    fin_programa:

       mov ah ,09h 
       lea dx , texto_ingresado
       int 21h

       mov ah ,09h
       lea dx , texto_modificado
       int 21h
        

        
         
        mov ax , 4c00h
        int 21h


    main endp
end    