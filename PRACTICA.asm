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
CMP AL,0DH    ; SE COMPARA CON UN "ENTER" <CR> EN ASCII
JE FINAL      ;SALTA HASTA END

;CONVERTIR DE MAYUSCULA A MINUSCULA
; A-Z 5A=' 41=A
CMP AL, 41H  ; Comparar AL para comprobar que este en
JL NEXT      ; el rango de 'A' a la 'Z'
CMP AL, 5AH
JG MINUSCULA
ADD AL,20H   ; convertir de Mayuscula a minuscula
JMP NEXT
;AL >20H hasta este punto
MINUSCULA:
CMP AL,61H  ; Comparar AL para comprobar que este en
JL NEXT     ; el rango de 'a' a la 'z'
CMP AL,7AH
JG NEXT
SUB AL,20H  ; convertir de minuscula a Mayuscula
JMP NEXT

NEXT:
MOV [SI], AL   ;Guardar caracter en la cadena el codigo ASCII
INC SI
JMP ANOTHER    ;salto  a otro caracter

FINAL:
; IMPRIMIR CADENA
LEA DX, MSG
MOV AH, 9H
INT 21H
MOV AX,4C00H ;FIN DEL PROGRAMA
INT 21H
INT 20H

.STACK

END INICIO
