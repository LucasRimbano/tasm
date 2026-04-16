; TP4_BMP.ASM - Librería BMP 320x200x256 (modo 13h)
;   imagenGana     -> aprobado.bmp
;   imagenPierde   -> desaprobado.bmp
;   mostrarImagen  -> veamos.bmp   (opcional)
; Además exporta wrappers:
;   show_aprobado  -> llama a imagenGana
;   show_desaprobado -> llama a imagenPierde
;   wait_key / vga_text_mode
; Requiere BMP: 320x200, 8bpp, BI_RGB (sin compresion)

.8086
.model small
.stack 100h

.data
filename   db 'veamos.bmp',0           ; opcional
filename1  db 'aprobado.bmp',0         ; <<-- cambiado
filename2  db 'desaprobado.bmp',0      ; <<-- cambiado

filehandle dw 0

Header     db 54 dup (0)
Palette    db 256*4 dup (0)
ScrLine    db 320 dup (0)

msgNF      db 'BMP no encontrado.',13,10,'$'
msgGEN     db 'Error de lectura BMP.',13,10,'$'
msgSIG     db 'Firma no es BM.',13,10,'$'
msgFMT     db 'Formato invalido: usar 320x200, 8bpp, sin compresion.',13,10,'$'

topdown    db 0                        ; 0=bottom-up, 1=top-down

.code

;================ utilidades de E/S ================
PrintStr proc
    mov ah,09h
    int 21h
    ret
PrintStr endp

; --- wrappers públicos por compatibilidad ---
public wait_key, vga_text_mode
wait_key proc
    mov ah,08h
    int 21h
    ret
wait_key endp

vga_text_mode proc
    mov ax,0003h
    int 10h
    ret
vga_text_mode endp
; ---------------------------------------------

TextMode proc
    mov ax,0003h
    int 10h
    ret
TextMode endp

GfxMode proc
    mov ax,0013h
    int 10h
    ret
GfxMode endp

;============ helpers de archivo ===============
OpenByDX proc       ; EN: DX=ptr ASCIIZ
    mov ah,3Dh
    xor al,al
    int 21h
    jnc open_ok
    mov filehandle,0
    mov dx, offset msgNF
    call PrintStr
    stc
    ret
open_ok:
    mov filehandle, ax
    clc
    ret
OpenByDX endp

CloseFile proc
    mov bx, filehandle
    or  bx, bx
    jz  cf_done
    mov ah,3Eh
    int 21h
cf_done:
    ret
CloseFile endp

; SeekAbs: ENTRADA -> CX:DX = offset absoluto (HIGH en CX, LOW en DX)
SeekAbs proc
    push ax
    mov  ax, 4200h      ; desde inicio
    int  21h
    pop  ax
    ret
SeekAbs endp


;=========== lectura de partes BMP ============
ReadHeader proc
    mov ah,3Fh
    mov bx,filehandle
    mov cx,54
    mov dx,offset Header
    int 21h
    jc  rh_err
    cmp ax,54
    jne rh_err
    clc
    ret
rh_err:
    stc
    ret
ReadHeader endp

; Lee la paleta desde start_pal = 14 + biSize.
; Si viene <1024 bytes, rellena el resto con gris.
ReadPalette proc
    push ax bx cx dx si di

    ; start_pal = 14 + biSize (low word)
    mov si, word ptr Header+14
    add si, 14

    ; seek absoluto a start_pal
    mov bx, filehandle
    xor dx, dx
    mov dx, si
    call SeekAbs

    ; pal_len = min(1024, bfOffBits - start_pal)
    mov ax, word ptr Header+10       ; bfOffBits (low)
    sub ax, si
    jc  pal_none
    mov cx, ax
    cmp cx, 400h
    jbe pal_len_ok
    mov cx, 400h
pal_len_ok:

    ; leer paleta disponible
    mov ah, 3Fh
    mov bx, filehandle
    mov dx, offset Palette
    int 21h
    jc  rp_err

    ; AX = bytes leídos
    cmp ax, 400h
    jae rp_ok

    ; completar con gris desde Palette+AX hasta 1024
    mov di, offset Palette
    add di, ax
    mov dx, ax
    shr dx, 2            ; DL = índice de entrada 0..255
    mov cx, 400h
    sub cx, ax
rp_fill_loop:
    mov al, dl
    shr al, 2            ; 0..63
    mov [di],     al     ; B
    mov [di+1],   al     ; G
    mov [di+2],   al     ; R
    mov byte ptr [di+3], 0
    add di, 4
    inc dl
    sub cx, 4
    jnz rp_fill_loop

rp_ok:
    clc
    pop di si dx cx bx ax
    ret

pal_none:
    ; no hay paleta explícita → generar gris completa
    mov di, offset Palette
    xor dl, dl
    mov cx, 256
pn_loop:
    mov al, dl
    shr al, 2
    mov [di],     al
    mov [di+1],   al
    mov [di+2],   al
    mov byte ptr [di+3], 0
    add di, 4
    inc dl
    loop pn_loop
    clc
    pop di si dx cx bx ax
    ret

rp_err:
    stc
    pop di si dx cx bx ax
    ret
ReadPalette endp


CopyPal proc
    mov si, offset Palette
    mov cx, 256
    mov dx, 3C8h
    xor al, al
    out dx, al
    inc dx            ; 3C9h
pal_loop:
    mov al, [si+2]    ; R
    shr al,1
    shr al,1
    out dx, al
    mov al, [si+1]    ; G
    shr al,1
    shr al,1
    out dx, al
    mov al, [si]      ; B
    shr al,1
    shr al,1
    out dx, al
    add si, 4
    loop pal_loop
    ret
CopyPal endp

CopyBitmap proc
    mov ax,0A000h
    mov es,ax

    mov cx,200
