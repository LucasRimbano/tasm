.8086
.model small
.stack 100h
.data
    menu db "Bienvenido mi broder..." ,0dh,0ah
         db "Que quiere hacer?" ,0dh,0ah
         db "Comprar marca 1",0dh,0ah
         db "Vender marca 2", 0dh,0ah
         db "Consultas marca 3", 0dh,0ah, "$"

    opcion1 db "Eligio comprar..." ,0dh,0ah
    opcion2 db "Eligio vender...",0dh,0ah
    opcion3 db "Eligio consultas..." ,0dh,0ah,"$"
.code
    main proc
        mov ax, @data
        mov dx, ax 

    
        mov ah, 09h
        mov dx, offset menu
        int 21h


    entrada:
        mov ax, 01h
        int 21h
        cmp al ,"1"
        je imprime1
        cmp al ,"2"
        je imprime2
        cmp al ,"3"
        je imprime3
    jmp entrada

    imprime1:
        mov ax, 09h
        mov dx, offset opcion1
        int 21h
    jmp fin
    
    imprime2:
        mov ax,09h
        mov dx, offset opcion2
        int 21h
    jmp fin
    
    imprime3:
        mov ax, 09h
        mov dx, offset opcion3
        int 21h
    


    

    
    fin:
        mov ah , 4ch
        int 21h
        
    main endp
end
