##############################################################
# Do NOT modify this file.
# This file is NOT part of your homework 2 submission.
##############################################################

.data
str_input: .asciiz "Input: "
str_result: .asciiz "Result: "

# toUpper
toUpper_header: .asciiz "\n\n********* toUpper *********\n"
toUpper_Hi: .asciiz "Hi"

# countChars
countChars_header: .asciiz "\n\n********* countChars *********\n"
countChars_CSisFun: .asciiz "Computer Science is fun."
countChars_Terminator: .asciiz "I'll be back!!!!!!!!!"

# toLower
toLower_header: .asciiz "\n\n********* toLower *********\n"
toLower_Alphabet: .asciiz "ABCDeFGHIjkLMNoPQRstuvWXyZ"


# decodeNull
decodeNull_header: .asciiz "\n\n********* decodeNull *********\n"
decodeNull_text: .asciiz "Whenever students program lovely code very late at night, my brain explodes! *sigh sigh sigh*"
decodeNull_buffer: .space 101
.align 2
decodeNull_length: .word 100
decodeNull_pattern: .word 1, 5, 0, 5, 2, 1, 4, 0, 0, 1, 4, 3, 1, -1

# genBacon
genBacon_header: .asciiz "\n\n********* genBacon *********\n"
genBacon_plaintext1: .asciiz "Cse220!"
genBacon_buffer1: .space 25
		  .byte '\0'
genBacon_plaintext2: .asciiz "FALL is here."
genBacon_buffer2: .space 100

# hideEncoding
hideEncoding_header: .asciiz "\n\n********* hideEncoding *********\n"
hideEncoding_baconEncoding: .asciiz "BABBAAABAABBABAABABBABBBABABABAABAABBABAABBAAABAAAABBBBBAABABBBBB"
hideEncoding_text: .asciiz "Whenever students program lovely code very late at night, my brain explodes! *sigh sigh sigh*"

# findEncoding
findEncoding_header: .asciiz "\n\n********* findEncoding *********\n"
findEncoding_baconEncoding: .space 101
findEncoding_text: .asciiz "WhENeveR stUDeNts PrOGrAM LoVeLy CodE veRY  lAte At nigHt, my bRAIN ExpLoDES! *SIgh sigh sigh*"


# decodeBacon
decodeBacon_header: .asciiz "\n\n********* decodeBacon *********\n"
decodeBacon_baconEncoding: .asciiz "BABBAAABAABBABAABABBABBBABABABAABAABBABAABBAAABAAAABBBBBAABABBBBBAAAAAAAAAA"
decodeBacon_text: .space 101


# Constants
.eqv QUIT 10
.eqv PRINT_STRING 4
.eqv PRINT_INT 1
.eqv NULL 0x0

.macro print_string(%address)
	li $v0, PRINT_STRING
	la $a0, %address
	syscall 
.end_macro

.macro print_string_reg(%reg)
	li $v0, PRINT_STRING
	la $a0, 0(%reg)
	syscall 
.end_macro

.macro print_newline
	li $v0, 11
	li $a0, '\n'
	syscall 
.end_macro

.macro print_space
	li $v0, 11
	li $a0, ' '
	syscall 
.end_macro

.macro print_int(%register)
	li $v0, 1
	add $a0, $zero, %register
	syscall
.end_macro

.macro print_char_addr(%address)
	li $v0, 11
	lb $a0, %address
	syscall
.end_macro

.macro print_char_reg(%reg)
	li $v0, 11
	move $a0, %reg
	syscall
.end_macro

.text
.globl main
main:
	la $a0, decodeNull_text
	la $a1, decodeNull_buffer
	lw $a2, decodeNull_length
	la $a3, decodeNull_pattern
	
	jal decode
	la $a0, decodeNull_buffer
	li $v0, 4
	syscall 
	li $v0, 10
	syscall	

decode:
	move $t8, $a1 #area what we will use to store the words
	move $s1, $a1
	move $t0, $a0 #contains the address to the string
	move $t1, $a3 #contains the address to the number list
	move $s0, $a2 #size
	
loopNumbers2:
	lw $t2, 0($t1) #load the next word into $t2
	beq $t2, -1, exit #if we have a -1 we exit we are done 
	move $a0, $t0 #the number we go for
	move $a1, $t2 #number we are looking for
	jal countChars2
	move $t0, $v0 #move the new address to where it goes 
	addi $t1, $t1, 4
	j loopNumbers2
#####################################################
countChars2:
	li $t4, 0
	move $t5, $a0 #address of string
	move $t6, $a1 #number we want 
topCount2:
	lb $t3, 0($t5) #load the char at this byte
	beq $t3, 0x20, countCharsExit2#branh to exit if space NO NEED FOR THIS
	beq $t3, '\0', countCharsExit2 #check if we have null termination
	blt $t3, 0x41 , loopBack2 #check lower bound uppercase
	bgt $t3, 0x7A, loopBack2 #check upper bound lowercase
	bge $t3, 0x61, addOne2 #check if its lowercase
	ble $t3, 0x5A, addOne2 # check if its uppercase
	b loopBack2 #else we branch here
addOne2:
	addi $t4, $t4, 1 #add one to 
	beq $t4, $t6, printCharOut2
loopBack2:
	addi $t5, $t5, 1 #move one byte
	b topCount2
countCharsExit2:
	addi $t5, $t5, 1 #move one byte
	move $v0, $t5
	jr $ra
printCharOut2: 
	##add to the stack 
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	move $a0, $t3
	jal toUpper
	##get stack to normal
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	move $t3, $v0
	sb $t3, 0($t8)
	addi $t8, $t8, 1
	#move $a0, $t3
	#li $v0, 11
	#syscall
	#cut to next space
	b loopBack2
	
exit:
	li $t3, '\0'
	sb $t3, 0($t8)
	addi $t8, $t8, 1
	jr $ra
toUpper:
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
