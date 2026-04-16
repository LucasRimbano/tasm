.8086
.model small
.stack 100h


.data
    menu db "Bienvenido al programa...." ,0dh,0ah
         db "ELIJA UNA  OPCION SEGUN LO QUE QUIERA..." ,0dh,0ah
         db "1 si queres bariloche" , 0dh,0ah
         db "2 si queres llegar a ushuaia" , 0dh,0ah
         db "3 si queres ir a mongolia" , 0dh,0ah. '$'
    opcion_ingresada db 256 dup ('$'), 0dh,0ah,'$'
    opcion_1 db "Elegiste bariloche.... felicidades " , 0dh,0ah,'$'
    opcion_2 db "Elegiste ushuaia sos crack " ,0dh,0ah,'$'
    opcion_3 db 'Elegiste mongolia paaa tomaa' ,0dh,0ah ,'$'

         

.code


    main proc
         mov ax , @data
         mov ds , ax 
         
         
         mov ah , 09h
         mov dx , offset menu
         int 21h
         
      

    carga:
        mov ah, 01h
        int 21h       
        cmp al , "1" 
        je opcion1
        cmp al ,"2"
        je opcion2
        cmp al , "3"
        je opcion3
    jmp carga    
     

    opcion1:    
        mov ah , 09h
        mov dx, offset opcion_1
        int 21h
    jmp fin_programa
    
    opcion2:
        mov ah ,09h
        mov dx , offset opcion_2
        int 21h
    jmp fin_programa
    
    opcion3:
        mov ah, 09h
        mov dx , offset opcion_3
        int 21h
    jmp fin_programa

        

    fin_programa:
        mov ax, 4c00h
        int 21h

    main endp
end
