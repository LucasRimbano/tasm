.8086
.model small
.stack 100h

.data
    dirIpF db 178,45,20,3
    dirIp db 192,168,2,5
    masc db 255,255,255,0
    red db 192,168,2 
    pasoAlgo db "hoo salto la mascara 1",0dh,0ah,'$'


.code

    main proc
     
        mov ax , @data
        mov ds , ax 
        lea bx , dirIp
        lea si, masc
        lea di , red

        mov al , byte ptr [bx]
        mov ah , byte ptr [si]
        and al , ah
        cmp al , byte ptr [di]
        je noPasaNada
        mov al , 1  ;si pasa algo mueve al y salta la funcion y no pisa el valro con cero
        jmp finalFuncion
        mov ah, 09h
        lea dx,  paso
        int 21h 

   

    noPasaNada:
        mov al ,0   


    finalFuncion:
        mov ax , 4c00h
        int 21h

    main endp
end    