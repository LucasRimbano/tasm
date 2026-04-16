.8086 
.model small
.stack 100h


.data
    menu db "Bienvenido pedrinnnn como estas tu" ,0dh,0ah
         db "OPCION 1 si quiere salchicha" ,0dh,0ah
         db "OPCION 2 si queres salame",0dh,0ah
         db "OPCION 3 si queres queso" ,0dh,0ah,'$'
    opcion1 db "Eelegiste salchicha panchoo" ,0dh,0ah, '$'
    opcion2 db "Elegiste salame cala boca liyo" ,0dh,0ah, '$'
    opcion3 db "Elegiste queso quesorete sos" ,0dh,0ah,'$'
.code

    main proc
       mov ax, @data
       mov ds, ax

       mov ah , 09h
       mov dx , offset menu
       int 21h

       entrada:

       mov ah, 01h ;ax es registro acumulador
       int 21h
       cmp al, '1'          ;al low,   ah high, entonces se subdividen
       je imprime1          ;je va a saltar si al cmp con "1", que salte a imprime1
       cmp al,'2'
       je imprime2
       cmp al, '3'
       je imprime3
    jmp entrada

       imprime1:
       mov ah, 09h
       mov dx, offset opcion1
       int 21h
       jmp fin

        imprime2:
       mov ah, 09h
       mov dx, offset opcion2
       int 21h
       jmp fin

       imprime3:
       mov ah, 09h
       mov dx, offset opcion3
       int 21h
       jmp fin






    fin:
       mov ah, 4ch
       int 21h

    main endp
end