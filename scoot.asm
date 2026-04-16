.8086
.model small
.stack 100h

.data
    cartel db "Bienvenido al programa..." ,0dh,0ah
           db "Ingrese un texto..." ,0dh,0ah
           db "Para luego eliminar los caracteres como , ? ,! ..." ,0dh,0ah
           db "Y despues mostrar en otra variable en espejo..." ,0dh,0ah ,'$'
    enters db 0dh,0ah,'$'
    texto_ingresado db 256 dup (24h) ,0dh,0ah,'$'
    texto_modificado db 256 dup (24h) ,0dh,0ah,'$'
    texto_espejo db 256 dup (24h), 0dh,0ah,'$'

.code
main proc
    mov ax , @data
    mov ds , ax 

    ; Mostrar cartel
    mov ah, 09h
    lea dx , cartel 
    int 21h
        
    mov bx , 0
carga_texto:
    mov ah , 01h        ; Leer caracter
    int 21h
    cmp al , 0dh        ; Enter → fin de texto
    je fin_carga

    mov texto_ingresado [bx] , al 
    mov texto_modificado [bx] , al 
    inc bx
    jmp carga_texto 

fin_carga:
    mov texto_ingresado[bx], '$'
    mov texto_modificado[bx], '$'

    ; Guardar longitud en CX
    mov cx, bx
    mov bx, 0     

; --- eliminar , ? ! reemplazando por espacio ---
comparar:
    mov al , texto_modificado[bx] 
    cmp al , '$'
    je invertir_preparar
    cmp al , ','
    je es_Caracter
    cmp al , '?'
    je es_Caracter
    cmp al , '!'
    je es_Caracter
incrementar:
    inc bx 
    jmp comparar

es_Caracter:
    mov texto_modificado [bx] , 20h  
    jmp incrementar

; --- invertir el texto_modificado ---
invertir_preparar:
    mov cx, bx           ; cx = longitud
    dec bx               ; bx = último índice válido
    mov si, 0            ; si → índice para texto_espejo

invertir:
    mov al, texto_modificado[bx]
    mov texto_espejo[si], al
    dec bx
    inc si
    loop invertir

    mov texto_espejo[si], '$'   ; terminar cadena espejo

; --- imprimir resultados ---
fin_programa:
    mov ah ,09h
    lea dx, enters
    int 21h

    mov ah ,09h
    lea dx, texto_ingresado
    int 21h 

    mov ah ,09h
    lea dx, enters
    int 21h

    mov ah ,09h
    lea dx, texto_modificado
    int 21h 

    mov ah ,09h
    lea dx, enters
    int 21h

    mov ah ,09h
    lea dx, texto_espejo
    int 21h 

    mov ax, 4c00h
    int 21h    

main endp
end
