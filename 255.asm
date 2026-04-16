;Ingrese un texto de hasta 255 caracteres terminados por el signo $.Imprima el
;texto modificando la letra a por la letra x. Imprima el texto modificado y luego
;el texto original
.8086
.model small
.stack 100h
.data
    texto_255 db 255 dup (24h),0dh,0ah,'$'
    menu db     "Este programa va a cambiar  las a por la x..." ,0dh,0ah
         db     "Ingrese un texto cualquiera...",0dh,0ah,'$' 
       
.code
    main proc
  
    mov ax , @data
    mov ds,ax

    mov ah, 09h 
    mov dx, offset menu
    int 21h

    mov bx, 0 ;inicializo el base segment en cero el indice es bx 

    
    carga:
        cmp bx, 256
	    je fin_carga
        mov ah, 01h
        int 21h
        cmp al ,0dh  ; comparo si el caracter es un enter si no es un enter guardo el caracter en el texto incremento dx y pego la vuelta
        je fin_carga
        mov texto_255 [bx],al 
        inc bx 
    jmp carga
    
    fin_carga:
        mov bx , 0


    comparar:
        cmp textoMod[bx], 24h
	    je finCompara
        cmp texto_255 [bx] , 'a'
        je cambio_a
        cmp texto_255[bx] , 'A'
        je cambio_A
    
    incrementa:
        inc bx
    jmp compara        

    cambio_a:
        mov texto_255 [bx] , 'x'
        jmp incrementa
    cambio_A:
        mov texto_255 [bx] , 'X'
        jmp incrementa


    finCompara:
        mov ah , 09h
        mov dx , offset texto_255
        int 21h

        mov ah, 2
	    mov dl, 0dh
	    int 21h

      	mov ah, 2
 	    mov dl, 0ah
	    int 21h

    
        mov ah , 4ch
        int 21h

    main endp
end