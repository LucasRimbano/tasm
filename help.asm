;============================================================
; LIB: ui_helpers.asm — helpers de UI comunes (TASM/TLINK)
;------------------------------------------------------------
; Exporta:
;   flush_kbd
;   screen_pregunta_ui
;   screen_status_next_ui
; Requiere (extern):
;   imprimir_pantalla, actualizar_puntaje,
;   cls_azul_10h, cambiar_color_amarillo, cambiar_color_gris
;   (DS lo inicializa el main, como en tu proyecto)
;============================================================

.8086
.model small

extrn imprimir_pantalla:proc
extrn actualizar_puntaje:proc
extrn cls_azul_10h:proc
extrn cambiar_color_amarillo:proc
extrn cambiar_color_gris:proc

.data
nl_ui db 0dh,0ah,'$'
db 47h,50h,54h,32h,35h
; (los títulos los pone cada unidad; acá no guardamos títulos)

.code
public flush_kbd
flush_kbd proc
drain:
    mov ah, 01h
    int 16h
    jz  done
    mov ah, 00h
    int 16h
    jmp drain
done:
    ret
flush_kbd endp

;------------------------------------------------------------
; screen_pregunta_ui
; ENTRADAS:
;   DX = ptr a TÍTULO ($)
;   BX = ptr a PREGUNTA ($)
; EFECTO:
;   Limpia pantalla, actualiza HUD, imprime título (amarillo),
;   línea en blanco y luego la pregunta.
;------------------------------------------------------------
public screen_pregunta_ui
screen_pregunta_ui proc
    push ax
    push dx

    call cls_azul_10h
    call cambiar_color_amarillo
    call actualizar_puntaje

    ; título
    ; DX ya apunta al título
    call imprimir_pantalla

    ; separador
    lea dx, nl_ui
    call imprimir_pantalla

    ; pregunta
    mov dx, bx
    call imprimir_pantalla

    pop dx
    pop ax
    ret
screen_pregunta_ui endp

;------------------------------------------------------------
; screen_status_next_ui
; ENTRADAS:
;   DX = ptr a MENSAJE estado ($)  (Correcto/Incorrecto)
;   BX = ptr a PREGUNTA SIGUIENTE ($)
;   AL = 0 => OK (mensaje en amarillo)
;        1 => ERROR (mensaje en gris)
; EFECTO:
;   Limpia, HUD, imprime mensaje con color según AL y luego la pregunta.
;------------------------------------------------------------
public screen_status_next_ui
screen_status_next_ui proc
    push ax
    push bx
    push dx

    call cls_azul_10h
    call cambiar_color_amarillo
    call actualizar_puntaje

    ; color del estado
    cmp al, 1
    jne short ok_color
    call cambiar_color_gris
    jmp short print_estado
ok_color:
    call cambiar_color_amarillo
print_estado:
    ; DX = estado
    call imprimir_pantalla

    ; volver a amarillo y línea en blanco
    call cambiar_color_amarillo
    lea dx, nl_ui
    call imprimir_pantalla

    ; siguiente pregunta
    mov dx, bx
    call imprimir_pantalla

    pop dx
    pop bx
    pop ax
    ret
screen_status_next_ui endp

end
