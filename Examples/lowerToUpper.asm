.text
.globl main
main: 
	#we load the data
	lb $t0, num
	lb $t1, test
	
	#We print out what we have
	move $a0, $t1 
	li $v0, 11
	syscall
	#here we convert 
	xor $t3, $t0, $t1
	move $a0, $t3
	li $v0, 11
	syscall
	#exit the app
	li $v0, 10
	syscall
.data
num: .byte 32
test: .byte 66