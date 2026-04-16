.8086
.model small
.stack100h
.data
    menu db "ingrese 1 para inmprimir el cartel 1" , 0dh,0ah
         db "ingrese 2 para imprimir el cartel 2" , 0dh,0ah,
         db "Ingrese 3 para imprimir el cartel 3" , 0dh,0ah,'$'
    cartel1 db "cartel 1" ,0dh,0ah,"$'
    cartel2 db "cartel 2" ,0dh,0ah,'$'
    cartel3 db "cartel 3" , 0dh,0ah,'$'
.code
main proc
    mov ax, @data
    mov ds, ax

    mov ax,9
    mov dx, offset menu
    int 21h
 arriba:   
    mov ax,1
    int 21h
    cmp al, "1"
    je imprime1
    cmp al,"2"
    je imprime2
    cmp al, "3"
    je imprime3
 jmp arriba   

imprime1:
    mov ax,9
    mov dx, offset cartel1
    int 21h
jmp fin

imporime2:
    mov ax,9
    mov dx, offset cartel2
    int 21h
jmp fin

imprime3:
    mov ax,9
    mov dx, offset cartel3
    int 21h
jmp fin   


fin:    
    mov ax, 4c00h
    int 21h


    mov ah,4ch
    int 21h
   main endp
main        