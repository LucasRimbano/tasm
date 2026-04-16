.8086
.model small
.stack 100h

.data
    texto db "Hola como estas cabrinn, espero que bien..." ,0dh,0ah,'$'
    textoMayusc db 255 dup (24h) 
.code
extrn Mayusculizador:proc
main proc

    mov ax , @data
    mov ds , ax

    lea bx, texto
    push bx
    lea bx ,textoMayusc
    push bx 
    call Mayusculizador

    mov ah , 09h
    lea dx, textoMayusc
    int 21h

    mov ax , 4c00h
    int 21h
    

main endp
end