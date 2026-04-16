.8086
.model small
.stack 100h

extrn texto_a_ingresar:byte

.code
public contar_consonantes

contar_consonantes proc
    push ax
    push si

    xor cx, cx                      ; contador = 0
    mov si, offset texto_a_ingresar ; puntero al texto

siguiente:
    mov al, [si]
    cmp al, '$'                     ; fin del texto
    je fin


    ; Verificar si es letra (A–Z o a–z)
   
    cmp al, 'A'
    jb no_letra
    cmp al, 'Z'
    jbe es_letra

    cmp al, 'a'
    jb no_letra
    cmp al, 'z'
    ja no_letra
es_letra:
   
    ; Pasar a mayus si es minusc
    
    cmp al, 'a'
    jb verificar
    cmp al, 'z'
    ja verificar
    sub al, 20h

verificar:
  
    ; Si es vocal, no contar
  
    cmp al, 'A'
    je no_letra
    cmp al, 'E'
    je no_letra
    cmp al, 'I'
    je no_letra
    cmp al, 'O'
    je no_letra
    cmp al, 'U'
    je no_letra

    
    ; Si llego hasta aca, es consonante
    
    inc cx

no_letra:
    inc si
    jmp siguiente

fin:
    pop si
    pop ax
    ret
contar_consonantes endp

end
