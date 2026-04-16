.8086
.model small
.stack 100h
;reliza un prgorama que lea un texto de 255 carcat
;luego lea 2 letras y estas letras debe rempoalzar por #
;luego cantid remplazos y largo texto total


.data

    cartel db "Bienvenido al programa..." ,0dh,0ah
           db "Ingrese una oracion...." ,0dh,0ah
           db "Para luego cambiar 2 letras por #..." ,0dh,0ah
           db "Despues mostramos cantidad remplazos y largo total... " ,0dh,0ah,'$'
    texto_ingresado db 256 dup (24h) ,0dh,0ah,'$'
    texto_modificado db 2456 dup (24h) ,0dh,0ah,'$'
    cartel_uno db "Ingrese la primer letra a cambiar..." ,0dh,0ah
    cartel_dos db "Ingrese la segunda letra a cambiar..." ,0dh,0ah,'$'
    letra_uno db 0 ,0dh,0dh,'$'
    letra_dos db 0  ,0dh,0ah,'$'
    

.code

    main proc
        mov ax , @data
        mov ds , ax

        mov ah ,09h
        lea dx , cartel
        int 21h
        
        mov ah ,09h
        lea dx , cartel_uno
        int 21h

        mov ah ,01h
        int 21h
        mov letra_uno ,al


        mov ah ,09h
        lea dx, cartel_dos
        int 21h

        mov ah, 01h
        int 21h
        mov letra_dos ,al


        mov bx , 0 

    carga_texto:
        mov ah , 01h
        int 21h
       
        cmp al , 24h
        je fin_carga

        cmp al , 0dh
        je fin_programa

        mov texto_ingresado[bx] , al 
        mov texto_modificado [bx] ,al 

        inc bx
    jmp carga_texto
    fin_carga:
        mov texto_ingresado[bx] , '$'
        mov bx , 0     

        mov ah ,09
        lea dx , cartel_uno
        int 21h

        mov ah ,09
        lea dx , cartel_dos
        int 21h
    
    


    fin_programa:
        mov ax , 4c00h
        int 21h

    main endp

end        