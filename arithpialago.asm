section .data
	msg1 db 'Enter first number: ', 0
	len1 equ $ - msg1
	msg2 db 'Enter second number: ', 0
	len2 equ $ - msg2
	msg3 db 'Choose operation (+, -, *, /): ', 0
	len3 equ $ - msg3
	msg4 db 'Result: ', 0
	len4 equ $ - msg4
	newline db 10, 0
	len_nl equ $ - newline

section .bss
	num1 resb 10
	num2 resb 10
	op resb 2
	result resb 10

section .text
	global _start

_start:
	; Print prompt for the first number
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, len1
	int 0x80

	; Read the first number
	mov eax, 3
	mov ebx, 0
	mov ecx, num1
	mov edx, 10
	int 0x80

	; Print prompt for the second number
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, len2
	int 0x80

	; Read second number
	mov eax, 3
	mov ebx, 0
	mov ecx, num2
	mov edx, 10
	int 0x80

	; Print the operation prompt
	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, len3
	int 0x80

	; Read the operation
	mov eax, 3
	mov ebx, 0
	mov ecx, op
	mov edx, 2
	int 0x80

	; Convert ASCII numbers to integers
	mov eax, num1
	call atoi
	push eax	; Store the first number on stack

	mov eax, num2
	call atoi
	mov ebx, eax	; Restore the first number to eax

	; Determine which operation to perform
	mov cl, [op]
	cmp cl, '+'
	je addition
	cmp cl, '-'
	je subtraction
	cmp cl, '*'
	je multiplication
	cmp cl, '/'
	je division
	jmp exit	; Invalid operation

addition:
	add eax, ebx
	jmp print_result

subtraction:
	sub eax, ebx
	jmp print_result

multiplication:
	imul eax, ebx
	jmp print_result

division:
	xor edx, edx	; Clear edx for division
	idiv ebx	; eax = eax / ebx, edx is remainder
	jmp print_result

print_result:
	; Convert result to ASCII
	mov edi, result
	call itoa

	; Print "Result: " message
	mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, len4
	int 0x80

	; Print the result
	mov eax, 4
	mov ebx, 1
	mov ecx, result
	mov edx, 10
	int 0x80

	; Print the newline
	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, len_nl
	int 0x80

exit:
	mov eax, 1
	xor ebx, ebx
	int 0x80

atoi:
	xor ebx, ebx	; clear ebx

.next_digit:
	movzx ecx, byte [eax]
	inc eax
	cmp ecx, '0'
	jb .done
	cmp ecx, '9'
	ja .done

	; Multiply current result by 10
	mov edx, 10
	imul ebx, edx

	; Convert from ASCII to digit and add to result
	sub ecx, '0'
	add ebx, ecx
	jmp .next_digit

.done:
	mov eax, ebx	; return value in eax
	ret

itoa:
	mov ebx, 10	; divisor
	xor ecx, ecx	; counter for digits

.divide_loop:
	xor edx, edx	; clear upper part of dividend
	div ebx		; eax is quotient, edx is remainder
	add dl, '0'	; convert remainder to ASCII
	push edx	; store on stack
	inc ecx		; increment digit counter
	test eax, eax	; check if quotient is zero
	jnz .divide_loop

.reverse_loop:
	pop eax		; get digit from stack
	mov [edi], al	; store in buffer
	inc edi		; move to next position
	loop .reverse_loop

	mov byte [edi], 0
	ret
