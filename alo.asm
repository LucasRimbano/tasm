.8086
.model small
.stack 100h

.data
    texto db "Ingrese un texto",0dh,0ah,'$'
    texto_ingresado db 256 (24h),0dh,0ah,'$'
.code
    main proc
        mov ax ,@data
        mov ds ,ax

        mov ah,09h
        mov dx, offset texto
        int 21h
        
        mov bx,0
    carga:   
        mov ah, 01h
        cmp al , 0dh
        je fin
        int 21h
        mov texto_ingresado[bx],al
        inc bx
    jmp carga

 
    fin:
    mov texto_ingresado[bx],'$'

    mov ax,09h
    mov dx,offset texto_ingresado
    int 21h

    


    int 4ch
    int 21h

    main endp       
end    