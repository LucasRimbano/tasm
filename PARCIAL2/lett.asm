.8086
.model small
.stack 100h

.data
    public texto_a_ingresar
    texto_a_ingresar db 256 dup(0),'$'     ; única definición real

.code

public cargar_letras


; cargar_letras
; Entrada : DS apunta al segmento de datos
; Acción  : Permite ingresar texto con solo letras (A–Z, a–z)
;           y espacios (20h). Finaliza con ENTER (0Dh).

cargar_letras proc
    push ax
    push bx

    xor bx, bx
    lea si, texto_a_ingresar       ; usar SI como puntero base

leer:
    mov ah, 01h
    int 21h                        
    cmp al, 0Dh                    
    je fin_letras
    cmp bx, 255                    ; límite de 255 caracteres
    je fin_letras

    ;solo letras y espacio
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
    mov [si+bx], al              ; indexacion correcto 
    inc bx
no_guardar:
    jmp leer

fin_letras:
    mov [si+bx], '$'              
    pop bx
    pop ax
    ret
cargar_letras endp

end
