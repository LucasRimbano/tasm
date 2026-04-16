.8086
.model small
.stack 100h

.data
    public texto_a_ingresar
    texto_a_ingresar db 256 dup (0), '$'  ; buffer de texto

.code
    public cargar_letras



cargar_letras proc
    push ax
    push bx

    xor bx, bx                 

ciclo_letras:
    mov ah, 01h                 
    int 21h
    cmp al, 0Dh                 
    je fin_letras


    cmp al, 'A'
    jb no_guardar
    cmp al, 'Z'
    jbe guardar


    cmp al, 'a'
    jb no_guardar
    cmp al, 'z'
    jbe guardar

    
    cmp al, 20h
    je guardar

   
    jmp no_guardar

guardar:
    mov texto_a_ingresar[bx], al
    inc bx
    jmp ciclo_letras

no_guardar:
    mov ah, 02h
    mov dl, 07h      
    int 21h
    jmp ciclo_letras

fin_letras:
    mov texto_a_ingresar[bx], '$'   

    pop bx
    pop ax
    ret
cargar_letras endp

end
