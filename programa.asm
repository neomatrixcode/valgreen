segment .data
t1  db 0
lont1 equ $ -t1
t2  db 3
lont2 equ $ -t2
t3  db 8
lont3 equ $ -t3
t7  db 0
lont7 equ $ -t7
t8  db 6
lont8 equ $ -t8
t4  db 0
lont4 equ $ -t4
t5  db 0
lont5 equ $ -t5
t6  db 0
lont6 equ $ -t6
t9  db 0
lont9 equ $ -t9
t10  db 0
lont10 equ $ -t10
dato1  db "el resultado de variable1+5 es " 
londato1 equ $ -dato1
segment .text
global _start
_start:
    mov eax,3 
    mov [t1],eax

    mov eax,[t1] 
    mov [t2],eax

    mov eax,8 
    mov [t3],eax

    mov eax,[t1] 
    mov [t4],eax

  mov eax,[t4] 
  add eax, 1  
  mov [t5],eax
  mov eax,[t5] 
  add eax, 9  
  mov [t6],eax

    mov eax,[t6] 
    mov [t7],eax

    mov eax,6 
    mov [t8],eax
    mov eax,2 
    mov [t1],eax

    mov eax,[t1] 
    mov [t9],eax

  mov eax,[t9] 
  add eax, 5  
  mov [t10],eax

    mov eax,[t10] 
    mov [t1],eax


mov eax, 4
mov ebx, 0
mov ecx, dato1
mov edx, londato1
int 80h
mov eax,[t1]
add eax, 48
mov [t1],eax
mov eax, 4
mov ebx, 0
mov ecx, t1
mov edx, lont1
int 80h
salir:
mov eax, 1
mov ebx, 0
int 0x80