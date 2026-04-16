.8086
.model small
.stack 100h
.data
    menu db "Bienvenido al programa...." ,0dh,0ah
         db "Ingrese un 1 para imprimir el cartel1" ,0dh,0ah
         db "Ingrese un 2 para mostrar falopa..." ,0dh,0ah
         db "Ingrese un 3 para el cartel 3...." ,0dh,0ah, "$"


    cartel1 db "CARTEL 1", 0dh,0ah,"$"
    cartel2 db "Cartel falopa2" ,0dh,0ah,"$"
    cartel3 db "Cartel 3 ..." ,0dh,0ah,"$"      
.code
    main proc
        mov ax, @data
        mov ds, ax

        mov ah, 09h
        mov dx, offset menu
        int 21h
    entrada:
        mov ah , 01h
        int 21h
        cmp al ,"1"
        je imprime1
        cmp al, "2"
        je imprime2
        cmp al ,"3"
        je imprime3
    jmp entrada    

    imprime1:
        mov ah ,09h
        mov dx, offset cartel1
        int 21h
    jmp fin
    imprime2:
        mov ah, 09h
        mov dx, offset cartel2
        int 21h
    jmp fin    
    
    imprime3:
        mov ah, 09h
        mov dx, offset cartel3
        int 21h
    
    fin:  
        mov ah ,4c00h
        int 21h

    main endp
end