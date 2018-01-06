.text
j main
#####################################################
#int sum(int arr[], int size){
#if(size==0) return 0;
#else return sum(arr, size-1)+arr[size-1];
#####################################################
sum:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	beqz $a1, base
	addi $a1, $a1, -1
	jal sum
	sll $a1, $a1, 2
	add $t0, $a0, $a1
	lw $t0, 0($t0)
	add $v0, $t0, $v0
	j exit
base:
	li $v0, 0
exit:
	lw $a1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
jr $ra
######################################################
main:
	la $a0, numbers
	lw $a1, size
	jal sum
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
.data
numbers: .word 1, 2, 3, 4
size: .word 4