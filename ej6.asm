.8086
.model small
.stack 100h

.data
	
	cantVocales 	 db 0
	cantConso 		 db 0

	cantVocalesAscii db "000 VOCALES ",0dh,0ah
	cantConsoAscii   db 30h,30h,30h," CONSONANTES",0dh,0ah,24h
	
	texto 			 db 255  dup (24h), 0dh,0ah, 24h
	cartelito    	 db "este es un cartelito para ingresar un texto",0dh,0ah,24h

	dataDiv 		 db 100,10,1
.code

	main proc
	mov ax, @data
	mov ds, ax

	;IMPRESION CARTELITO
		mov ah, 9
		mov dx, offset cartelito ; <=> lea dx ,cartelito
		int 21h

	;CAJA DE CARGA RELOADED ;)
		;texto[bx], [DIRtexto+bx] -> mov bx, offset texto
								   ; trabajo con... [bx]

		lea bx, texto
carga:
		mov ah, 1
		int 21h
		cmp al, 0dh

		je finCarga
		mov [bx],al 
		inc bx
		jmp carga

finCarga:

	;FIN CAJA CARGA RELOADED


lea bx, texto
 proceso:	
	cmp byte ptr [bx], 24h 
	je finProceso
	cmp byte ptr [bx],40h 
	ja casiMay
incre:
	inc bx
  jmp proceso

casiMay:
	cmp byte ptr [bx],5bh
	jb esMay
	cmp byte ptr [bx],60h
	ja casiMin
	jmp incre

casiMin:
	cmp byte ptr [bx],7bh
	jb esMinus
	jmp incre

esMinus:
	sub byte ptr [bx],20h
esMay:	
	cmp byte ptr [bx],'A'
	je esVoc
	cmp byte ptr [bx],'E'
	je esVoc
	cmp byte ptr [bx],'I'
	je esVoc
	cmp byte ptr [bx],'O'
	je esVoc
	cmp byte ptr [bx],'U'
	je esVoc
	jmp esConso

esConso:
	inc cantConso
	jmp incre

esVoc:
	inc cantVocales
	jmp incre

finProceso:
	
;REG 2 ASCII VOCALES
	mov cx, 3
	lea bx, cantVocalesAscii
	lea si, dataDiv
	xor ah, ah 
	mov al, cantVocales
   														;LA O Exclusiva o xOr da V solo cuando son DISTINTOS
														; XOR Al, Al si Al es  00100111
														;                      00100111
														;                      00000000
r2aVoc:
	mov dl, byte ptr [si] ;MUEVO EL 100
	div dl 
	add byte ptr [bx],al 
	mov al, ah
	mov ah, 0
	inc bx
	inc si 
loop r2aVoc

;REG 2 ASCII VOCALES
	mov cx, 3
	lea bx, cantConsoAscii
	lea si, dataDiv
	xor ah, ah 
	mov al, cantConso

r2aCons:
	mov dl, byte ptr [si] ;MUEVO EL 100
	div dl 
	add byte ptr [bx],al 
	mov al, ah
	mov ah, 0
	inc bx
	inc si 
loop r2aCons

	mov ah, 9
	mov dx, offset cantVocalesAscii
	int 21h


	mov ax, 4c00h
	int 21h
	main endp
end