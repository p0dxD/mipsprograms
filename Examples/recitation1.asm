.text
.globl main
main:
li $t0, 52
li $t1, 28
and $t3, $t0, $t1
srl $t3,$t3, 2
li $v0, 35
move $a0, $t3
syscall
jal print_nl
#functions 
print_nl:
	li $v0, 4
	la $a0, nl
	syscall
	jr $ra
li $v0, 10
syscall
add:
	move 0($sp), $s0
	move 4($sp), $s1
	addi $sp, $sp, -8 #stack grows down 
	#v0 = s0 + s1
	move $s0, $a0
	move $s1, $a1
	add $v0, $s0, $s1
	
	addi $sp, $sp, 8
	move $s0, 0($sp)
	move $s1, 4($sp)
	jr $ra 