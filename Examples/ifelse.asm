.text
.globl main
main: 
#ask for a number
	li $v0, 4
	la $a0, message
	syscall
#get the number 
	li $v0, 5
	syscall
	move $t1, $v0
#check if the number is less or greater than 10
	lb $t2, number
	beq $t1, 10, same
	bge $t1, $t2, else
	li $v0, 4
	la $a0, messageIf
	syscall
	b continue
else:
	li $v0, 4
	la $a0, messageElse
	syscall
	b continue
same: 
	li $v0, 4
	la $a0, messageSame
	syscall
continue: 
.data
number: .byte 10
message: .asciiz "Enter a number: "
messageIf: .asciiz "number is less than 10"
messageSame: .asciiz "Number is 10 "
messageElse: .asciiz "number is greater than 10"