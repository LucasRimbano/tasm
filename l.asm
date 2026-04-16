;============================================================
; REEMPLAZAR_FINAL.ASM
; Lee un texto de hasta 20 caracteres.
; Luego pide una letra a buscar y otra para reemplazar.
; Reemplaza las coincidencias con '&', muestra cuántos cambios
; se hicieron y el largo del texto ingresado.
;
; Compatible con TASM/TLINK/EMU8086 y DOSBox.
;============================================================

.8086
.model small
.stack 100h

.data
msg_ingreso   db 0Dh,0Ah,'Ingrese texto (max 20 caracteres): $'
msg_error     db 0Dh,0Ah,'Error: maximo 20 caracteres. Reintente.$'
msg_letra_bus db 0Dh,0Ah,'Letra a buscar: $'
msg_letra_rep db 0Dh,0Ah,'Letra nueva: $'
msg_res       db 0Dh,0Ah,'Texto modificado: $'
msg_cant      db 0Dh,0Ah,'Cantidad de reemplazos: $'
msg_largo     db 0Dh,0Ah,'Largo total del texto: $'
nl            db 0Dh,0Ah,'$'

buffer        db 21          ; tamaño máximo (20 + 1)
               db ?           ; longitud real ingresada
texto         db 20 dup('$')  ; área de texto (máx 20)
letra_buscar  db ?
letra_reemp   db ?
cont_reemp    db 0
longitud      db 0
num_ascii     db '00','$'

.code
main proc
    mov ax, @data
    mov ds, ax

;------------------------------------------------------------
pedir_texto:
    lea dx, msg_ingreso
    mov ah,09h
    int 21h

    ; Leer cadena (INT 21h, AH=0Ah)
    lea dx, buffer
    mov ah,0Ah
    int 21h

    ; AL = longitud ingresada (sin el ENTER)
    mov al, [buffer+1]
    dec al                    ; <-- descarta el ENTER final
    mov longitud, al

    ; si longitud > 20 => error
    cmp al, 20
    ja  error_long

    ; Guardar '$' al final del texto
    mov cl, al
    mov si, offset texto
    add si, cx
    mov byte ptr [si], '$'
    jmp pedir_letras

;------------------------------------------------------------
error_long:
    lea dx, msg_error
    mov ah,09h
    int 21h
    jmp pedir_texto

;------------------------------------------------------------
pedir_letras:
    lea dx, msg_letra_bus
    mov ah,09h
    int 21h
    mov ah,01h
    int 21h
    mov letra_buscar, al

    lea dx, msg_letra_rep
    mov ah,09h
    int 21h
    mov ah,01h
    int 21h
    mov letra_reemp, al

;------------------------------------------------------------
    ; Copiar texto del buffer al área de trabajo
    mov cl, longitud
    mov si, offset buffer+2
    mov di, offset texto
copiar:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copiar

;------------------------------------------------------------
    ; Reemplazar letras buscadas por '&'
    mov si, offset texto
    mov cl, longitud
    mov bl, letra_buscar
    mov byte ptr cont_reemp, 0

reemplazar:
    mov al, [si]
    cmp al, bl
    jne no_match
    mov byte ptr [si], '&'
    inc byte ptr cont_reemp
no_match:
    inc si
    loop reemplazar

;------------------------------------------------------------
    ; Mostrar resultados
    lea dx, msg_res
    mov ah,09h
    int 21h

    lea dx, texto
    mov ah,09h
    int 21h

    lea dx, nl
    mov ah,09h
    int 21h

    lea dx, msg_cant
    mov ah,09h
    int 21h
    mov al, cont_reemp
    call imprimir_num

    lea dx, msg_largo
    mov ah,09h
    int 21h
    mov al, longitud
    call imprimir_num

    lea dx, nl
    mov ah,09h
    int 21h

    ; Salida limpia
    mov ax,4C00h
    int 21h
main endp

;------------------------------------------------------------
; convierte AL (0–99) a dos dígitos ASCII y muestra
imprimir_num proc
    mov ah,0
    mov bl,10
    div bl
    add al,'0'
    add ah,'0'
    mov num_ascii, al
    mov num_ascii+1, ah
    lea dx, num_ascii
    mov ah,09h
    int 21h
    ret
imprimir_num endp

end main
