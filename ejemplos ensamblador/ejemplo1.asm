section .data
mensaje1  db "El valor es mayor que 50"
long1 equ $-mensaje1
mensaje2 db "El valor es menor que 50"
long2 equ $-mensaje2
section  .text
	global _start
_start:

   mov ax,50
   mov  bx, 30

   add ax, bx

   cmp ax, 50
   jna else
  mov eax, 4
  mov ebx, 1
  mov ecx, mensaje1
  mov edx, long1
  int 0x80
  jmp salir

else:
	mov eax, 4
	mov ebx, 1
	mov ecx, mensaje2
	mov edx, long2
	int 0x80
salir:
	mov eax, 1
	mov ebx, 0
	int 0x80
