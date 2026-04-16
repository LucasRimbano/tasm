.8086
.model small
.stack 100h

.data
cartel_ingreso db "Ingrese un texto:",0Dh,0Ah,'$'
cartel_original db 0Dh,0Ah,"Texto original:",0Dh,0Ah,'$'
cartel_mayus db 0Dh,0Ah,"Texto en mayúsculas:",0Dh,0Ah,'$'
cartel_vocales db 0Dh,0Ah,"Cantidad de vocales detectadas: ",'$'
nro_ascii db '000','$'     ; buffer para convertir número a texto

extrn texto_a_ingresar:byte
extrn texto_mayusculizado:byte

.code
extrn imprimir_pantallaa:proc
extrn cargar_texto:proc
extrn mayusculizar_texto:proc
extrn contar_vocaless:proc
extrn reg2ascii:proc

main proc
    mov ax, @data
    mov ds, ax

    ;-----------------------------------------
    ; 1️⃣ Pedir texto al usuario
    ;-----------------------------------------
    lea dx, cartel_ingreso
    call imprimir_pantallaa

    call cargar_texto                ; carga texto en texto_a_ingresar

    ;-----------------------------------------
    ; 2️⃣ Convertir a mayúsculas
    ;-----------------------------------------
    call mayusculizar_texto          ; genera texto_mayusculizado

    ;-----------------------------------------
    ; 3️⃣ Contar vocales (sobre el texto MAYÚSCULO)
    ;-----------------------------------------
    push ds                          ; guardar DS actual
    mov ax, @data
    mov ds, ax
    mov si, offset texto_mayusculizado  ; apuntar al texto ya convertido
    call contar_vocaless             ; CX ← cantidad de vocales
    pop ds                           ; restaurar DS

    mov ax, cx                       ; pasar resultado a AX
    mov bx, offset nro_ascii         ; buffer destino
    call reg2ascii                   ; convertir número a ASCII

    ;-----------------------------------------
    ; 4️⃣ Mostrar resultados
    ;-----------------------------------------
    lea dx, cartel_original
    call imprimir_pantallaa
    lea dx, texto_a_ingresar
    call imprimir_pantallaa

    lea dx, cartel_mayus
    call imprimir_pantallaa
    lea dx, texto_mayusculizado
    call imprimir_pantallaa

    lea dx, cartel_vocales
    call imprimir_pantallaa
    lea dx, nro_ascii
    call imprimir_pantallaa

    ;-----------------------------------------
    ; 5️⃣ Salir al DOS
    ;-----------------------------------------
    mov ax, 4C00h
    int 21h
main endp

end main
