;crea un programa que lea un texto y eliminar las , ? , ! 
;en otra variable imprimirlo dado vuelta

.8086
.model small
.stack 100h

.data
    cartel db "Bienvenido al programa..." ,0dh,0ah
           db "Ingrese un texto..." ,0dh,0ah
           db "Para luego eliminar los caracteres como , ? ,! ..." ,0dh,0ah
           db "Y despues mostrar en otra variable en espejo..." ,0dh,0ah ,'$'
    enters db 0 ,0dh,0ah,'$'
    texto_ingresado db 256 dup (24h) ,0dh,0ah,'$'
    texto_modificado db 256 dup (24h) ,0dh,0ah,'$'
    texto_espejo db 256 dup (24h), 0dh,0ah,'$'


.code
    main proc
        mov ax , @data
        mov ds , ax 

        mov ah, 09h
        lea dx , cartel 
        int 21h
        
        mov bx , 0
    carga_texto:
        mov ah , 01h ; aca pido por teclado al user 
        int 21h
        
        cmp al , 0dh  
        je fin_carga

        mov texto_ingresado [bx] , al ;guardar lo que el user meter al tecladeishon
        mov texto_modificado [bx] ,al ;guardo el texto a modificar ose sin caracter
        inc bx
    jmp carga_texto 


    fin_carga:
        mov texto_ingresado [bx] , '$'
        mov texto_modificado[bx] , '$'
        mov cx , bx
        mov bx , 0     
   
    comparar:
        mov al , texto_modificado[bx] ; guardame en al el texto a modificar para lugego procesar
        cmp al , 24h   ; comparo con el sigrno pesos $ para ver en donde termina el texto
        je Invertir_preparar
        cmp al , ',' 
        je es_Caracter
        cmp al , '?'
        je es_Caracter
        cmp al , '!'
        je es_Caracter
        cmp al , 20h
        je es_espacio
    incrementar:
        inc bx 
    jmp comparar
   
    es_espacio:

    es_Caracter:
        mov texto_modificado [bx] , 20h  ; dice si estoy aca en este loop quiere decri que estoy parado enuna coma entonces cambio por espacio 
        jmp incrementar
    
    fin_comparar:
        mov bx , 0 
        mov texto_modificado [bx] , 24h
    
    
    
    Invertir_preparar:
        mov cx , bx     ;guarda el largo del texto ignresado 
        dec bx    ;ultimo indice valido
        mov si, 0    ;indice para el texto espejo                     

    invertir:
        mov al, texto_ingresado[bx]      ; Cargar el carácter a invertir
        mov texto_espejo[si], al          ; Guardar en texto_espejo
        dec bx
        inc si
    loop invertir                       ; Repetir hasta que CX sea 0

        mov texto_espejo[si], '$'           ; Terminar la cadena espejo

     


    fin_programa:

       
         
        mov ah ,09h
        lea dx,  enters
        int 21h

        mov ah , 09h
        lea dx,  texto_modificado
        int 21h 
       
        mov ah ,09h
        lea dx, enters
        int 21h 

        mov ah ,09h 
        lea dx , texto_espejo
        int 21h 
        mov ax, 4c00h
        int 21h    

    main endp
end    