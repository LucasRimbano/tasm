.8086
.model small
.stack 100h


.data
    var db 223
    nroAscii db '000' ,0dh,0ah,'$'
    dataDiv db 100, 10 ,1
    ingrese_oracion db "Ingrese una oracion..." ,0dh,0ah,'$'
    oracion_ingresada db 100 dup('$')
    palabra_count db 0 
    resultado db "cantidad de palabras" , 04h,0ah,'$'
.code

    main proc
    mov ax , @data
    mov ds ,ax
   
    mov ah ,09h
    mov dx , offset ingrese_oracion
    int 21h 

    
    mov bx , 0 ; indice en data / nroAscii
  
    
    

carga:
    mov ah , 01h 
    int 21h
    cmp al, 0dh
    je fin_carga
    mov ingrese_oracion[bx] ,al
    mov oracion_ingresada[bx],al
    inc bx  
jmp carga    

fin_carga:
    mov oracion_ingresada[bx],'$'

    mov bx, 0
    mov dl, 0
    mov cl ,0

contar_loop:
    mov al, oracion_ingresada[bx]
    cmp al , '$'
    je fin_contar

    cmp al, 20h ;compara con el caracter espacio
    je es_espacio

    cmp dl, 1
    je sigue_palabra

    inc cl
    mov dl,1
    jmp sigue_palabra


es_espacio:
    mov dl , 0 ;salimos de la sigue_palabra
sigue_palabra:
    inc bx
    jmp contar_loop

fin_contar:
    mov palabra_count, cl
    
    ; limpiar nroAscii
    mov nroAscii[0], '0'
    mov nroAscii[1], '0'
    mov nroAscii[2], '0'
    mov ax, 0 
    mov al ,palabra_count
    mov bx, 0  ;
    mov cx ,3   ; vamos a hacer 3 div


; como convertir un numero binario en ASCII decimal 
;para poder mostrar en pantalla
reg2Ascii:
    mov dl ,    dataDiv[bx] ; divisor (100,10,1)
    div dl      ; a / dl 
    add al , '0'    ;convertir ascii
    mov  nroAscii[bx] ,al ; guardar digito convertido
    mov al , ah ;pasa el resto a al
    mov ah, 0 
    inc bx
loop reg2Ascii

    mov ah ,09h
    mov dx, offset resultado
    int 21h 

    
    mov ah ,09h
    mov dx, offset nroAscii
    int 21h

    mov ah ,09h
    mov dx , offset dataDiv
    int 21h
    
 




    mov ax , 4c00h
    int 21h
    main endp
end
``