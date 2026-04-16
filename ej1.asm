;Ingrese un texto de hasta 255 caracteres terminados por el signo $.Imprima el
;texto modificando la letra a por la letra x. Imprima el texto modificado y luego
;el texto original.

.8086
.model small
.stack 100h
.data
	texto 	  db 255 dup (24h),0dh,0ah,24h; lleno la variable texto con signos pesos $
	textoMod  db 255 dup (24h),0dh,0ah,24h; lleno la variable texto con signos pesos $
	Cartelito db "Este es un software que cambia A x X Inclusivo pre-Histórico",0dh,0ah
			  db "Ingrese un texto: ",0dh,0ah, 24h
	
.code
main proc
	mov ax,@data
	mov ds, ax

	mov ah,9 				 ;LLAMO AL SERVICIO 9 DE IMPRESION DE LA INT 21
	mov dx, offset Cartelito
	int 21h

	mov bx, 0    			; DIR+IDX  

carga:
	cmp bx, 256
	je finCarga
	mov ah, 1  				 ;LLAMO AL SERVICIO 1 PARA LECTURA DE CARACTER POR TECLADO 
	int 21h 
	cmp al, 0dh
	je finCarga
	mov texto[bx], al 
	mov textoMod[bx],al
	inc bx 					 ; es lo mismo que add bx, 1

jmp carga


finCarga:

	mov bx, 0

compara:
	cmp textoMod[bx], 24h
	je finCompara
	cmp textoMod[bx], 'a'
	je CambiaX
	cmp textoMod[bx], 'A'
	je CambiaXMay

incrementa:
	inc bx 
jmp compara

CambiaX:
	mov textoMod[bx],'x'
	jmp incrementa

CambiaXMay:
	mov textoMod[bx],'X'
	jmp incrementa

finCompara:

	mov ah, 9
	mov dx, offset textoMod
	int 21h

	mov ah, 2
	mov dl, 0dh
	int 21h

	mov ah, 2
	mov dl, 0ah
	int 21h


	mov ah, 2
	mov dl, 24h
	int 21h

	mov ah, 9
	mov dx, offset texto
	int 21h

	mov ax, 4c00h
	int 21h

main endp
end