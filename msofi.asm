;===========================================================
; MSOFI.ASM - Texto, contador de vocales y asteriscos
;   (usa sofi1.asm como librería)
;===========================================================

.8086
.model small
.stack 100h

.data
    extrn texto_a_ingresar:byte
    extrn contar_vocales:far
    extrn modificar_a_asteriscos:far
    extrn limpiar_texto:far

    cartelCarga  db "Ingrese un texto:",0Dh,0Ah,'$'
    cartelMenu   db "1- Contar vocales",0Dh,0Ah
                 db "2- Texto modificado",0Dh,0Ah
                 db "3- Volver a cargar el texto",0Dh,0Ah
                 db "Seleccione: ",'$'

    cartelVocales db 0Dh,0Ah,"Cantidad de vocales: ",'$'
    cartelMod     db 0Dh,0Ah,"Texto modificado: ",'$'
    nroAscii      db '00','$'

.code
main proc
    mov ax, @data
    mov ds, ax

;------------------------------------------------
; CARGAR TEXTO
;------------------------------------------------
INICIO_CARGA:
    mov ah, 09h
    mov dx, offset cartelCarga
    int 21h

    mov bx, offset texto_a_ingresar

leer:
    mov ah, 01h
    int 21h          ; AL = caracter
    cmp al, 0Dh      ; Enter?
    je fin_lectura
    mov [bx], al
    inc bx
    jmp leer

fin_lectura:
    mov byte ptr [bx], '$'   ; terminamos la cadena

;------------------------------------------------
; MENU
;------------------------------------------------
MENU:
    mov ah, 09h
    mov dx, offset cartelMenu
    int 21h

    mov ah, 01h
    int 21h          ; AL = opción

    cmp al, '1'
    je opcion1
    cmp al, '2'
    je opcion2
    cmp al, '3'
    je opcion3
    jmp MENU

;------------------------------------------------
; OPCIÓN 1: CONTAR VOCALES
;------------------------------------------------
opcion1:
    call contar_vocales      ; FAR (por declaración)

    ; convertir AL (0..99) a ASCII en nroAscii
    mov bl, 10
    xor dx, dx
    div bl                   ; AL / 10 → AL=unid, AH=decenas

    add ah, 30h
    add al, 30h

    mov nroAscii,   ah
    mov nroAscii+1, al
    mov nroAscii+2, '$'

    mov ah, 09h
    mov dx, offset cartelVocales
    int 21h

    mov ah, 09h
    mov dx, offset nroAscii
    int 21h

    jmp MENU

;------------------------------------------------
; OPCIÓN 2: TEXTO → ASTERISCOS
;------------------------------------------------
opcion2:
    call modificar_a_asteriscos   ; FAR

    mov ah, 09h
    mov dx, offset cartelMod
    int 21h

    mov ah, 09h
    mov dx, offset texto_a_ingresar
    int 21h

    jmp MENU

;------------------------------------------------
; OPCIÓN 3: LIMPIAR Y VOLVER A CARGAR
;------------------------------------------------
opcion3:
    call limpiar_texto            ; FAR
    jmp INICIO_CARGA

main endp

end
