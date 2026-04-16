;============================================================
; MAIN mínimo para probar bmp_lib.asm
; Muestra "aprobado.bmp", espera una tecla y vuelve a texto.
;============================================================

.8086
.model small
.stack 100h

.code
extrn show_aprobado:proc
extrn wait_key:proc
extrn vga_text_mode:proc

main proc
    ; (no hace falta DS porque no usamos .data ni cadenas acá)
    
    ; Mostrar BMP
    call show_aprobado

    ; Esperar tecla y volver a modo texto
    call wait_key
    call vga_text_mode

    ; Salir a DOS
    mov ax, 4C00h
    int 21h
main endp

end main
