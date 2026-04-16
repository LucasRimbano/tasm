.8086
.model small

extrn puntaje_total:byte
extrn reg2ascii:proc
extrn seg_dgroup:word

.data
txt_puntaje db "Puntaje: ", '$'
txt_total   db "/25", '$'
nro_ascii   db '00', '$'

.code
public actualizar_puntaje

actualizar_puntaje proc
    push ax
    push bx
    push dx
    push ds                 ; guardo el DS del llamador

    ; forzar DS correcto para leer puntaje_total
    mov ax, [seg_dgroup]
    mov ds, ax

    ; 🧭 Posicionar cursor (fila 0, columna 65 aprox)
    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 65
    int 10h

    ; 📝 Mostrar "Puntaje: "
    lea dx, txt_puntaje
    mov ah, 09h
    int 21h

    ; 🔢 Convertir puntaje a ASCII
    mov al, [puntaje_total] ; (ahora DS es el bueno)
    mov bx, offset nro_ascii
    call reg2ascii

    ; 💬 Mostrar el número convertido
    lea dx, nro_ascii
    mov ah, 09h
    int 21h

    ; ➗ Mostrar "/25"
    lea dx, txt_total
    mov ah, 09h
    int 21h

    pop ds                  ; restauro DS del llamador
    pop dx
    pop bx
    pop ax
    ret
actualizar_puntaje endp

end
