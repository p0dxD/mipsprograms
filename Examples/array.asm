.text 
.globl main
main: 
	#we will get the first and last value
	la $s0, array
	#we load one
	lw $a0, 0($s0)
	li $v0, 1
	syscall 
	#we load the last one
	lw $a0, 16($s0)
	li $v0, 1
	syscall 
.data
array:	 .word 1, 2 ,3 , 4 ,5 #like saying int array[] = {};
#this would be to allocate space for it
arraySpace: .space 4096 #(this would be allocating for 1024 integers 4 bytes each a word)