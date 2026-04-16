.8086
.model small
.stack 100h

.data
cartel_bienvenida db "Selecciona una unidad para comenzar:",0dh,0ah,'$'
opcion_1 db "1. UNIDAD ARITMETICO-LOGICA (ALU)",0dh,0ah,'$'
opcion_2 db "2. MEMORIA PRINCIPAL",0dh,0ah,'$'
opcion_3 db "3. INTERRUPCIONES",0dh,0ah,'$'
opcion_4 db "4. UNIDAD DE CONTROL",0dh,0ah,'$'
opcion_5 db "5. ENTRADAS / SALIDAS",0dh,0ah,'$'

cartel db 0dh,0ah,"Mucha suerte...",0dh,0ah,'$'
msg_error db 0dh,0ah,"Opcion invalida. Solo del 1 al 5.",0dh,0ah,'$'
msg_repetido db 0dh,0ah,"Esa unidad ya fue completada. Elegi otra.",0dh,0ah,'$'
msg_final db 0dh,0ah,"Simulacro terminado. Respondiste todas las unidades de SPD!",0dh,0ah,'$'
msg_total db 0dh,0ah,"Tu puntaje final es: ",'$'
msg_aprobado db 0dh,0ah,"Aprobado! Excelente repaso de SPD!",0dh,0ah
             db 0dh,0ah,"Aprete cualquier tecla para salir." ,0dh,0ah,'$'
msg_desaprobado db 0dh,0ah,"Desaprobado. Segui estudiando,la proxima rendis mejor.",0dh,0ah
             db 0dh,0ah,"Aprete cualquier tecla para salir." ,0dh,0ah,'$'
msg_salir    db 0dh,0ah,"Simulacro terminado gracias por responder!",0dh,0ah
             db 0dh,0ah, "Programa finalizado." ,0dh,0ah,'$'    
ultimo_error_menu db 0          ; 0 = sin error, 1 = mostrar mensaje de error

puntaje_total db 0
public puntaje_total
nro_ascii db '000','$'
unidades_jugadas db 0,0,0,0,0
public unidades_jugadas
completadas db 0
seg_dgroup dw ?
public seg_dgroup




.code
extrn imprimir_pantalla:proc
extrn leer_opcion_menu:proc
extrn sonido_presentacion:proc
extrn sonido_error:proc
extrn cambiar_color_amarillo:proc
extrn cambiar_color_gris:proc
extrn reg2ascii:proc
extrn jugar_alu:proc
extrn jugar_mem:proc
extrn jugar_int:proc
extrn jugar_uc:proc
extrn jugar_io:proc
extrn actualizar_puntaje:proc
extrn cls_azul_10h:proc
extrn cls_attr_10h:proc
extrn limpiar_buffer_teclado:proc
extrn mostrarImagen:proc
extrn imagenGana:proc
extrn imagenPierde:proc



; PROGRAMA PRINCIPAL

main proc
    mov ax, @data
    mov ds, ax
    mov [seg_dgroup], ax

  
    int 60h                 ; muestra la pantalla nuestra interrupcion nueva

  
    call cls_azul_10h
    call cambiar_color_amarillo
    call actualizar_puntaje


    lea dx, cartel_bienvenida
    call imprimir_pantalla
    call sonido_presentacion

;           LOOP PRINCIPAL
menu_principal:
    mov al, [completadas]
    cmp al, 5
    je  __to_fin_juego
    jmp short continuar_menu
__to_fin_juego:
    jmp fin_juego

continuar_menu:
    call mostrar_menu_dinamico
    call limpiar_buffer_teclado
    call leer_opcion_menu            ; AL = '1'..'5'

    cmp al, '1'
    jb  __to_op_inv
    cmp al, '5'
    jbe __ok_range

__to_op_inv:
    jmp opcion_invalida
__ok_range:
    sub al, '1'
    mov bl, al
    xor bh, bh
    shl bx, 1
    jmp  word ptr cs:[op_table+bx]

op_table:
    dw offset unidad_1
    dw offset unidad_2
    dw offset unidad_3
    dw offset unidad_4
    dw offset unidad_5

;      OPCION INVALIDA 
opcion_invalida:
    mov byte ptr [ultimo_error_menu], 1   ; marcar que hubo error
    call sonido_error                     ; sonido de error
    jmp menu_principal                    ; volvemos al bucle

;               UNIDADES 
unidad_1:
    mov bx, offset unidades_jugadas
    cmp byte ptr [bx], 1
    jne u1_ok
    jmp repetida
u1_ok:
    mov byte ptr [bx], 1
    inc byte ptr [completadas]
    call cls_azul_10h
    call cambiar_color_amarillo
    call actualizar_puntaje
    call jugar_alu
    call actualizar_puntaje
    jmp volver_menu

unidad_2:
    mov bx, offset unidades_jugadas + 1
    cmp byte ptr [bx], 1
    jne u2_ok
    jmp repetida
u2_ok:
    mov byte ptr [bx], 1
    inc byte ptr [completadas]
    call jugar_mem
    call actualizar_puntaje
    jmp volver_menu

unidad_3:
    mov bx, offset unidades_jugadas + 2
    cmp byte ptr [bx], 1
    jne u3_ok
    jmp repetida
u3_ok:
    mov byte ptr [bx], 1
    inc byte ptr [completadas]
    call jugar_int
    call actualizar_puntaje
    jmp volver_menu

