.8086
.model small
.stack 100h

.data
    cartel db "Bienvenido al programa..." ,0dh,0ah
           db "Ingrese una oracion..." ,0dh,0ah
           db "Para luego cambiar las letras dsp del espacio...";0dh,0ah,'$'
    enters db 0 ,0dh,0ah,'$'
    texto_ingresado db 256 dup(24h) ,0dh,0ah,'$'
    texto_modificado db 256 dup (24) ,0dh,0ah,'$'


.code
    main proc


        mov ax , @data
        mov ds , ax 
    
        mov ah,09h
        lea dx , cartel
        int 21h
    
        mov bx, 0

    carga_texto:
        mov ah , 01h
        int 21h
        cmp al , 0dh
        je fin_carga
        mov texto_ingresado[bx] , al 
        mov texto_modificado [bx] , al 
        inc bx 

    jmp carga_texto    


    fin_carga:
        mov texto_ingresado [bx] , '$'
        mov texto_modificado[bx] , '$'
        mov bx , 0 
    jmp primer_caracter
            
    
    ;comparo si es enter
    proceso:
        mov al , texto_modificado[bx]
        cmp texto_modificado[bx] ,24h
        je fin_programa
        cmp al , 20h 
        je sera_palabra
    jmp incrementa    


    sera_palabra: ; si encontre espacio primero aumento en 1
        inc bx
    primer_caracter:    
        cmp texto_modificado[bx] , 'a'   ;cambio la letra si es minuscula 
        jb incrementa
        cmp texto_modificado[bx] , 'z' 
        ja incrementa ;si es mayor que z saltar
        sub texto_modificado[bx] ,20h 
    

    
    incrementa:    
        inc bx
    jmp proceso

  

    fin_programa:

        mov ah, 09h
        lea dx , texto_ingresado
        int 21h

        mov ah ,09h
        lea dx, texto_modificado
        int 21h

        mov ax , 4c00h
        int 21h    
    main endp
end    