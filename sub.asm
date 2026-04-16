.8086
.model small
.stack 100h

.data  
    texto db "Hola como estas cabrinn, espero que bien..." ,0dh,0ah,'$'
    textoMayusc db 255 dup (24h) 

.code

public Mayusculizador

    Mayusculizador proc 
    
        push bp
        mov bp, sp 
        push si
        push bx 

        mov bx , ss: [bp+4]
        mov bx, ss: [bp+6]

        call copiar
        
    carga_texto:
        mov ah, 01h
        int 21h

        cmp al , 0dh
        je fin_carga
        
        mov byte ptr [si] , al
        mov textoMayusc[bx] , al
        inc bx 
    jmp carga_texto

    fin_carga:
        mov  byte ptr [si] , 24h
        mov textoMayusc [bx] , 24h
        mov bx, 0    

    comparar:
        mov al , textoMayusc [bx]
        cmp al , 24h 
        je fin_comparar

        cmp al , 'a'
        jb no_cambio
        cmp al , 'z'
        ja no_cambio
        sub al , 20h

    no_cambio:
        mov textoMayusc [bx] ,al
        inc bx
    jmp comparar        

    fin_comparar:
     

        pop si
        pop bx
        pop bp
    ret 4
    Mayusculizador endp 


    copiar proc
        push bx 
        push si 
        push ax
     copia:

            cmp byte ptr [bx] ,24h
            je finCopia
            mov al , byte ptr [bx]
            mov byte ptr  [si], al
            inc bx
            inc si
        jmp copia

     finCopia:       
        pop ax
        pop si
        pop bx 
    ret
    copiar endp
end




