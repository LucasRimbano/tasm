.8086
.model small
.stack 100h

.data
    msg db "Ingrese un numero (0-9999): $"
    msgOut db 0dh,0ah,"El numero ingresado es: $"

    var dw ?                   ; número binario (0–9999)
    nroAscii db '0000',0dh,0ah,'$'
    dataDiv db 1000,100,10,1   ; divisores para cada dígito

.code
main proc
    mov ax, @data
    mov ds, ax

    ; pedir un dígito (ejemplo simplificado, solo funciona bien 0-9 por ahora)
    mov ah, 09h
    mov dx, offset msg
    int 21h

    mov ah, 01h       ; leer 1 carácter
    int 21h
    sub al, '0'       ; convertir a binario
    mov ah, 0
    mov var, ax       ; guardar número en var

    ; mensaje salida
    mov ah, 09h
    mov dx, offset msgOut
    int 21h

    ; convertir con dataDiv
    mov ax, var       ; número
    mov cx, 4         ; 4 divisores
    mov bx, 0         ; índice
    mov si, offset nroAscii

nextDigit:
    mov dl, dataDiv[bx] ; divisor actual
    div dl              ; AX / DL
    add al, '0'         ; convertir a ASCII
    mov [si+bx], al     ; guardar dígito
    mov al, ah          ; resto en AL
    mov ah, 0
    inc bx
    loop nextDigit

    ; mostrar resultado
    mov ah, 09h
    mov dx, offset nroAscii
    int 21h

    ; salir
    mov ax, 4c00h
    int 21h
main endp
end
