.data
decodeNull_text: .asciiz "Whenever students program lovely code very late at night, my brain explodes! *sigh sigh sigh*"
decodeNull_buffer: .space 101
.align 2
decodeNull_length: .word 100
decodeNull_pattern: .word 1, 5, 0, 5, 2, 1, 4, 0, 0, 1, 4, 3, 1, -1
decode: .word 1, 2, -1
decodeText: .asciiz "Hello, hello"

.text
.globl main
main: 
	la $t0, decodeNull_pattern #load the array address
	la $t1, decodeNull_text
while:
	lw $t2, 0($t0) #load numbers to $t2
	beq $t2, -1, exit
	#the idea is to reset the count of the register tha tis keeping count of the char as soon as we hit a space 
	#for lower and uppercase we add one and then we branch if its equal to the number we got and print it
	#if its zero we just skip to nearest space 
	#i can use the count 
innerLoop: 
	move $a1, $t2 #holds the number
	move $a0, $t1 #holds address
	jal countChars
	move $t0, $v0 #address of sentence 
printNum:
	#move $a0, $s2
	#li $v0, 1
	#syscall
	addi $t0, $t0, 4
	b while
exit:
	li $v0, 10
	syscall 
	
countChars:
	#Define your code here
	li $t4, 0 #will hold our answer
	move $t5, $a0 #this holds the address string
	move $t6, $a1 #argument of number we want

topCount:
	lb $t7, 0($t5) #load the char at this byte
	beq $t7, 0x20, countCharsExit #branh to exit if space NO NEED FOR THIS
	beq $t7, '\0', countCharsExit #check if we have null termination
	blt $t7, 0x41 , loopBack #check lower bound uppercase
	bgt $t7, 0x7A, loopBack #check upper bound lowercase
	bge $t7, 0x61, addOne #check if its lowercase
	ble $t7, 0x5A, addOne # check if its uppercase
	b loopBack #else we branch here
addOne:
	addi $t4, $t4, 1 #add one to 
	beq $t4, $t6, printCharOut
loopBack:
	addi $t5, $t5, 1 #move one byte
	b topCount
countCharsExit:
	addi $t5, $t5, 1 #move one byte
	move $v0, $t5
	jr $ra
printCharOut: 
	move $a0, $t7
	li $v0, 11
	syscall
	#jal toYUpper
	#move $a0, $v0
	#li $v0, 11
	#syscall
	#addi $t0, $t0, 1 #move one byte
	b topCount
#addToExit:
#	addi $t0, $t0, 1 #move one byte
#	lb $t1, 0($t0) #load the char at this byte
#	beq $t1, '\0', countCharsExit #check if we have null termination
	
toYUpper:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only to allow main program to run without fully implementing the function
	li $v0, '?'
	############################################
#we load the data
	#li $t0, 0x20
	move $t9, $a0 #move the argument to $t1 register, the char

	#beq $t1, 0x20, doneToUpper #branh to exit if space NO NEED FOR THIS
	beq $t9,'\0', doneToUpper #check if its a null
	blt $t9, 0x61, doneToUpper #check if its already uppercase
	bgt $t9, 0x7A, doneToUpper #check upper boundary
	#convert
	xori $t9, $t9, 0x20 #convert to uppercase
doneToUpper:	
	move $v0, $t9 #move result to the $v0 register
	jr $ra
