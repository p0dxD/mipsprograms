.text
.globl main
main: 
#print the message
	li $v0, 4
	la $a0, message
	syscall
	
	li $v0, 5
	syscall
	move $a1, $v0 #move what he entered
	
#actual while loop
while: 
	bgeu $zero, $a1, done
	addi $a1, $a1, -1
	#print the value
	li $v0, 1
	move $a0, $a1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	#prints new line
	b while
done: 
	
.data
message: .asciiz "Enter how many times to print the number: "
newline: .ascii "\n"