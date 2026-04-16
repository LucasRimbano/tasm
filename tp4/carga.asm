; LIBABC - Lee solo caracteres A, B o C (con limpieza de ENTER)
.8086
.model small
.stack 100h

.data
msg_error db 0dh,0ah,"Solo se permiten las letras A, B o C. Intente de nuevo:",0dh,0ah,'$'

.code
public leer_caracter_abc
extrn imprimir_pantalla:proc
extrn sonido_error:proc

leer_caracter_abc proc
    push ax
    push dx

pedir:
        
    mov ah, 01h
    int 21h
    cmp al, 0dh          
    je pedir             

    
    ; Pasar a mayuscula si es minuscula
    
    cmp al, 'a'
    jb verificar
    cmp al, 'z'
    ja verificar    
    sub al, 20h           

verificar:
    cmp al, 'A'
    je valido
    cmp al, 'B'
    je valido
    cmp al, 'C'
    je valido

    
    ; Error → sonido + mensaje
    
    call sonido_error
    lea dx, msg_error
    call imprimir_pantalla
    jmp pedir

valido:
    pop dx  
    pop ax
    ret
leer_caracter_abc endp

end
