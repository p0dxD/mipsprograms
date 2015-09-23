#this is for PIr^2
.text
.globl main
main:
	lw $t0, PI
	#ask user to enter radius
	li $v0, 4
	la $a0, message
	syscall
	
	# Get N from user and save
	li	$v0,5		# read_int syscall code = 5
	syscall	
	move	$t1,$v0		# syscall results returned in $v0
	
	#now we calculate
	mult $t1, $t1
	move $t1, $zero
	mflo $t1
	mult $t1, $t0
	mflo $s0
	
	li $t1, 100000
	div $s0, $t1
	mflo $s0
		
	li $v0, 1
	move  $a0, $s0
	syscall
.data
PI: .word 314156
message: .asciiz "Please enter a radius: "