.text
.globl main
main:
	li $t0, 1
	li $t1, 2
	li $t2, 3
	
	addi $sp, $sp, -8
	sw $t0, 0($sp)#1
	sw $t1, 4($sp)#2
	
	addi $sp, $sp, -4
	sw $t2, 0($sp)#3
	
	lw $t3, 0($sp)
	lw $t4, 4($sp)
	lw $t5, 8($sp)
	addi $sp, $sp, 12
	move $a0, $t3
	li $v0, 1
	syscall
		move $a0, $t4
	li $v0, 1
	syscall
			move $a0, $t5
	li $v0, 1
	syscall