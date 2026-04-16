;;reg2Ascii

.8086
.model small
.stack 100h

.data
	var db 223
	nroAscii db '000',0dh,0ah,24h
	dataDiv  db 100,10,1 
.code
	main proc
	mov ax, @data
	mov ds, ax


;VERSION AUTOMÁTICA
	mov ah, 0
	mov bx, 0
	mov cx, 3
	mov al, var
reg2Ascii:
	mov dl, dataDiv[bx]
	div dl
	add nroAscii[bx],al
	mov al, ah 
	mov ah, 0
	inc bx

loop reg2Ascii


;FIN VERSION AUTOMÁTICA

	mov dl, 100 
	mov ah, 0 
	mov al, var    ; AX 00000000,11011111

	div dl
	add nroAscii[0],al   ; ACA FUE el 2
	mov al, ah           ;MUEVO EL RESTO (23), para volver a dividirlo
	mov ah, 0
	mov dl, 10 
	div dl
	add nroAscii[1],al   ;ACA FUE EL OTRO 2
	add nroAscii[2],ah   ;ACA FUE EL 3


	mov ah, 9
	mov dx, offset nroAscii
	int 21h

	mov ax, 4c00h
	int 21h

	main endp
end