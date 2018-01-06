.text
.globl main
main: 
	#we load the data
	lb $t0, num
	la $t1, test

##loop
while: 
	lb $t2, 0($t1) #load the char
	beq $t2, 0x20, done #branh to exit if space NO NEED FOR THIS
	beq $t2,'\0', done
	blt $t2, 0x61, writeChar
	bgt $t2, 0x7A, writeChar
	#convert
	xor $t2, $t0, $t2
	#print char
writeChar:
	move $a0, $t2
	li $v0, 11
	syscall
	#prints new line
	addi $t1,$t1,1
	b while
done: 
	#exit the app
	li $v0, 10
	syscall
.data
num: .byte 32 #num to check with
test: .asciiz "ABCDeFGHIjkLMNoPQRstuvWXyZ"
