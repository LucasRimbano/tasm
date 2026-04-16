;===========================================================
; MAIN DE PRUEBA - VERIFICAR PALÍNDROMO
;-----------------------------------------------------------
; Usa librerías externas:
;   cargar_texto
;   imprimir_pantalla
;   verificar_palindromo
;===========================================================

.8086
.model small
.stack 100h

.data
msg_inicio   db "Ingrese un texto para verificar si es palindromo:",0dh,0ah,'$'
msg_es       db 0dh,0ah,"El texto ES palindromo.",0dh,0ah,'$'
msg_no       db 0dh,0ah,"El texto NO es palindromo.",0dh,0ah,'$'
msg_original db 0dh,0ah,"Texto ingresado:",0dh,0ah,'$'

extrn texto_a_ingresar:byte

.code
extrn imprimir_pantalla:proc
extrn cargar_texto:proc
extrn verificar_palindromo:proc

main proc
    mov ax, @data
    mov ds, ax

    ;--------------------------------------
    ; Mostrar mensaje e ingresar texto
    ;--------------------------------------
    lea dx, msg_inicio
    call imprimir_pantalla

    call cargar_texto

    ; Mostrar texto original
    lea dx, msg_original
    call imprimir_pantalla
    lea dx, texto_a_ingresar
    call imprimir_pantalla

    ;--------------------------------------
    ; Llamar a la rutina de palíndromo
    ;--------------------------------------
    call verificar_palindromo     ; AL = 1 si es, AL = 0 si no

    cmp al, 1
    je es_pal
    jne no_pal

es_pal:
    lea dx, msg_es
    call imprimir_pantalla
    jmp fin

no_pal:
    lea dx, msg_no
    call imprimir_pantalla

fin:
    mov ax, 4C00h
    int 21h

main endp
end main
