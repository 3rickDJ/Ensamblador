;--------------------------------------------------NOTAS--------------------------------------------------
;                                                                                                        |
;PARA msg DB '00:?', 0 --> msg[0] = 1er DIGITO DE LA CADENA                                              |
;                      --> msg[1] = 2do DIGITO DE LA CADENA                                              |
;                      --> msg[2] = 3er DIGITO DE LA CADENA (LOS ":", POR ESO NO APARECE EN EL CODIGO)   |
;                      --> msg[3] = 4to DIGITO DE LA CADENA                                              |
;---------------------------------------------------------------------------------------------------------

MOV BL, 00H      ; Contador ascii
MOV DL, 0        ; Contador columnas |  Inicio=0
MOV DH, 0        ; Contador de filas |  Inicio=0

JMP PRINTING  ; Si es el primer caracter, no mover la columna

OTRO:            ; ciclo para imprimir otro caracter

    MOV AH, 00H  ; para dividir AX/ CH

    MOV AL, BL   ; dividir BL/24 para ver si el caracter BL es multiplo de 24, si es multiplo de 24, cambiar de columna y empezar en fila 0

    MOV CH, 24   ; AL = AX/CH   y el resto va a quedar en AH. Si AH es 0, saltar a la siguiente columna
    DIV CH
    CMP AH, 0

    JNE PRINTING ; Si AH no es 0, BL no es multiplo de 24. Seguir imprimiendo en la misma columna
    ADD DL, 6    ; Sumar 6, para cambiar la posición del cursor 6 espacios a la derecha

    MOV DH, 0    ; Poner la posición de la fila en la primera ó 0 (la primera linea)

PRINTING:
    MOV BH, 0H   ; Establecer la página en la que queremos establecer nuestro cursor
    MOV AH, 2H   ; PONER EL CURSOR EN LA POSICION ADECUADA. DL:=columnas, DH:= filas, BH:= página
    INT 10H

    INC DH       ; Incrementar en 1 la posición de la fila <=> imprimir en la siguiente fila

                 ; obtener el numero en hexadecimal y prepararlo para imprimirlo como caracteres ========================================================
                 ; Obtener los dígitos en hexadecimal del caracter ASCII en cuestión
                 ; Tenemos el número en binario del caracter BL
                 ; # Convertir de binario a hexadecimal
                 ; 1. Dividimos el número binario en 2 nibles (1nible=4bits)
                 ; 2. Aislamos  el  nible. ( El nible toma un valor del 0 a la F)
                 ; 4. Tratamos el nible de forma que tome su correspondiente valor dentro de la tabla ASCII para poder
                 ; representar un número del 0-F e jmprimirlo como un caracter en pantalla.

    MOV AL, BL   ; 1st Nible (aislar el primer nible)
    SHR AL, 4    ; DESPLACE TODOS LOS BITS A LA DERECHA 4 VECES. Obtenemos el dígito de la ´izquierda´
                 ; Es un número del 0-9 --> sumar 30H para ser un número en la tabla ascii
    CMP AL, 09H
    JG SALTAR

    ADD AL, 30H
    JMP CONTINUAR

SALTAR:
                 ; Es un número del A-F --> sumar 37H para ser una letra (mayúscula)  en la tabla ascii
    ADD AL, 37H

CONTINUAR:

                 ; ======ALMACENA MSG[0] ---- CARGAR DIRECCION DE "MSG" A SI

    LEA SI, MSG   ;CARGA LA DIRECCION EFECTIVA DE MSG

    MOV [SI], AL ; cargar primer digito al primer elemento de la cadena msg


    MOV AL,BL    ; VAMOS CON EL SEGUNDO NIBLE
    AND AL, 0FH  ; Aplicamos la operación AND entre BL y 00001111, para aislar el segundo nible
    CMP AL, 09H  ; Es un número del 0-9 --> sumar 30H para ser un número en la tabla ascii
    JG SALTAR2
    ADD AL, 30H
    JMP CONTINUAR2

SALTAR2:
                 ; Es un número del A-F --> sumar 37H para ser una letra (mayúscula)  en la tabla ascii
    ADD AL, 37H
CONTINUAR2:

                 ; ======ALMACENA msg[1] ---- CARGAR DIRECCION DE msg A SI
    MOV [SI+1], AL
                 ; ================================================================================================================================

                 ; ======ALMACENA msg[3] ---- CARGAR DIRECCION DE msg A SI
    MOV [SI+3], BL

                 ; ===== IMPRIMIR msg ==========================================================================================
    NEXT_CHAR:

    CMP b.[SI],0 ; El byte en la posición SI del arreglo msg es 0?
    JE STOP      ; Parar
    MOV AL, [SI] ; Mover el elemento SI a AL para imprimirlo
    MOV AH, 0EH  ; Servicio  0EH de la INTERRUPCION 10H
    INT 10H      ; INTERRUPCION 10H

    ADD SI,1     ; Sumar 1 a SI para avanzar al siguiente elemento en el arreglo msg
    JMP NEXT_CHAR
    STOP:
                 ; =============================================================================================================

    CMP BL, 255  ; Si ya imprimimos todos los caracteres ascii, terminamos el programa
    JE ENDF
    INC BL       ; Si aún no acabamos, le sumamos 1 a BL, para imprimir el siguiente caracter

    JMP OTRO

ENDF:
    INT 20H

                 ; ===== APARTADO PARA LAS VARIABLES =====

msg DB '00:?', 0
