#this program tells if a number being input is even or odd
.text 
	addi $t2,$zero, 4 #put 4 in the $t2 register
	andi $t3,$t2, 1 #and with one to get the lsm
	beqz $t3, even #jump to even if its 0, continue to odd otherwise and exit
odd: 
	la $a0, isOdd
	li $v0, 4
	syscall
	#exit
	li $v0, 10
	syscall
even: 
	la $a0, isEven
	li $v0, 4
	syscall

	
.data 
isEven: .asciiz "Is even"
isOdd: .asciiz "Is odd"