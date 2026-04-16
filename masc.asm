.8086
.model small
.stack 100h

.data
    dato  db 01110110b
    masc1 db 00000011b
    masc2 db 10000000b
    pasoAlgo db "hoo salto la mascara 1",0dh,0ah,'$'


.code

    main proc
     
     mov ax , @data
     mov ds , ax 

     mov al , dato
     mov ah, masc1

     and al , ah ; el resultado queda en al 
     cmp al , 0 
     je noPasaNada
     
     mov ah , 09h
     mov dx , offset pasoAlgo
     int 21h

     noPasaNada:
  


        mov ax , 4c00h
        int 21h

    main endp
end    