unidad_4:
    mov bx, offset unidades_jugadas + 3
    cmp byte ptr [bx], 1
    jne u4_ok
    jmp repetida
u4_ok:
    mov byte ptr [bx], 1
    inc byte ptr [completadas]
    call jugar_uc
    call actualizar_puntaje
    jmp volver_menu

unidad_5:
    mov bx, offset unidades_jugadas + 4
    cmp byte ptr [bx], 1
    jne u5_ok
    jmp repetida
u5_ok:
    mov byte ptr [bx], 1
    inc byte ptr [completadas]
    call jugar_io
    call actualizar_puntaje
    jmp volver_menu

;            UNIDAD REPETIDA 

repetida:
    call cambiar_color_gris
    lea dx, msg_repetido
    call imprimir_pantalla
    call sonido_error

    ; ==== PAUSA PARA QUE PUEDAS LEER EL CARTEL ====
    mov ah, 08h      ; esperar una tecla (sin eco)
    int 21h

    call cambiar_color_amarillo
    jmp menu_principal

;   VOLVER AL MENU 
volver_menu:
    call cls_azul_10h
    call cambiar_color_amarillo
    call actualizar_puntaje
    lea dx, cartel
    call imprimir_pantalla
    jmp menu_principal

;  FINAL DEL JUEGO 
fin_juego:
    call cls_azul_10h
    call cambiar_color_amarillo
    call actualizar_puntaje

    lea dx, msg_final
    call imprimir_pantalla
    call sonido_presentacion

    lea dx, msg_total
    call imprimir_pantalla

    mov al, [puntaje_total]
    xor ah, ah
    mov bx, offset nro_ascii
    call reg2ascii
    lea dx, nro_ascii
    call imprimir_pantalla

    ; mostrar "/25"
    mov dl, '/'
    mov ah, 02h
    int 21h
    mov dl, '2'
    int 21h
    mov dl, '5'
    int 21h

    ; ---- Corte de aprobacion: 13 o mas aprueba ----
    mov al, [puntaje_total]
    cmp al, 13
    jae aprobado_ok
    jmp desaprobado

aprobado_ok:
    ; 1) cartel
    lea dx, msg_aprobado
    call imprimir_pantalla
    
    int 62h ; nuestra segunda interrupcion que creamos de sonido de aprobado

    ; 2) Pausa antes de mostrar la BMP
    mov ah, 08h
    int 21h

    ; 3) BMP aprobado
    call imagenGana
    jmp fin

desaprobado:
    ; 1) cartel
    lea dx, msg_desaprobado
    call imprimir_pantalla

    ; 2) Pausa antes de mostrar la BMP
    mov ah, 08h
    int 21h

    ; 3) BMP desaprobado
    call imagenPierde
    jmp fin

fin:
    ; Mensaje final y salida
    lea dx, msg_salir
    call imprimir_pantalla
    mov ax, 4C00h
    int 21h

main endp


; SUBRUTINA: Mostrar menu dinamico

mostrar_menu_dinamico proc
    push ax
    push bx
    push dx

    ; Limpiar pantalla y dejarla en negro + azul, puntaje, etc.
    call cls_attr_10h        ; limpia con el atributo actual (después lo fijamos con azul)
    call cls_azul_10h
    call cambiar_color_amarillo
    call actualizar_puntaje

    ; Título fijo del menú
    lea dx, cartel_bienvenida
    call imprimir_pantalla

    ; Listar solo las unidades NO jugadas
    mov bx, offset unidades_jugadas

    cmp byte ptr [bx], 1
    je  skip1
    lea dx, opcion_1
    call imprimir_pantalla
skip1:
    cmp byte ptr [bx+1], 1
    je  skip2
    lea dx, opcion_2
    call imprimir_pantalla
skip2:
    cmp byte ptr [bx+2], 1
    je  skip3
    lea dx, opcion_3
    call imprimir_pantalla
skip3:
    cmp byte ptr [bx+3], 1
    je  skip4
    lea dx, opcion_4
    call imprimir_pantalla
skip4:
    cmp byte ptr [bx+4], 1
    je  skip5
    lea dx, opcion_5
    call imprimir_pantalla
skip5:

    ; Mensajito de "Mucha suerte..."
    lea dx, cartel
    call imprimir_pantalla

    ; Si la última entrada fue inválida, mostrar mensaje de error
    cmp byte ptr [ultimo_error_menu], 0
    je  no_hay_error

    ; Cambiamos a gris solo para el cartel de error
    call cambiar_color_gris
    lea dx, msg_error
    call imprimir_pantalla
    ; Volvemos a amarillo para el futuro
    call cambiar_color_amarillo

    ; limpiar flag para que en la próxima vuelta no se reimprima solo
    mov byte ptr [ultimo_error_menu], 0

no_hay_error:
    call actualizar_puntaje

    ;  mover el cursor a mitad de pantalla 
    ; Fila 12 (0-based) → ~ Y = 12*8 = 96 px ≈ 100
    mov ah, 02h        ; BIOS: set cursor position
    xor bh, bh         ; página 0
    mov dh, 12         ; fila 12
    mov dl, 0          ; columna 0
    int 10h

    pop dx
    pop bx
    pop ax
    ret
mostrar_menu_dinamico endp


end main
