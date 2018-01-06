#shift test
.text  
.macro print(%reg)
	move $a0, %reg
	li $v0, 35
	syscall 
.end_macro
.macro message(%label)
	la $a0, %label
	li $v0, 4
	syscall
.end_macro
	li $t0, 2  #load 2 into register $t0
	message(first)
	print($t0)
	message(newLine)
	srl $t1, $t0, 1 #shift register $t0, and store in $t1 
	message(first)
	print($t0)
	message(newLine)
	message(second)
	print($t1)
exit:
	li $v0, 10
	syscall
.data
first: .asciiz "First "
second: .asciiz "Second "
newLine: .asciiz "\n"