;convierto un numero puesto en un byte convertirlo a 3 digitios
.8086
.model small
.stack 100h

.data
    var db 223
    nroAscii db '000' ,0dh,0ah,'$' ;aca hay guardado 30h , 30h,30h
    dataDiv db 100 ,10,1


.code

   main proc
      
      mov ax ,@data
      mov ds ,ax 

    
      mov dl , 100 
      mov ah , 0
      mov al , var

      div dl 
      add nroAscii[0], al
      mov al , ah ; muevo al resto
      mov ah ,0  ;limpio para que no me quede con el resto
      mov dl , 10 
      div dl
      add nroAscii[1] , al ; sumo +20 para q me muestre lo que quiero
      add nroAscii[2] , al 

      mov ah , 09h
      mov dx , offset nroAscii
      int 21h
   

 
      mov ax , 4c00h
      int 21h


    main endp
end
