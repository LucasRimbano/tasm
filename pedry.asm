.8086 
.model small 
.stack 100h

.data  ; inicializa el segmento de datos
    texto db 20          ; Longitud máxima de la entrada
    db 0                 ; Número de caracteres leídos (inicialmente 0)
    db 20 dup(0)        ; Espacio para almacenar la cadena ingresada
    mensaje db "hola pedri como estas tu? ", 0dh, 0ah, '$'
    
.code
main proc
    mov ax, @data
    mov ds, ax

    ; Mostrar el mensaje inicial
    mov ah, 09h
    mov dx, offset mensaje
    int 21h

    ; Pedir al usuario que ingrese texto
    mov ah, 0Ah          ; Función para leer cadena
    lea dx, texto        ; Cargar la dirección del buffer de entrada
    int 21h              ; Llamar a la interrupción

    ; Mostrar el texto ingresado
    mov ah, 09h
    lea dx, texto + 2    ; El texto comienza en el tercer byte
    int 21h

    ; Finalizar el programa
    mov ah, 4ch 
    int 21h

main endp
end



