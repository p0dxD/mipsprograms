.data
test: .asciiz "123"
testFail: .asciiz "123"
.text

la $a0, test
jal isNumber
#see if it has all numbers
move $a0, $v0
li $v0, 1
syscall
#test for matches
la $a0, test
la $a1, testFail

jal match

move $a0, $v0
li $v0, 1
syscall
exit:
	li $v0, 10
	syscall


isNumber:
	li $v0, 0
	move $t0, $a0
loopIsNumber:
	lb $t1, 0($t0)
	beq $t1, 0x0, exitIsNumber
	blt $t1, 0x30, notANumber
	bgt $t1, 0x39, notANumber
	li $v0, 1
	addi $t0, $t0, 1
	b loopIsNumber
notANumber:
	li $v0, 0
exitIsNumber:
jr $ra

match:
	move $t0, $a0
	move $t1, $a1
	
	lb $t2, 0($t0)
	lb $t3, 0($t1)
	beq $t2, $t3, matches
	li $v0, 0
	b exitMatch
matches:
	li $v0, 1
exitMatch:
	jr $ra
