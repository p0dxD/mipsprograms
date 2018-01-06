.text
.globl main
main:
	lw $t0, x #load word at adress of x into temp register $t0
	lw $t1, A
	lw $t2, B
	lw $t3, C
	
	mul $t4, $t0, $t0 #$t4 = x^2
	mul $t5, $t4, $t1 #t5 = A*x^2
	mul $t2, $t2, $t0 #$t2 = B*x
	add $t0 , $t5, $t2 #A*x^2 + B*x
	add $t0, $t0, $t3 #$$t0 = A*x^2 + B*x + C
	
	la $a0 , ans #load address in arg reg $a0
	li $v0, 4 #load immediate of 4 into $v0
	syscall 
	
	move $a0, $t0 
	li $v0, 1
	syscall
	#sw $t3, C
.data
x: .word 7 #two's compliment 
A: .word 3
B: .word 4
C: .word 5
ans: .asciiz "Answer: " #\0
endl: .ascii "\n"