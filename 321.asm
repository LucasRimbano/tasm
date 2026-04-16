.8086
.model small
.stack 100h

.data
    cartel db "Bienvenido al programa..." ,0dh,0ah
           db "Ingrese un texto..." ,0dh,0ah
           db "Para luego mostrar en espejo..." ,0dh,0ah,'$'
    texto_ingresado db 5 dup (24h) ,0dh,0ah, '$'
    enters db 10 ,0dh,0ah,'$'
    espejo db 5 dup (24h) ,0dh,0ah,'$' ;LUCAS \ SACUL
    
.code
    main proc
        mov ax , @data
        mov ds , ax 
    
        mov ah ,09h
        lea dx , cartel
        int 21h
    
        mov cx , 5
        mov bx , 0   
      
    carga:
        mov ah , 01h       
        int 21h
        mov texto_ingresado[bx] ,al
        inc bx 
    loop carga
      
     mov ah , 09h
        lea dx , enters
        int 21h

    ;imprimir al reves en espejo
      mov cx, 5
      mov bx,4  

      ;HOLA  texto_ingresado[bx] HOLA --> espejo[bx] A;L;O;H
    alreves:
        mov ah, 02H ;te imprime caracter a caracter
        mov dl , texto_ingresado[bx] 
        int 21h
        dec bx 
    loop alreves    
 
        
    
    limpia:
        cmp espejo[bx], 24h
        je fin_limpia
        inc bx
        jmp limpia
     
    fin_limpia:

    jmp fin_programa

    fin_programa:
         
        mov ah , 09h
        lea dx , enters
        int 21h

        mov ah, 09h
        lea dx , texto_ingresado
        int 21h

        mov ax,  4c00h
        int 21h


    main endp
end    