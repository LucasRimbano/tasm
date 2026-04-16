.8086
.model small
.stack 100h

.data
	esPalin db "el texto "
	textoImp db 255 dup (24h),0dh,0ah,24h
	no db " no"
	resultado db " es palindromo",0dh, 0ah, 24h
	largoTexto db 0
	texto db 255 dup (24h),0dh,0ah,24h	
	
.code
	main proc
	mov ax, @data
	mov ds, ax

	mov bx, 0
	mov di, 0

	carga:
		mov ah, 1
		int 21h
		cmp al, 0dh
		je finCarga 
	cmp al, 20h
	je eraEspacio
		mov texto[di],al 
		mov textoImp[bx],al 
		inc bx
		inc di
	jmp carga
	eraEspacio:
		mov textoImp[bx],al 
		inc bx
	jmp carga

finCarga:
	dec di
	mov bx, di     			;PARADO EN LA ULIMA POSICIÓN   ;TEXTO[bx]
	mov largoTexto, bl
;MAYUSCULIZO
	mov bx, 0
	mayus:
		cmp bl, largoTexto
		ja finMayus
		cmp texto[bx],60h
		ja casiMinusc
	incrementa:
		inc bx
	jmp mayus 

	casiMinusc:
		cmp texto[bx],7bh
		jb esMinus
	jmp incrementa

	esMinus:
		sub texto[bx], 20h
	jmp incrementa

finMayus:

;ARRANCO PROCESO
	mov bx, 0
	mov bl, largoTexto	
	mov si, 0  			;PARADO EN LA PRIMERA POSICIÓN ;TEXTO[si]
	procesa:
		cmp bx, si
		jb esPalindromo
		mov al, texto[si]
		cmp texto[bx], al 
		jne noesPalin
		inc si
		dec bx
	jmp procesa

esPalindromo:
	
	mov ah, 9
	mov dx, offset esPalin
	int 21h
	mov ah, 9
	mov dx, offset resultado
	int 21h
	jmp fin 

noEsPalin:
	
	mov ah, 9
	mov dx, offset esPalin
	int 21h
	mov ah, 9
	mov dx, offset no
	int 21h

fin:
	mov ax, 4c00h
	int 21h
	main endp
end