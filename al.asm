.8086
.model small
.stack 100h

.data
    cartel db "Ingrese un cartel motherfucker..." ,0dh,0ah,'$'
    texto_a_ingresar db 256 dup (24h) ,0dh,0ah,'$'
    enters db 0  ,0dh,0ah,'$'



.code
main proc

    mov ax , @data
    mov ds , ax 

    mov ah, 09h
    lea dx , cartel
    call mostar_cadena
    
    
    mov bx , 0 

carga_texto:    
    mov ah , 01h
    int 21h
    cmp al,0dh
    je fin_carga
    mov texto_a_ingresar[bx] ,al
    inc bx 
    jmp carga_texto

fin_carga:
    mov texto_a_ingresar[bx],24h
 

    mov ah ,09h
    lea dx ,enters
    int 21h


    mov ah , 09h
    lea dx , texto_a_ingresar
    int 21h



    mov ax , 4c00h
    int 21h

    
    main endp
end       