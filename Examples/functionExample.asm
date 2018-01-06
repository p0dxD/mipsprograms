#a--> arguments
#v-->return 
#t--> temp 
#s --> save registers
#this is how to access the stack LOAD AND SAVE
.text
	li $s0, 10
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	li $s0, 2
	lw $s0, 0($sp)
	addi $sp, $sp, 4


exit: 
	li $v0, 10
	syscall
	
	la $s0, message
	move $a0, $t0	
.data 
message: .asciiz ""