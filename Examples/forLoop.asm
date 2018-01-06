.text
.globl main
main: 
	.macro done
	li $v0, 4 
	la $a0, message
	syscall
	.end_macro
	
	lb $t1, value
	li $t0, 5 #this is the same as i
for:
	#do logic here
	#display message
	li $v0, 4 
	la $a0, message
	syscall
	#display number
	li $v0, 1
	addu $a0,$t1, $zero
	syscall 
	#make the new line
	li $v0, 4
	la $a0, newLine
	syscall
	#subtract from i and come back to top if still more loops left
	addiu $t0, $t0, -1
	addiu $t1, $t1, 1
	bgtz $t0, for
	done
		
.data
value: .byte 10
message: .asciiz "Message number "
newLine: .ascii "\n"
