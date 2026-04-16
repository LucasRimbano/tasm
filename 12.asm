;1ER PARCIAL 1 CUATRIMESTRE 2025
;ESTE PROGRAMA DEBE PERMITIR INGRESAR UN TEXTO:
;IMPRIMIR EN PANTALLA ESE TEXTO INGRESADO CON LOS SIGNOS DE PUNTUACION ELIMINADOS
;IMPRIMIR EN PANTALLA ESE TEXTO INVERTIDO PERO CONSERVANDO LOS SIGNOS DE PUNTUACION

.8086
.model small
.stack 100h
.data
		cartelito db "hola bienvenidos al programa...",0dh,0ah
                  db "Ingrese un texto para luego eliminar los signos de puntuacion y mostrarlo invertido",0dh,0ah,24h
                  db "texto modificado:",0ah,0ah,24h
            texto db 256 dup (24h),0dh,0ah,24h
            enters db 0 ,0dh,0ah,24h
            texto_modificado db 256 dup (24h),0dh,0ah,24h
.code
	main proc
		mov ax, @data
		mov ds, ax

        mov ah ,09h
        lea dx , cartelito
        int 21h
        mov bx,0

        carga_texto:
         mov ah, 01h
         int 21h
        cmp al, 0dh
        je fin_texto
        mov texto[bx],al
        mov texto_modificado[bx],al 

        inc bx
        jmp carga_texto

        fin_texto:
        mov texto[bx],'$'
        mov texto_modificado[bx],'$'
        mov bx,0
        compara:

        cmp texto[bx],24h ;hola mundo $ 
        je fin_compara
        cmp texto[bx],'!' 
        je espacio
        cmp texto[bx],'$' 
        je espacio
        cmp texto[bx],',' 
        je espacio
        cmp texto[bx],'!' 
        je espacio
        cmp texto[bx],'?' 
        je espacio
        
        incrementar:
        inc bx
        jmp compara
        
        espacio:
        mov texto_modificado [bx],20h
        jmp incrementar



        fin_compara:
        mov ah,09h
        lea dx,texto_modificado
        int 21h


        mov ax, 4c00h
		int 21h
	main endp

	end