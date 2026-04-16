.8086
.model small
.stack 100h
.data

	texto  db 255 dup (24h),0dh,0ah, 24h
	texto2 db 255 dup (24h),0dh,0ah, 24h
	salto  db 0dh,0ah,24h
.code
	main proc
	mov ax, @data
	mov ds, ax


;COMIENZA CAJA DE CARGA
	mov bx, 0 

	carga:
		mov ah, 1 
		int 21h 
		cmp al, 0dh 
		je finCarga

		mov texto[bx], al 
		cmp al, 'a'
		je cambiaMay
		cmp al, 'e'
		je cambiaMay
		cmp al, 'i'
		je cambiaMay
		cmp al, 'o'
		je cambiaMay
		cmp al, 'u'
		je cambiaMay
	guardoValor:
		mov texto2[bx], al
		inc bx

	jmp carga 

	cambiaMay:
		sub al, 20h
	jmp guardoValor

	finCarga:
;FIN CAJA DE CARGA

		mov bx, 0
	proximaLetra:

		cmp texto[bx], 00100100b
		je terminoCambio    
		cmp texto[bx],'a'    
		je cambia
		cmp texto[bx],'e'
		je cambia
		cmp texto[bx],'i'
		je cambia
		cmp texto[bx],'o'
		je cambia
		cmp texto[bx],'u'
		je cambia
	continuaCambio:
		inc bx
	jmp proximaLetra

	cambia:
		sub texto[bx],20h
		jmp continuaCambio

	terminoCambio:
	
	mov ah, 9
	mov dx, offset texto2
	int 21h


	mov ah, 9
	mov dx, offset salto
	int 21h

	mov ah, 9
	mov dx, offset texto
	int 21h
	
	mov ax, 4c00h
	int 21h
	main endp
end