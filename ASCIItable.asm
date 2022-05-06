;--------------------------------------------------NOTAS--------------------------------------------------
;CH = contador filas                                                                                     |
;DH = control filas                                                                                      |
;DL = columnas                                                                                           |
;                                                                                                        |
;PARA msg DB '00:?', 0 --> msg[0] = 1er DIGITO DE LA CADENA                                              |
;                      --> msg[1] = 2do DIGITO DE LA CADENA                                              |
;                      --> msg[2] = 3er DIGITO DE LA CADENA (LOS ":", POR ESO NO APARECE EN EL CODIGO)   |
;                      --> msg[3] = 4to DIGITO DE LA CADENA                                              |
;---------------------------------------------------------------------------------------------------------

MOV BL, 00H    ;CONTADOR DEL VALOR ASCII A IMPRIMIR
               ;INICIALMENTE BL=0H PARA EL CASO DEL PRIMER LOOP, PARA QUE SI O SI EMPIECE EN LA POSICION QUE 
               ;CORRESPONDE (PARA EL PRIMER CONTADOR DE COLUMNAS)
               
MOV BH, 00H    ;aaaaaaaaaaaaaaaa
MOV CX, 00FFH  ;ES EL CONTADOR MAX. AL QUE SE PUEDE LLEGAR EN EL LOOP

MOV DL, 0      ;aaaaa ESTABLECER LA POSICION DEL CURSOR

OTRO:            ;(?)
    CMP BL, 0H 
    JE CONTINUE  ;IF BL=0 -> NO CAMBIA DE ESTAA MADRE ESTA MAL
                 
    MOV AH, 00H  ;(?)
    MOV AL, BL
    PUSH CX      ;SE GUARDA CH Y CL
                 ;PUSH ALMACENA UN VALOR DE 16 BITS EN LA PILA
    
    MOV CH, 24   ;(24=18H) CH=18H PORQUE...???? 
    DIV CH 
    POP CX       ;GUARDA CH Y CL
    CMP AH, 0    ;???? ALCH NO SE WE
    
    JNE CONTINUE ;SALTA SI QUIEN != CUAL OTRO ?????
    ADD DL, 6    ; ???
    
    MOV CH, 0    ;REINICIA EN 0 EL CONTADOR DE FILAS
    MOV DH, 0    ;REINICIA EN 0 EL CONTADOR DE FILAS ????????
    JMP PRINTING ;SALTO INCONDICIONAL A PRINTING
    
CONTINUE:
    ;ESTABLECER LA POSICION ACTUAL DEL CURSOR (??????)
    MOV DH, CH   ;CONTADOR DE FILAS = CONTADOR ASCII
    
PRINTING:
    INC CH       ;ALGO DE LA SIGUIENTE FILA ?????
    PUSH BX      ;SE GUARDA BH Y BL (???????)
    MOV BH, 0H   ;ALGO DE LA PAGINA #0-7 (???????)
    MOV AH, 2H   ;PONER EL CURSOR EN LA POSICION ADECUADA
    INT 10H
    
    POP BX       ;????
    
    MOV AL, BL   ;PA K?????
    PUSH AX      ;SE GUARDA AH Y AL (????)
    SHR AL, 4    ;DESPLACE TODOS LOS BITS A LA DERECHA 4 VECES, EL BIT QUE SE APAGA SE ESTABLECE EN CF QUEMASPONGO?????
    
    ;PARTE QUE CONVIERTE EL 1er NIBLE DE HEX --> ASCII 
    CMP AL, 09H   ;PARA IDENTIFICAR SI EL CONTADOR HEXADECIMAL VA A EMPEZAR A USAR LETRAS EN EL CONTADOR
    JG SALTAR     ;SALTO CORTO SI EL 1er OPERANDO ES MAYOR QUE EL 2do OPERANDO (SEGUN LO ESTABLECIDO POR 
                  ;LA INSTRUCCION CMP)
    ADD AL, 30H   ;ESTO PA K ERA NO ME ACUERDO??? XD
    JMP CONTINUAR
    
SALTAR:
    ADD AL, 37H   ;ESTO PA K ERA NO ME ACUERDO??? XD
    
CONTINUAR:
 
    ;======ALMACENA MSG[0] ---- CARGAR DIRECCION DE "MSG" A SI
    
    LEA SI, MSG   ;CARGA LA DIRECCION EFECTIVA DE MSG (???)
    
    MOV [SI], AL
    
    ;=======
    
    POP AX          ;aaaaaaaa
    AND AL, 0FH     ;HACE UNA OPERACION AND ENTRE LOS BITS DEeeeee Y DEeeeeeee PARA...??
    
    CMP AL, 09H     ;
    JG SALTAR2      ;a
    ADD AL, 30H     ;
    JMP CONTINUAR2  ;
    
SALTAR2:
    ADD AL, 37H     ;PQ???
    
CONTINUAR2:                                                   

    ;======ALMACENA msg[1] ---- CARGAR DIRECCION DE msg A SI
    MOV [SI+1], AL
    ;======
    
    ;======ALMACENA msg[3] ---- CARGAR DIRECCION DE msg A SI
    MOV [SI+3], BL
    ;====== 
    
    ;===== IMPRIMIR msg ====
    CALL PRINT
    ;=====
    
    CMP BL, 255     ;PARA CHECAR SI YA LLEGO AL ULTIMO VALOR ASCII POR IMPRIMIR
    JE ENDF         ;EN CASO DE QUE SE SEA CIERTO, SE ACABA EL PROGRAMA
    INC BL          ;SI NO, SE HACE BL++
    
    LOOP OTRO       ;LOOP DISMINUYE CX, SALTA A LA ETIQUETA SI CX NO ES CERO
    
ENDF:
    INT 20          ;FIN uwu
    
;===== APARTADO PARA LOS PROCEDIMIENTOS =====

PRINT PROC
    ;GUARDAR VARIABLES
    PUSH AX
    
NEXT_CHAR: 

    CMP b.[SI],0    ;CHECA SI SE LLEGO AL 0 QUE MARCA QUE...
    JE STOP
    MOV AL, [SI]    ;XD?????
    MOV AH, 0EH     ;???????
    INT 10H         ;INTERRUPCION 10H
    
    ADD SI,1        ;ARRAY[n+1]
    JMP NEXT_CHAR   ;HACE QUE SE HAGA UNA ESPECIE DE LOOP ????

STOP:
    POP AX
    RET             ;RETORNA A LA SIG. INSTRUCCION
    PRINT ENDP      ;???? ESTO K ES? xd

;===== APARTADO PARA LAS VARIABLES =====

msg DB '00:?', 0