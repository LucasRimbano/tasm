.8086
.model small
.stack 100h
.data
	caracteres  db "!#$%&'()*+,-./:; ",22h 
				db "<=>?@[\]^_`{|}~1234567890",0
	texto 		db 255 dup (24h),0dh,0ah,24h
.code
	main proc
	mov ax, @data
	mov ds, ax

	mov bx, 0
carga:
	mov ah, 1
	int 21h
	cmp al, 0dh
	je finCarga
	mov texto[bx],al 
	inc bx
jmp carga

finCarga:
mov bx, 0
jmp primerCaracter
compara:
	cmp texto[bx],24h
	je finCompara
	cmp texto[bx], 20h
	je casiPalabra
incrementa:
	inc bx
jmp compara

esEspecial:	
casiPalabra:
	mov si, 0
	inc bx
comparacionCaracteres:
	cmp caracteres[si],0
	je finComparacion
	mov al, caracteres [si]
	cmp texto[bx], al
	je esEspecial
	inc si 
jmp comparacionCaracteres

finComparacion:
primerCaracter:
	cmp texto[bx], 60h
	ja  casiMinuscula           ;Jump Above   / Jump Below    SIN SIGNO
	jmp incrementa				;Jump Greater / Jump Lower    CON SIGNO	

casiMinuscula:
	cmp texto[bx], 7bh
	jb esMinuscula
	jmp incrementa

esMinuscula:
	sub texto[bx],20h
	jmp incrementa

finCompara:
	mov ah,9
	mov dx, offset texto
	int 21h

	mov ax, 4c00h
	int 21h
	main endp
end