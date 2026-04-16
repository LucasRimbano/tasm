.8086
.model small

.data
divisores db 100,10,1


.code
public reg2ascii

reg2ascii proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

 
    mov ah, 0          

    mov cx, 3            ; 3 divisores (100,10,1)
    mov si, offset divisores
    mov di, bx           ; buffer destino

prox_numero:
    mov dl, [si]      
    xor ah, ah           
    div dl             
    add al, '0'          ; convertir cociente a ASCII
    mov [di], al         ; guardar carácter en buffer
    inc di
    mov al, ah           
    mov ah, 0
    inc si
    loop prox_numero

    mov byte ptr [di], '$' 
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
reg2ascii endp
end
