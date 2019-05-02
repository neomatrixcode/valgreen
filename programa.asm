segment .data
dato4  db "el resultado de variable1+5 es ",0xA,0xD 
londato4 equ $- dato4
dato3  db " ",0xA,0xD 
londato3 equ $- dato3
dato2  db "la variable var vale ",0xA,0xD 
londato2 equ $- dato2
dato1  db "68",0xA,0xD 
londato1 equ $- dato1
t1  db 0
t2  db 3
t3  db 8
t7  db 0
t8  db 6
t4  db 0
t5  db 0
t6  db 0
t9  db 0
t10  db 0
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

mov eax, 4
mov ebx, 0
mov ecx, dato1
mov edx, londato1
int 0x80

mov eax, 4
mov ebx, 0
mov ecx, dato2
mov edx, londato2
int 0x80
mov eax,[t8]
add eax, 48
mov [t8],eax
mov eax, 4
mov ebx, 0
mov ecx, t8
mov edx, 1
int 0x80
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
mov ecx, dato3
mov edx, londato3
int 0x80

mov eax, 4
mov ebx, 0
mov ecx, dato4
mov edx, londato4
int 0x80
mov eax,[t1]
add eax, 48
mov [t1],eax
mov eax, 4
mov ebx, 0
mov ecx, t1
mov edx, 1
int 0x80
salir:
mov eax, 1
mov ebx, 0
int 0x80