;============================================================
; TP4_BMP_LIB.ASM - Librería BMP 320x200x256 (modo 13h)
;   Requisitos de los BMP: 320x200, 8bpp, BI_RGB (sin compresión)
;   Públicos:
;       wait_key, vga_text_mode
;       imagenGana,  imagenPierde          ; pantalla completa
;       imagenGana_half, imagenPierde_half ; mini 160x100 centrada
;       mostrarImagen, mostrarImagen_half  ; usa la de aprobado
;============================================================

.8086
.model small
.stack 100h

.data
; SOLO DOS NOMBRES:
filename1   db 'aprobado.bmp',0   ; imagen cuando APRUEBA
filename2   db 'des.bmp',0        ; imagen cuando DESAPRUEBA (ajustá al nombre real)

filehandle  dw 0
Header      db 54 dup (0)
Palette     db 256*4 dup (0)
ScrLine     db 320 dup (0)

msgNF       db 'BMP no encontrado.',13,10,'$'
msgGEN      db 'Error de lectura BMP.',13,10,'$'
msgSIG      db 'Firma no es BM.',13,10,'$'
msgFMT      db 'Formato invalido: usar 320x200, 8bpp, sin compresion.',13,10,'$'

topdown     db 0  ; 0=bottom-up, 1=top-down

.code

;================ utilidades de E/S ================
PrintStr proc
    mov ah,09h
    int 21h
    ret
PrintStr endp

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
    mov  bx, filehandle
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
    xor dx, dx
    mov dx, si
    xor cx, cx
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

;================ DIBUJO: tamaño completo ==================
CopyBitmap proc
    mov ax,0A000h
    mov es,ax

    mov cx,200
row_loop:
    push cx

    ; calcular DI destino por fila según topdown
    mov al, topdown
    or  al, al
    jnz topd

    ; bottom-up: screen_row = cx-1
    mov ax, cx
    dec ax
    mov di, ax
    shl ax, 6
    shl di, 8
    add di, ax
    jmp short di_ok

topd: ; top-down: screen_row = 200-cx
    mov ax, 200
    sub ax, cx
    mov di, ax
    shl ax, 6
    shl di, 8
    add di, ax

di_ok:
    ; leer una línea de archivo (320 bytes)
    mov ah,3Fh
    mov bx,filehandle
    mov cx,320
    mov dx,offset ScrLine
    int 21h

    ; copiar a VRAM
    cld
    mov cx,320
    mov si,offset ScrLine
    push di
    rep movsb
    pop di

    pop cx
    loop row_loop
    ret
CopyBitmap endp

;================ DIBUJO: mitad (160x100 centrado) =========
CopyBitmapHalf proc
    mov ax,0A000h
    mov es,ax

    mov cx,200
half_loop:
    push cx

    ; calcular screen_row según topdown en AX
    mov al, topdown
    or  al, al
    jnz half_topd

    mov ax, cx
    dec ax                  ; bottom-up: sr = cx-1
    jmp short have_sr
half_topd:
    mov ax, 200
    sub ax, cx              ; top-down: sr = 200-cx
have_sr:

    ; leer una línea de archivo (siempre se lee)
    mov ah,3Fh
    mov bx,filehandle
    mov cx,320
    mov dx,offset ScrLine
    int 21h

    ; ¿fila par? si es impar, no dibuja (pero ya leyó)
    test al, 1
    jnz half_skip_draw

    ; y_dst = 50 + sr/2
    mov bx, ax
    shr bx, 1
    add bx, 50

    ; di = y_dst*320 + 80  (centrado)
    mov di, bx
    mov ax, bx
    shl ax, 6
    shl di, 8
    add di, ax
    add di, 80

    ; copiar columnas pares: 160 píxeles
    cld
    mov si, offset ScrLine
    mov dx, 160
copy2_loop:
    mov al, [si]
    stosb
    add si, 2
    dec dx
    jnz copy2_loop

half_skip_draw:
    pop cx
    loop half_loop
    ret
CopyBitmapHalf endp

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
    cmp ax, 0FF38h               ; -200 en low (dos complementos)
    jne bad_fmt
    mov topdown, 1
h_ok:

    ; planes=1, bpp=8, comp=0, biSizeImage=0
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

    ; *** MODO 13h ANTES DE TOCAR PALETA ***
    call GfxMode

    ; Leer paleta
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
    mov dx, word ptr Header+10   ; low
    mov cx, word ptr Header+12   ; high
    call SeekAbs

    clc
    ret

bad_fmt:
    mov dx, offset msgFMT
    call PrintStr
    stc
    ret
PrepareAndValidate endp

;================ interfaz de alto nivel ====================
; EN: DX=ptr filename, AL=0->full, AL=1->half
ShowBmpByDX proc
    push ds
    push ax

    mov  ax, @data
    mov  ds, ax

    call OpenByDX
    jc  sb_exit_text

    call ReadHeader
    jnc hdr_ok
    mov dx, offset msgGEN
    call PrintStr
    jmp sb_fail
hdr_ok:
    call PrepareAndValidate
    jnc draw
    jmp sb_fail
draw:
    pop ax                 ; AL = selector de tamaño
    cmp al, 1
    je  draw_half
    call CopyBitmap
    jmp drawn
draw_half:
    call CopyBitmapHalf
drawn:
    call CloseFile
    call wait_key
    call vga_text_mode
    pop ds
    ret
sb_fail:
    pop ax
    call CloseFile
sb_exit_text:
    call wait_key
    call vga_text_mode
    pop ds
    ret
ShowBmpByDX endp

;----------- Wrappers públicos ------------------------------
public mostrarImagen, mostrarImagen_half
public imagenGana, imagenGana_half
public imagenPierde, imagenPierde_half

; mostrarImagen usa la de aprobado (filename1)
mostrarImagen proc
    mov dx, offset filename1
    xor ax, ax            ; AL=0 -> full
    call ShowBmpByDX
    ret
mostrarImagen endp

mostrarImagen_half proc
    mov dx, offset filename1
    mov ax, 1             ; AL=1 -> half
    call ShowBmpByDX
    ret
mostrarImagen_half endp

imagenGana proc
    mov dx, offset filename1
    xor ax, ax
    call ShowBmpByDX
    ret
imagenGana endp

imagenGana_half proc
    mov dx, offset filename1
    mov ax, 1
    call ShowBmpByDX
    ret
imagenGana_half endp

imagenPierde proc
    mov dx, offset filename2
    xor ax, ax
    call ShowBmpByDX
    ret
imagenPierde endp

imagenPierde_half proc
    mov dx, offset filename2
    mov ax, 1
    call ShowBmpByDX
    ret
imagenPierde_half endp

; ---- compat antiguos por si tu MAIN viejo los llama ----
public show_aprobado, show_desaprobado
show_aprobado    proc
    call imagenGana
    ret
show_aprobado    endp

show_desaprobado proc
    call imagenPierde
    ret
show_desaprobado endp

end
