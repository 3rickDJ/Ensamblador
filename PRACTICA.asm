;name "mycode"  output file name (max 8 chars for DOS compatibility)
.MODEL SMALL


ORG 100h ;Directiva para definir dónde inicia el código máquina
.DATA
msg DB 100 DUP('$') ;definir un arreglo de bytes de longitud 100 con el carácter '$'

.CODE ;INCIO EL CODIGO DEL PROGRAMA
INICIO:
MOV AX,@DATA  ;DIRECCIONA EL
MOV DS, AX    ;SEGMENTO DE DATO
LEA SI, MSG   ;CARGAR DIRECCIÓN DE MSG A SI

ANOTHER:
MOV AH,1
INT 21H
CMP AL,0DH    ; SE COMPARA CON UN "ENTER" EN ASCII
JE FINAL      ;SALTA HASTA END

;CONVERTIR DE MAYUSCULA A MINUSCULA
; A-Z 5A=Z 41=A
CMP AL, 41H  ; Comparar AL para comprobar que este en
JL NEXT      ; el rango de 'A' a la 'Z'
CMP AL, 5AH
JG MINUSCULA
ADD AL,20H   ; convertir de Mayuscula a minuscula
JMP NEXT

MINUSCULA:
CMP AL,61H
JL NEXT
CMP AL,7AH
JG NEXT
SUB AL,20H
JMP NEXT

NEXT:          ;Guardar en la cadena el codigo ASCII
MOV [SI], AL   ;MOV 1ST DIGIT TO msg[0]
INC SI
JMP ANOTHER    ;SALTO INCONDICIONAL

FINAL:
; IMPRIMIR CADENA
MOV AL,'$'   ;AGREGAMOS EL INDICADOR DEL FINAL DE UNA CADENA
MOV [SI],AL  ;FIN DE LA CADENA
LEA DX, MSG
MOV AH, 9H
INT 21H
MOV AX,4C00H ;FIN DEL PROGRAMA
INT 21H
INT 20H

.STACK

END INICIO
