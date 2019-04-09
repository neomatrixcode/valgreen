section .data
f db "0"

section  .text
	global _start
_start:

   mov ax, 3
   mov bx, 1
   mov cx, 1
   mov dx, 0

while:
   mov bp, bx
   add bp, cx
   mov bx,cx
   mov cx, bp
   add dx,1
    cmp dx, ax

    jbe while

    add bp, 48
    mov [f], bp

	mov eax, 4
	mov ebx, 1
	mov ecx, f
	mov edx, 1
	int 0x80




salir:
	mov eax, 1
	mov ebx, 0
	int 0x80
