.8086      ;le dice que procesador usar 	
.model small ;selecciona el moodo de la memoria a utilizar
.stack 100h ;selecciona el modo de stack que seria la cantidad de bytes q vas a crear para guardar los segmentos data
.data.  ;crea el segmento de datos
	texto db "hola chicos",0dh,0ah,24h.  crea una variable texto db inicializado. despues retorno de carro y salta de linea y enter
	
.code.   ;aca arranca segmento de codigo
	main proc

		mov ax, @data
		mov ds, ax

		mov ah, 9 ; LLAMO AL SERVICIO DE IMPRESION
		mov dx, offset texto ; muevo al registro DX la dirección de mi variable
		int 21h

		mov ah, 4ch ; LLAMO AL SERVICIO PARA TERMINAR
		mov al, 00h ; LE DEVUELVO 00 PORQUE TERMINE BIEN! 
		int 21h


	main endp
end
