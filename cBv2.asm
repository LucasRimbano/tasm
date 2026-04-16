.8086
.model small
.stack 100h

.data
	datoLeido db 0
	datoLeidoAscii db '000',0dh,0ah,24h
	cartelin db "ingrese un nro binario de 8 bits", 0dh,0ah,24h
	dataDiv db 100,10,1
	salto db 0dh,0ah,24h
.code
main proc
	mov ax, @data
	mov ds, ax

;CAJA DE CARGA BINARIA

	;MI VALOR EN BIN lo VOY A GUARDAR EN DL
resetea:
	mov ah,9
	mov dx, offset cartelin
	int 21h

	xor dx, dx 
    mov cx, 8

carga:
	mov ah, 8 
	int 21h 
 	cmp al, 30h
 	je esCero
 	cmp al, 31h
 	je esUno

 	jmp carga

esUno:
 	mov ah, 2
 	mov dl, 31h
 	int 21h

 	shl dh, 1
 	inc dh 
 prox:
 loop carga
 jmp reg2ascii
esCero:

 	mov ah, 2
 	mov dl, 30h
 	int 21h
 	shl dh, 1
 jmp prox

reg2ascii:
 	mov datoLeido, dh
 	xor ah, ah 
;REG 2 ASCII 
	mov cx, 3
	lea bx, datoLeidoAscii
	lea si, dataDiv
	xor ah, ah 
	mov al, datoLeido

r2a:
	mov dl, byte ptr [si] ;MUEVO EL 100
	div dl 
	add byte ptr [bx],al 
	mov al, ah
	mov ah, 0
	inc bx
	inc si 
loop r2a

mov ah,9
mov dx, offset salto
int 21h

mov ah,9
mov dx, offset datoLeidoAscii
int 21h


	mov ax, 4c00h
	int 21h


main endp
end