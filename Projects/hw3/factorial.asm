#int Factorial(int n) { 
#  if (n == 0) return 1;           // Simple case: 0! = 1 
#  return (n * Factorial(n - 1));  // General function: n! = n * (n - 1)! 
.text
main:
	li $a0, 4
	jal factorial
	
	move $a0, $v0
	li $v0, 1
	syscall 
exit:
	li $v0, 10
	syscall
############################################################	
factorial:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	beq $a0, 1, base #check with the base case
	addi $a0, $a0, -1 #put it back in a0
	jal factorial 
	mul $t0, $a0, $v0
	add $v0, $v0, $t0
	j exitFactorial
base:
	li $v0, 1
exitFactorial:
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
jr $ra
############################################################
.data
