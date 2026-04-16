.8086
.model small
.stack 100h

.data
     Menu db "Bienvenido al programa falopa..." ,0dh,0ah
          db "Cartel 1 si queres a nahuel" ,0dh,0ah
          db "Cartel 2 si queres a pedry" ,0dh ,0ah
          db "Cartel 3 si queres a lukitruki " ,0dh,0ah,'$'
    texto_ingresado db 256 dup (24h) ,0dh,0ah, '$'      
    cartel_1 db "NAHUEL..." ,0dh,0ah,'$'
    cartel_2 db "PEDRY...." ,0dh,0ah,'$'
    cartel_3 db "lukitruki..." ,0dh,0ah,'$'


.code
main proc

    mov ax, @data
    mov ds ,  ax
   
    mov ah, 09h
    mov dx , offset menu 
    int 21h
    

 
carga:
    mov ah , 01h 
    int 21h
    cmp al , "1"
    je cartel_nahue
    cmp al ,"2"
    je cartel_pedry
    cmp al ,"3"
    je cartel_luki   
jmp carga    

cartel_nahue:
    mov ah ,09h
    mov dx , offset cartel_1
    int 21h
jmp fin    

cartel_pedry:
    mov ah ,09h
    mov dx,  offset cartel_2
    int 21h
jmp fin

cartel_luki:
    mov ah ,09h
    mov dx , offset cartel_3
    int 21h
jmp fin    


fin:    
    mov ax , 4c00h
    int 21h
main endp
end    


