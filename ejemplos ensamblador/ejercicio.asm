section .data
resultado db "0"

section  .text
	global _start
_start:

   mov ax, 6

mov ecx, 3

for:
 mov si , ax
mov edi, ecx
        
add ax, 48
mov [resultado], ax

	mov eax, 4
	mov ebx, 1
	mov ecx, resultado
	mov edx, 1
	int 0x80
mov  ax,  si
mov  ecx, edi
add  ax, 1
loop for



salir:
	mov eax, 1
	mov ebx, 0
	int 0x80
