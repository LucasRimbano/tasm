.8086 
.model small
.stack 100h

.data
    mensaje db "Bienvenido a mi primer print", 0dh, 0ah, '$'  ; Cambié 24h por '$' para el terminador de cadena

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 09h              ; Función 09h para imprimir una cadena
    mov dx, offset mensaje 
    int 21h

    mov ah, 4ch              ; Función para salir del programa
    int 21h

main endp
end
