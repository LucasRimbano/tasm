.8086
.model small
.stack 100h
.code
main proc
    int 60h
    mov ax,4C00h
    int 21h
main endp
end main
