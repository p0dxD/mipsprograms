.text
.globl main
main: 
	la $a0, message
	li $v0, 4
	syscall
	
	li $v0, 12
	syscall
	
	move $t0, $v0
exit: 
	li $v0, 10
	syscall
call: 
	li $v0, 12
	syscall
	jal $ra
.data
message: .asciiz "Enter a char: "