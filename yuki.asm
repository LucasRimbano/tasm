.8086
.model small
.stack 100h

.data
    cartel db "Bienvenido al mundo pa..." ,0dh,0ah
           db "Ingrese una oracion loquitroqui..." ,0dh,0ah,'$'
    texto_a_ingresar db 256 dup (24h),0dh,0ah,'$'
    texto_modificado db 256 dup (24h) ,0dh,0ah,'$'
    texto_sin_espacio db 256 dup (24h) ,0dh,0ah,'$'
    enters db 0dh,0ah,'$'

.code

    mov ax, @data
    mov ds , ax

   call mostrar_cadena
  
   call ingresar_un_texto

   call modificar_texto
 
   call sacar_espacios
   

   mov ax , 4c00h
   int 21h




 mostrar_cadena proc
    push ax ; guarda el valor actual de ax en la puila
    push dx  ;guarda el valor acutal de dx que contiene la dir de texto
    pop dx  ;recupera el valor de dx desde la pila (la ultima q se guardo)


    mov ah, 09h
    lea dx, cartel
    int 21h
    pop ax  ;recupera el valor orgiignal de ax 
    ret
 mostrar_cadena endp

ingresar_un_texto proc
    mov bx, 0 
 carga_texto:   
    mov ah , 01h
    int 21h
    cmp al ,0dh
    je fin_carga
    mov texto_a_ingresar [bx] ,al
    mov texto_modificado[bx],al
    inc bx
 jmp carga_texto    

fin_carga:
    mov texto_a_ingresar[bx] , 24h
    mov bx, 0

 

    ret
ingresar_un_texto endp

modificar_texto proc
    mov bx , 0 
comparar:
    mov al, texto_modificado[bx]
    cmp al , 24h
    je fin_comparar
    cmp al , 'a'
    jb no_cambio
    cmp al , 'z'
    ja no_cambio
    sub al , 20h

no_cambio:
    mov texto_modificado[bx],al
    inc bx
jmp comparar

fin_comparar:
    mov  texto_modificado[bx] ,24h
    mov bx , 0 
   
    mov ah, 09h
    lea dx , texto_modificado
    int 21h    

ret
modificar_texto endp

sacar_espacios proc ; preservo el etado de los registro antes que se modifique
    push ax         ;guarda original de ax 
    push bx         ;guarda el indice de lkectura
    push si        ;guarda el indice de esfritura
    push dx         ;guarda la direcion de texto q paso por pila
    pop dx ; recupear direcion del texto de la pil a 
    mov bx, 0
    mov si ,0

comparar_esp:
    mov al , texto_a_ingresar[bx]
    cmp al , 24h
    je fin_comparar_esp

    cmp al , ' '
    je es_espacio

    mov texto_sin_espacio[si] ,al
    inc si
    inc bx
jmp comparar_esp    

es_espacio: 
    mov al , '_'
    mov texto_sin_espacio [si] ,al
    inc si
    inc bx 
jmp comparar_esp    

fin_comparar_esp:
    mov texto_sin_espacio[si] , 24h
   

    mov ah , 09h
    lea dx , enters
    int 21h

    mov ah , 09h
    lea dx, texto_sin_espacio
    int 21h   

pop si
pop bx
pop ax    
ret
sacar_espacios endp


end