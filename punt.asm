;============================================================
; LIBRERIA: puntaje.asm (versión estable corregida)
; Barra fija fila 0, col 65: "Puntaje: xx/25"
; - Guarda/restaura POS DE CURSOR bien
; - Usa [puntaje_total] y reg2ascii
;============================================================

.8086
.model small
.stack 100h

.data
txt_puntaje db "Puntaje: ", '$'
txt_total   db "/25", '$'
nro_ascii   db '000', '$'

.code
public actualizar_puntaje
extrn puntaje_total:byte
extrn reg2ascii:proc

actualizar_puntaje proc
    push ax
    push bx
    push cx
    push dx

    ; Guardar posición actual del cursor (AH=03h → DH=fila, DL=col)
    mov ah, 03h
    mov bh, 0
    int 10h
    push dx               ; <-- ahora sí guardamos la pos devuelta por BIOS

    ; Mover cursor a fila 0, col 65
    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 65
    int 10h

    ; "Puntaje: "
    lea dx, txt_puntaje
    mov ah, 09h
    int 21h

    ; número
    mov al, [puntaje_total]
    mov bx, offset nro_ascii
    call reg2ascii

    lea dx, nro_ascii
    mov ah, 09h
    int 21h

    ; "/25"
    lea dx, txt_total
    mov ah, 09h
    int 21h

    ; Restaurar posición original del cursor
    pop dx                ; recupero DH/DL que guardé
    mov ah, 02h
    mov bh, 0
    int 10h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
actualizar_puntaje endp

end
