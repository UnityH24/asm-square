// square of one-digit number
.text
	.globl _start
_start:
	// prompt user
	mov x8, #64
	mov x0, #1
	ldr x1, =q
	ldr x2, =qlen
	svc #0

	// read digit
	mov x8, #63
	mov x0, #0
	ldr x1, =digit
	mov x2, #1
	svc #0

	// calculate the square
	ldr x6, =digit
	ldr x6, [x6] // x6 = the character value of input 
	cmp x6, #48
	blo exception
	cmp x6, #57
	bhi exception

	sub x6, x6, '0' // x6 = numerical value of x6
	mul x6, x6, x6 // x6 = x6 * x6 (x6 ** 2)

	// print first part of ans
	mov x8, #64
	mov x0, #1
	ldr x1, =ans0
	ldr x2, =ans0len
	svc #0

	// print the original input digit
	mov x0, #1
	ldr x1, =digit
	mov x2, #1
	svc #0

	// second part of ans
	mov x0, #1
	ldr x1, =ans1
	ldr x2, =ans1len
	svc #0

	mov x1, #19 // x1 is byte offset (dont ask)
	mov x2, #10 // for division

loop:	
	// decrement byte offset by 1
	sub x1, x1, #1
	// get the module by 10
	udiv x3, x6, x2
	mul x3, x3, x2
	sub x4, x6, x3
	udiv x6, x6, x2

	// getting char val
	add x4, x4, #'0'

	// writing it to address + byte offset
	ldr x5, =result
	add x5, x5, x1
	sturb w4, [x5]
	cmp x6, #0
	bne loop // jumping back if needed

	// printing the result
	mov x0, #1
	ldr x1, =result
	mov x2, #20 // do. not. ask
	mov x8, #64
	svc #0

	mov x0, #0
exit:
	mov x8, #93
	svc #0

exception:
	// print out the err
	mov x0, #1
	ldr x1, =err
	ldr x2, =errlen
	mov x8, #64
	svc #0

	// go to start
	b _start

.data
err:
	.ascii "Please enter a valid digit\n"
.equ errlen, .-err
q:
	.ascii "Enter a digit (0-9)\n"
.equ qlen, .-q

ans0:
	.ascii "The square of "
.equ ans0len, .-ans0

ans1:
	.ascii " is: "
.equ ans1len, .-ans1
digit:
	.byte 0
result:
	.zero 19 // don't ask i have no idea either
	.byte 10 // newline char at the end

