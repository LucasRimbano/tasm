.8086
.model small
.stack 100h
.data
    texto          db 255 dup (24h),0dh,0ah,24h
    textoAlReves db 255 dup (24h),0dh,0ah,24h

.code
main proc
    mov ax, @data
    mov ds, ax

    mov bx, 0
    carga:
        mov ah, 1
        int 21h
        cmp al, 0dh
        je finCarga
        mov texto[bx],al 
        inc bx
    jmp carga                             ;VALOR DE BX
                                        ;          01234567    
                                        ;          HOLASDF$
finCarga:
;    dec bx

    mov bx, 0
calculaLargo:
    cmp texto[bx],24h
    je finLargo
    inc bx 
jmp calculaLargo
finLargo:    
    dec bx
    
    mov si, bx
    mov cx, bx   ;POSICIONES DE MEMORIA QUE ARRANCAN EN 0 
    inc cx       ;NECESITO TENER LA CANTIDAD DE VECES 
    mov bx, 0
copia:
    mov al, texto[bx]
    mov textoAlReves[si],al 
    dec si 
    inc bx 
loop copia

    mov ah, 9
    mov dx, offset textoAlReves
    int 21h

    mov ax, 4c00h
    int 21h

main endp

end