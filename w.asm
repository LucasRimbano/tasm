.8086
.model small
.stack 100h

.code
extrn sonido_error:proc

main proc
    call sonido_error
    mov ax, 4C00h
    int 21h
main endp

end main
