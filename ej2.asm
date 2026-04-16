.8086 
.model small
.stack 100h

.data
 mensaje db "Bienvenido a mi primer print" ,odh,0da,24h.
.code

    main proc
        mov ax, @data
        mov ds,ax

        mov ah, 9
        mov dx , offset mensaje 
        int 21h

        mov ah , 4ch
        mov al,00h
        int 21h

       
    mainendp
endmain    