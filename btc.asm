.8086
.model small
.stack 100h
.data
    mensaje db "Bienvenido a mi primer programa en asembler" ,0dh,0ah,'$' 


.code
    main proc
        mov ax, @data
        mov ds, ax
         
    
        mov ah, 09h 
        mov dx, offset mensaje
        int 21h 

        

        mov ah, 4ch 
        int 21h
    main endp
end    
