;realizar un prgroama que lea 255 , luego lea 2 letras
; debe buscarlas en el texot y replmazarlas por # 
; luego devolver la cantidad de rmpelzasos y largo totaldel etexot

.8086
.model small
.stack 100h

.data 

    cartel db "Bienvenido al programa..." ,0dh,0ah
           db "Ingrese una oracion..." ,0dh,0ah
           db "Para luego cambiar letra A y S por la #..." ,0dh,0ah,'$'
    texto_a_ingresar db 255 dup (24h),0dh,0ah,'$'
    texto_modificado db 255 dup (24h) ,0dh,0ah,'$'
    enters db 0 ,0dh,0ah,'$' 
    contador_letras db 0 ,0dh,0ah,'$'
    longitud_total db 0   ; Variable para almacenar la longitud total
.code
    main proc
    
        mov ax, @data
        mov ds , ax

        mov ah ,09h
        lea dx , cartel
        int 21h
        
        mov bx ,0 
        mov cx ,0 ;rfegistro contador
    carga_texto:
        mov ah ,01h
        int 21h

        cmp al , 0dh
        je fin_carga_texto
        
        mov texto_a_ingresar[bx] , al  ;guardame lo que el usuario ingrese en texto en lavariable  
        mov texto_modificado[bx] , al 
        inc bx
        inc cx
    jmp carga_texto

    
    
    fin_carga_texto:
    
        mov bx , 0 
 
     
    
    comparar:
        mov al , texto_modificado[bx] 
        cmp al , 24h
        je fin_programa
        cmp al, 'a'
        je cambiar_letra
        cmp al , 's'
        je cambiar_letra

     incrementar:    
        inc bx
    jmp comparar    

    cambiar_letra:
        mov texto_modificado[bx] , '#'
        inc contador_letras
        jmp incrementar


    contar_largo:
        cmp texto_modificado [bx] , 24h


    fin_programa:
        
        
        mov ah ,09h
        lea dx , enters
        int 21h
        

        mov ah, 09h
        lea dx , texto_modificado
        int 21h 

     
        mov ah, 02h
        mov dl, contador_letras ; Cargar el contador de reemplazos
        add dl, 30h               ; Convertir a carácter
        int 21h 

        ; Mostrar longitud total
        mov ah, 02h
        mov dl, cl                      ; Cargar la longitud total
        add dl, 30h               ; Convertir a carácter
        int 21h 
        
        mov ax , 4c00h
        int 21h


    main endp
end    