.8086
.model small
.stack 100h

.data
    cartel db "Bienvenido al programa..." ,0dh,0ah
           db "Ingrese un texto..." ,0dh,0ah
           db "Para luego contar caracteres..." ,0dh,0ah
           db "Luego invertir las palabras..." ,0dh,0ah,'$'
    cont_letras db 0dh,0ah,"Cantidad de letras....",'$'      
    msg_palabras db 0dh,0ah,"Cantidad de palabras....",'$'
    msg_es db 0dh,0ah,"El texto es palindromo.",0dh,0ah,'$'
    msg_no db 0dh,0ah,"El texto no es palindromo.",0dh,0ah,'$'
    msg_invertido db 0dh,0ah,"Texto invertido:",0dh,0ah,'$'
    msg_vocales db 0dh,0ah,"Cantidad de vocales....",'$'
    nroAscii db '000','$'

.code
extrn texto_a_ingresar:byte
extrn imprimir_pantalla:proc 
extrn cargar_texto:proc
extrn contador_letras:proc
extrn reg2ascii:proc
extrn contador_palabras:proc
extrn verificar_palindromo:proc
extrn invertir_texto:proc
extrn contar_vocales:proc







main proc

    mov ax ,@data
    mov ds , ax 
  
    lea dx , cartel
    call imprimir_pantalla

    
    call cargar_texto
    
    lea dx , texto_a_ingresar
    call imprimir_pantalla


    call contador_letras

    mov ax, cx              ; valor total de letras
    mov bx, offset nroAscii ; buffer para convertir
    call reg2ascii

    lea dx, cont_letras
    call imprimir_pantalla

    lea dx, nroAscii
    call imprimir_pantalla


    lea si, texto_a_ingresar
    call contador_palabras         ; CX ← cantidad de palabras

    mov ax, cx                     ; pasar resultado a AX
    mov bx, offset nroAscii        ; buffer para convertir
    call reg2ascii

    ; mostrar mensaje
    lea dx, msg_palabras
    call imprimir_pantalla

    lea dx, nroAscii
    call imprimir_pantalla
    
    call verificar_palindromo
    cmp al, 1
    je es_pal
    jne no_es

    es_pal:
    lea dx, msg_es
    call imprimir_pantalla
    jmp continuar

    no_es:
    lea dx, msg_no
    call imprimir_pantalla

    continuar:

   
    call contar_vocales          ; CX ← cantidad de vocales

    mov ax, cx                   ; pasar resultado a AX
    mov bx, offset nroAscii      ; buffer para convertir a ASCII
    call reg2ascii

    lea dx, msg_vocales
    call imprimir_pantalla

    lea dx, nroAscii
    call imprimir_pantalla

    lea dx, msg_invertido
    call imprimir_pantalla
    call invertir_texto

    
    mov ax , 4C00h
    int 21h


main endp
end