row_loop:
    push cx
    mov al, topdown
    or  al, al
    jnz topd

    ; bottom-up
    mov ax, cx
    dec ax
    mov di, ax
    shl ax, 6
    shl di, 8
    add di, ax
    jmp short di_ok

topd: ; top-down
    mov ax, 200
    sub ax, cx
    mov di, ax
    shl ax, 6
    shl di, 8
    add di, ax
di_ok:
    mov ah,3Fh
    mov bx,filehandle
    mov cx,320
    mov dx,offset ScrLine
    int 21h

    cld
    mov cx,320
    mov si,offset ScrLine
    rep movsb

    pop cx
    loop row_loop
    ret
CopyBitmap endp

;=========== validador & posicionamientos ============
PrepareAndValidate proc  ; CF=0 listo para leer pixeles
    ; firma 'BM'
    mov ax, word ptr Header
    cmp ax, 'MB'
    je  sig_ok
    mov dx, offset msgSIG
    call PrintStr
    stc
    ret
sig_ok:
    ; biSize = 40
    mov ax, word ptr Header+14
    cmp ax, 40
    je  size_ok
    mov dx, offset msgFMT
    call PrintStr
    stc
    ret
size_ok:
       ; ---- 320x200 (o -200 top-down) ----
    mov ax, word ptr Header+18
    cmp ax, 320
    jne bad_fmt

    ; biHeight (DWORD con signo)
    mov ax, word ptr Header+22   ; low
    mov dx, word ptr Header+24   ; high (signo)
    mov topdown, 0
    cmp dx, 0                    ; alto positivo?
    jne maybe_neg
    cmp ax, 200
    je  h_ok
    jmp bad_fmt

maybe_neg:                       ; alto negativo (top-down)
    cmp dx, 0FFFFh               ; -1 en high
    jne bad_fmt
    cmp ax, 0FF38h               ; -200 en low
    jne bad_fmt
    mov topdown, 1
h_ok:

; planes=1, bpp=8, comp=0
    mov ax, word ptr Header+26
    cmp ax, 1
    jne bad_fmt
    mov ax, word ptr Header+28
    cmp ax, 8
    jne bad_fmt
    mov ax, word ptr Header+30
    or  ax, ax
    jne bad_fmt
    mov ax, word ptr Header+32
    or  ax, ax
    jne bad_fmt

    ; *** PONER MODO 13h ANTES DE TOCAR PALETA ***
    call GfxMode

    ; Leer paleta (smart: hace seek a 14+biSize y rellena si falta)
    call ReadPalette
    jnc pal_ok
    mov dx, offset msgGEN
    call PrintStr
    stc
    ret
pal_ok:
    ; Aplicar paleta
    call CopyPal

    ; Ir a bfOffBits (inicio de pixeles)
    mov bx, filehandle
    mov dx, word ptr Header+10   ; low
    mov dx, word ptr Header+12   ; high
    call SeekAbs

    clc
    ret

bad_fmt:
    mov dx, offset msgFMT
    call PrintStr
    stc
    ret
PrepareAndValidate endp

;================ interfaz pedida ================
public mostrarImagen
mostrarImagen proc
    push ds
    mov  ax, SEG filename        ; DGROUP de la librería
    mov  ds, ax
    mov  dx, OFFSET filename     ; "veamos.bmp" (opcional)
    ; --- a partir de acá queda igual que antes ---
    call OpenByDX
    jc  mi_exit_text
    call ReadHeader
    jnc hdr_ok0
    mov dx, offset msgGEN
    call PrintStr
    jmp mi_fail
hdr_ok0:
    call PrepareAndValidate
    jnc draw0
    jmp mi_fail
draw0:
    call CopyBitmap
    call CloseFile
    call wait_key
    call vga_text_mode
    pop  ds
    ret
mi_fail:
    call CloseFile
mi_exit_text:
    call wait_key
    call vga_text_mode
    pop  ds
    ret
mostrarImagen endp

public imagenGana
imagenGana proc
    push ds
    mov  ax, SEG filename1       ; DGROUP de la librería
    mov  ds, ax
    mov  dx, OFFSET filename1    ; "aprobado.bmp"
    call OpenByDX
    jc  ig_exit_text
    call ReadHeader
    jnc hdr_ok1
    mov dx, offset msgGEN
    call PrintStr
    jmp ig_fail
hdr_ok1:
    call PrepareAndValidate
    jnc draw1
    jmp ig_fail
draw1:
    call CopyBitmap
    call CloseFile
    call wait_key
    call vga_text_mode
    pop  ds
    ret
ig_fail:
    call CloseFile
ig_exit_text:
    call wait_key
    call vga_text_mode
    pop  ds
    ret
imagenGana endp

public imagenPierde
imagenPierde proc
    push ds
    mov  ax, SEG filename2       ; DGROUP de la librería
    mov  ds, ax
    mov  dx, OFFSET filename2    ; "desaprobado.bmp"
    call OpenByDX
    jc  ip_exit_text
    call ReadHeader
    jnc hdr_ok2
    mov dx, offset msgGEN
    call PrintStr
    jmp ip_fail
hdr_ok2:
    call PrepareAndValidate
    jnc draw2
    jmp ip_fail
draw2:
    call CopyBitmap
    call CloseFile
    call wait_key
    call vga_text_mode
    pop  ds
    ret
ip_fail:
    call CloseFile
ip_exit_text:
    call wait_key
    call vga_text_mode
    pop  ds
    ret
imagenPierde endp


; ---- Wrappers con los nombres que tu MAIN viejo podría pedir ----
show_aprobado    proc
    call imagenGana
    ret
show_aprobado    endp

show_desaprobado proc
    call imagenPierde
    ret
show_desaprobado endp

end
