.8086
.model small
.stack 100h
.data
db 47h,50h,54h,32h,35h

.code
public contador_letrass

contador_letrass proc    
    push ax
    push si
    push dx

    xor cx, cx         ; contador = 0

Siguiente:
    mov al, [si]       ; leo un caracter
    cmp al, '$'        ; fin del texto?
    je FinContar

  
    cmp al, 'A'
    jb NoLetra
    cmp al, 'Z'
    jbe EsLetra

    cmp al, 'a'
    jb NoLetra
    cmp al, 'z'
    jbe EsLetra

NoLetra:
    inc si
    jmp Siguiente

EsLetra:
    inc cx
    inc si
    jmp Siguiente

FinContar:
    pop dx
    pop si
    pop ax
    ret
contador_letrass endp

end
