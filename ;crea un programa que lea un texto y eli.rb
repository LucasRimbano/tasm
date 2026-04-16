;crea un programa que lea un texto y eliminar las , ? , ! 
;en otra variable imprimirlo dado vuelta

.8086
.model small
.stack 100h

.data
    cartel db "Bienvenido al programa..." ,0dh,0ah
           db "Ingrese un texto..." ,0dh,0ah
           db "Para luego eliminar los caracteres como , ? ,! ..." ,0dh,0ah
           db "Y despues mostrar en otra variable en espejo..." ,0dh,0ah ,'$'
    enters db 0 ,0dh,0ah,'$'
    texto_ingresado db 256 dup (24h) ,0dh,0ah,'$'

.code
    main proc
        mov ax , @data
        mov ds , ax 

        mov ah, 09h
        lea dx , cartel
        int 21h
    jmp fin_programa    

    fin_programa:
        mov ax, 4c00h
        int 21h    

    main endp
end    