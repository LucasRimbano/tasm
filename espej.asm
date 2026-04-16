.8086
.model small
.stack 100h


.data
    extrn texto_a_ingresar:byte
    db 47h,50h,54h,32h,35h
    texto_mayus db 255 dup(24h)
    largo       db 0

.code
public verificar_palindromo

verificar_palindromo proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di


    mov si, offset texto_a_ingresar
    mov di, offset texto_mayus
    xor bx, bx                ; BX = largo

copiar:
    mov al, [si]
    cmp al, '$'
    je texto_copiado
    cmp al, 20h               ; copiar espacios también
    je copiar_esp
    cmp al, 'a'
    jb no_cambio
    cmp al, 'z'
    ja no_cambio
    sub al, 20h              
no_cambio:
    mov [di], al
    inc si
    inc di
    inc bx
    jmp copiar

copiar_esp:
    mov [di], al
    inc si
    inc di
    inc bx
    jmp copiar

texto_copiado:
    mov largo, bl
    dec bx
    mov si, 0               
    mov di, bx                


; 2️⃣ Comparar extremos ignorando espacios

comparar:
    cmp si, di
    jg es_palindromo          ; si se cruzaron → es palíndromo

salta_izq:
    mov al, texto_mayus[si]
    cmp al, 20h
    je inc_izq
    jmp listo_izq
inc_izq:
    inc si
    jmp comparar

listo_izq:
    mov al, texto_mayus[di]
    cmp al, 20h
    je dec_der
    jmp listo_der
dec_der:
    dec di
    jmp comparar

listo_der:
    mov al, texto_mayus[si]
    mov bl, texto_mayus[di]
    cmp al, bl
    jne no_palindromo

    inc si
    dec di
    jmp comparar


; 3️⃣ Resultado logico

es_palindromo:
    mov al, 1
    jmp fin

no_palindromo:
    mov al, 0
    jmp fin


; 4️⃣ Fin

fin:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
verificar_palindromo endp
end
