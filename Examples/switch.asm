.data 
.align 2
	jumptable: .word top, case1, case2, case3
	prompt: .asciiz "\n\n Input value from one to three: "
.text
	top: 
		#print the message 
		li $v0, 4
		la $a0, prompt
		syscall
		#read the value
		li $v0, 5
		syscall
		#lets check if the value is less than one
		blez $v0, top
		#now we check if the value is greater than 3
		li $t3, 3
		bgt $v0, $t3, top #if greater than 3 go to top again
		la $a1, jumptable
		sll $t0, $v0, 2 #multiply by 4
		add $t1, $a1, $t0
		lw $t2, 0($t1)
		jr $t2
		
	case1:
		sll $s0, $t0, 1
		b output
	case2:
		sll $s0, $t0, 2
		b output
	case3:
		sll $s0, $t0, 3
	output:
		li $v0, 1
		move $a0, $s0
		syscall
		#here we close the program
		li $v0, 10
		syscall
