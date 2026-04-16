.8086
.model small
.stack 100h

.data
   cartel db "Ingrese una oracion..." ,0dh,0ah
          db "Para luego mostrarla en efecto espejo..." ,0dh,0ah,'$'

   texto_ingresado db 256 dup('$')   ; buffer del texto
   numeros_espacios db 0             ; contador de espacios

.code
main proc
    mov ax , @data
    mov ds, ax 

    ; mostrar mensaje
    mov ah , 09h
    mov dx , offset cartel
    int 21h

    ; cargar texto
    mov bx, 0                   ; índice
carga_texto:
    mov ah ,01h    
    int 21h                     ; leer caracter en AL
    cmp al , 0dh                ; si es ENTER, salir
    je fin_carga

    mov texto_ingresado[bx], al ; guardar caracter

    cmp al , 20h                ; ¿es espacio?
    jne continuar
    inc numeros_espacios        ; contar espacios
continuar:
    inc bx                      ; siguiente posición
    jmp carga_texto    

fin_carga:
    mov cx, bx                  ; longitud total del texto
    dec bx                      ; último índice válido

    ; salto de línea antes de espejo
    mov ah, 02h
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

imprime_espejo:
    mov dl , texto_ingresado[bx]
    mov ah , 02h
    int 21h
    dec bx      
loop imprime_espejo

    ; salto de línea
    mov ah, 02h
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    ; mostrar cantidad de espacios (solo 0–9)
    mov al , numeros_espacios
    add al , 30h 
    mov dl , al
    mov ah, 02h
    int 21h

    ; fin programa
    mov ax ,4c00h
    int 21h
main endp
end
