.8086
.model small
.stack 100h

.data
    var db 255
    nroAscii db '159' ,0dh,0ah,'$' ; variable donde van los 3 digitos convertidos
    dataDiv db ,100 ,10 ,1    ; uso de la forma arimtica para sumar  100 *x + 10*x + 1*X




.code
    main proc
        mov ax , @data
        mov ds , ax 

        mov ah , 0          ;voy a multiplicar *10 *100 y *1 el numero que esta en ax
        mov al , nroAscii[0]  ;tengo en al  31h
        sub al , 30h        ; tengo en al 1
        mov dl , 100
        mul dl 
        add var , al    ; le sumo al resultado
        
        mov ah , 0          ;voy a multiplicar *10 *100 y *1 el numero que esta en ax
        mov al , nroAscii[1] 
        sub al , 30h  ;tengo en al el 
        mov dl , 100
        mul dl 
        add var , al    ; le sumo al resultado


        mov ah , 0          ;voy a multiplicar *10 *100 y *1 el numero que esta en ax
        mov al , nroAscii[2] ;tengo en al el 35h
        sub al , 30h       ;tengo en al el 5 
        mov dl , 100
        mul dl 
        add var , al    ; le sumo al resultado

        
        mov al , 09h
        mov dx , offset nroAscii
        int 21h
        mov ax , 4c00h
        int 21h
    main endp
end    