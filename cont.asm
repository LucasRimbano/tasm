.8086
.model small
.stack 100h
.data
extrn texto_a_ingresar:byte


.code
public contador_palabras

contador_palabras proc
    push ax
    push si
    push bx

    mov si, offset texto_a_ingresar
    xor cx, cx         
    mov bl, 0           
siguiente:
    mov al, [si]
    cmp al, '$'
    je fin

    ; solo letras A–Z o a–z
    cmp al, 'A'
    jb no_letra
    cmp al, 'Z'
    jbe letra
    cmp al, 'a'
    jb no_letra
    cmp al, 'z'
    jbe letra
    jmp no_letra

letra:
    cmp bl, 1
    je continuar
    inc cx              ; nueva palabra
    mov bl, 1
    jmp continuar

no_letra:
    mov bl, 0           ; cualquier símbolo/número/puntuación = separador

continuar:
    inc si
    jmp siguiente

fin:
    pop bx
    pop si
    pop ax
    ret
contador_palabras endp
end
