.8086
.model small
.stack 100h

.data
    cartel db "Bienvenido al programa...", 0dh, 0ah
           db "Ingrese una oracion...", 0dh, 0ah
           db "Para luego cambiar las letras dsp del espacio...", 0dh, 0ah, '$'
    texto_ingresado db 256 dup(0)
    texto_modificado db 256 dup(0)

.code
main proc
    mov ax, @data
    mov ds, ax 
    
    ; Mostrar mensaje de bienvenida
    mov ah, 09h
    lea dx, cartel
    int 21h

    ; Cargar texto
    mov bx, 0
carga_texto:
    mov ah, 01h
    int 21h
    cmp al, 0dh ; Verificar si se presionó Enter
    je fin_carga
    mov texto_ingresado[bx], al 
    mov texto_modificado[bx], al 
    inc bx 
    jmp carga_texto    

fin_carga:
    mov texto_ingresado[bx], '$' ; Terminar cadena de texto ingresado
    mov texto_modificado[bx], '$' ; Terminar cadena de texto modificado

    ; Procesar texto
    mov bx, 0 
proceso:
    mov al, texto_modificado[bx]
    cmp al, '$' ; Verificar fin de cadena
    je fin_programa
    cmp al, 20h ; Verificar espacio
    je sera_palabra
    jmp incrementa

sera_palabra:
    inc bx
    cmp texto_modificado[bx], 'a' ; Comprobar si es letra minúscula
    jb incrementa ; Si es menor que 'a', saltar
    cmp texto_modificado[bx], 'z'
    ja incrementa ; Si es mayor que 'z', saltar
    sub texto_modificado[bx], 20h ; Cambiar a mayúscula

incrementa:
    inc bx
    jmp proceso

fin_programa:
    ; Mostrar texto ingresado
    mov ah, 09h
    lea dx, texto_ingresado
    int 21h

    ; Mostrar texto modificado
    mov ah, 09h
    lea dx, texto_modificado
    int 21h

    mov ax, 4c00h
    int 21h    
main endp
end
