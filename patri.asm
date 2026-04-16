.8086
.model small
.stack 100h

.data

     cartel db "que onda capo dame toda la plata...." ,0dh,0ah,'$'
     texto_a_ingresar db 256 dup (24h) ,0dh,0ah,'$'
     texto_ingresado db 256 dup (24h) ,0dh,0ah,'$'
     enters db  0 ,0dh,0ah,'$'
     

.code

    mov ax, @data
    mov ds , ax

programa_principal:
    lea dx , cartel 
    call mostrar_cadena

    call ingresar_un_texto



    mov ax , 4c00h
    int 21h


    mostrar_cadena proc
    push ax
    push dx 
    pop dx 

    mov ah , 09h
   
    int 21h
    pop ax 
    ret
    mostrar_cadena endp


    ingresar_un_texto proc

   

    texto_carga:
        mov ah, 01h
        int 21h
     
        cmp al , 0dh
        je fin_carga
        mov texto_a_ingresar [bx] ,al 
        mov texto_ingresado [bx] ,al
        cmp al , 'd' 
        je cambio_letra

        inc bx
    jmp texto_carga
    cambio_letra:
        mov texto_ingresado[bx] , 'l'
        inc bx
    jmp texto_carga


    fin_carga:
        mov texto_a_ingresar [bx] , 24h
        mov texto_ingresado [bx] ,24h
        mov bx, 0   

        mov ah , 09h
        lea dx , enters
        int 21h
       
        mov ah , 09h 
        lea dx , texto_a_ingresar
        int 21h
        
        mov ah, 09h
        lea dx , enters
        int 21h

        mov ah , 09h
        lea dx,  texto_ingresado
        int 21h

        ret
    ingresar_un_texto endp

    
  
   
   





end
