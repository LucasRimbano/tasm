.8086
.model small
.stack 100h

.data
public puntaje_total
puntaje_total db 12

.code
extrn actualizar_puntaje:proc

main proc
    mov ax, @data
    mov ds, ax

    call actualizar_puntaje

    mov ax, 4C00h
    int 21h
main endp
end main
