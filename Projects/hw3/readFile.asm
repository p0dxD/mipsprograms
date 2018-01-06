###################################################################
# Homework #2
# name: SALVATORE TERMINE
# sbuid: 109528463
###################################################################
.text

# Open file 
open:
	li $v0, 13       
	la $a0, file
	li $a1, 0       
	li $a2, 0
	syscall           
	move $s6, $v0

# Read file
	li $v0, 14
	move $a0, $s6
	la $a1, 0xffff0000
	li $a2, 1024
	syscall

# Close file 
done:
	li $v0, 16
	move $a0, $s6
	syscall
	
	
.data
file: .asciiz	"/users/p0dxD/Downloads/hw3/checker.map"	
	

