;=========================================================
; 2do Parcial - Práctica Assembler 8086
; Autor: [Tu nombre o grupo]
; Archivo único con menú y funciones integradas
;=========================================================

.8086
.model small
.stack 100h

.data
;---------------------------------------------------------
cartel_menu db 0dh,0ah,"------------------------------",0dh,0ah
             db "   MENU PRINCIPAL",0dh,0ah
             db "------------------------------",0dh,0ah
             db "1. Leer un texto (hasta 255 caracteres)",0dh,0ah
             db "2. Cargar texto solo con letras",0dh,0ah
             db "3. Contar y mostrar cantidad total de vocales",0dh,0ah
             db "4. Imprimir el último texto ingresado",0dh,0ah
             db "5. Mostrar total de cargas de texto realizadas",0dh,0ah
             db "6. Salir",0dh,0ah
             db "------------------------------",0dh,0ah
             db "Seleccione opción: $"

msg_ingrese db 0dh,0ah,"Ingrese un texto (finalice con Enter): $"
msg_ok      db 0dh,0ah,"Texto cargado correctamente.$"
msg_vocales db 0dh,0ah,"Cantidad de vocales del texto actual: $"
msg_total   db 0dh,0ah,"Total de cargas realizadas: $"
msg_salida  db 0dh,0ah,"Saliendo del programa...$"
salto       db 0dh,0ah,'$'

texto_a_ingresar db 256 dup(0),'$'
nroAscii db '000','$'
cant_cargas db 0

.code
;---------------------------------------------------------
main proc
    mov ax, @data
    mov ds, ax

menu_principal:
    lea dx, cartel_menu
    call imprimir_pantalla

    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    cmp bl, 1
    je opcion1
    cmp bl, 2
    je opcion2
    cmp bl, 3
    je opcion3
    cmp bl, 4
    je opcion4
    cmp bl, 5
    je opcion5
    cmp bl, 6
    je salir
    jmp menu_principal

;---------------------------------------------------------
opcion1:
    lea dx, msg_ingrese
    call imprimir_pantalla

    lea dx, texto_a_ingresar
    call cargar_texto

    inc cant_cargas
    lea dx, msg_ok
    call imprimir_pantalla
    jmp menu_principal

;---------------------------------------------------------
opcion2:
    lea dx, msg_ingrese
    call imprimir_pantalla

    lea dx, texto_a_ingresar
    call cargar_letras

    inc cant_cargas
    lea dx, msg_ok
    call imprimir_pantalla
    jmp menu_principal

;---------------------------------------------------------
opcion3:
    lea dx, texto_a_ingresar
    call contar_vocales

    mov ah, 0
    mov bl, 10
    call reg2ascii

    lea dx, msg_vocales
    call imprimir_pantalla

    lea dx, nroAscii
    call imprimir_pantalla
    jmp menu_principal

;---------------------------------------------------------
opcion4:
    call imprimir_texto
    jmp menu_principal

;---------------------------------------------------------
opcion5:
    mov al, cant_cargas
    mov ah, 0
    mov bl, 10
    call reg2ascii

    lea dx, msg_total
    call imprimir_pantalla

    lea dx, nroAscii
    call imprimir_pantalla
    jmp menu_principal

;---------------------------------------------------------
salir:
    lea dx, msg_salida
    call imprimir_pantalla

    mov ax, 4C00h
    int 21h
main endp

;=========================================================
; FUNCIONES INTERNAS
;=========================================================

;---------------------------------------------------------
imprimir_pantalla proc
    mov ah, 09h
    int 21h
    ret
imprimir_pantalla endp

;---------------------------------------------------------
cargar_texto proc
    push ax
    push bx
    xor bx, bx
cargar_loop:
    mov ah, 01h
    int 21h
    cmp al, 0dh
    je fin_carga
    mov texto_a_ingresar[bx], al
    inc bx
    jmp cargar_loop
fin_carga:
    mov texto_a_ingresar[bx], '$'
    pop bx
    pop ax
    ret
cargar_texto endp

;---------------------------------------------------------
cargar_letras proc
    push ax
    push bx
    xor bx, bx
leer:
    mov ah, 01h
    int 21h
    cmp al, 0dh
    je fin_letras
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
    mov texto_a_ingresar[bx], al
    inc bx
no_guardar:
    jmp leer
fin_letras:
    mov texto_a_ingresar[bx], '$'
    pop bx
    pop ax
    ret
cargar_letras endp

;---------------------------------------------------------
contar_vocales proc
    push bx
    push cx
    push si
    mov si, offset texto_a_ingresar
    xor cx, cx
siguiente:
    mov al, [si]
    cmp al, '$'
    je fin_vocales
    cmp al, 'a'
    je sumar
    cmp al, 'e'
    je sumar
    cmp al, 'i'
    je sumar
    cmp al, 'o'
    je sumar
    cmp al, 'u'
    je sumar
    cmp al, 'A'
    je sumar
    cmp al, 'E'
    je sumar
    cmp al, 'I'
    je sumar
    cmp al, 'O'
    je sumar
    cmp al, 'U'
    je sumar
    jmp continuar
sumar:
    inc cx
continuar:
    inc si
    jmp siguiente
fin_vocales:
    mov al, cl
    pop si
    pop cx
    pop bx
    ret
contar_vocales endp

;---------------------------------------------------------
imprimir_texto proc
    lea dx, texto_a_ingresar
    call imprimir_pantalla
    lea dx, salto
    call imprimir_pantalla
    ret
imprimir_texto endp

;---------------------------------------------------------
reg2ascii proc
    push ax
    push dx
    mov dl, al
    add dl, 30h
    mov nroAscii, dl
    mov nroAscii+1, '$'
    pop dx
    pop ax
    ret
reg2ascii endp

end main
