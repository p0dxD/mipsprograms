
.data
# genBacon
genBacon_header: .asciiz "\n\n********* genBacon *********\n"
genBacon_plaintext1: .asciiz "cse220!"
genBacon_buffer1: .space 25
		  .byte '\0'
.text 
.globl main
main: 
	la $t0, genBacon_plaintext1
	la $t1, genBacon_buffer1
loopMain:
	lb $t3, 0($t0) 
	beq $t3, 0x0, endLoopMain
	
	##check if its a letter to being with
	addi $sp, $sp, -12
	sw $t3, 0($sp) #oad char to stack
	sw $t1, 4($sp) #oad char to stack
	sw $t0, 8($sp) #oad char to stack
	move $a0, $t3  #arg
	jal isCharLetter #check f its letter
	beqz $v0, noSequenceChar
	lw $t0, 8($sp) #oad char to stack
	lw $t1, 4($sp) #oad char to stack
	lw $a0, 0($sp) #load value back as argument
	addi $sp, $sp, 12

	move $a1, $t1
	li $a2, '('
	li $a3, 'p'
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal storeSequence
	lw $t0, 0($sp)
	move $t1, $v0
	addi $sp, $sp, 4
	b nextLoopItem
noSequenceChar:
	lw $t0, 8($sp) #oad char to stack
	lw $t1, 4($sp) #oad char to stack
	lw $a0, 0($sp) #load value back as argument
	addi $sp, $sp, 12
nextLoopItem:
	addi $t0, $t0, 1
	b loopMain
	#print
endLoopMain:
	li $a0, 'p'
	move $a1, $t1
	jal endMessage
	la $a0, genBacon_buffer1
	li $v0, 4
	syscall 
	
#test isChar
	li $a0, '0'
	jal isCharLetter
	move $a0, $v0
	li $v0, 1
	syscall
exit: 
	li $v0, 10
	syscall
##############################################################################
# endMessage method, simply adds to buffer 5 letters depending on entrance 
# takes two parameters the char and buffer address
# returns the pointer to buffer
##############################################################################
endMessage: 
	move $t0, $a0 #contains the char
	move $t1, $a1 #contains the buffer address
	li $t2, 5 #counter
loopEndMessage:
	beqz $t2, endMessageExit
	sb $t0, 0($t1)
	addi $t1, $t1, 1
	addi $t2, $t2, -1
	b loopEndMessage
endMessageExit:
	move $v0, $t1
	jr $ra
	
##########################################################################
#
# END endMessage
#
##########################################################################

##############################################################################
# Method takes 4 param 
# (char a, pointer address, char 1 enconding, char 2 encoding)
# returns the pointer of the buffer
#
##############################################################################
#27(apostrofe), 2C(coma), 21(admiracion), 20(space) 2E (dot)
storeSequence:
	move $t0, $a0 #get the char and store it 
	move $t1, $a1 #store the pointer of buffer
	move $t2, $a2 #first enconding letter
	move $t3, $a3  #second enconding letter
	li $t5, 0x10 #value we will use later to check bits
	
	beq $t0, 0x27, apostropeSequence # if its this symbol we do it manually 
	beq $t0, 0x2e, dotSequence # if its this symbol we do it manually 
	beq $t0, 0x20, spaceSequence # if its this symbol we do it manually 
	beq $t0, 0x21, admirationSequence # if its this symbol we do it manually 
	beq $t0, 0x2c, commaSequence # if its this symbol we do it manually 
	
	andi $t0, $t0, 0x1F #and to get the last 5 bits
	addi $t0, $t0, -1 #sub to get into 0 format starting from a
	##after this we have the correct value
	xori $t0, $t0, 0x1F #flip the bits like in one compliment
	b loopSequenceStore
apostropeSequence: 
	li $t0, 3
	b loopSequenceStore
dotSequence:
	li $t0, 1
	b loopSequenceStore 
admirationSequence:
	li $t0, 4
	b loopSequenceStore
commaSequence:
	li $t0, 2
	b loopSequenceStore
spaceSequence:
 	li $t0,5
loopSequenceStore:	
	beqz $t5, doneLoopSequenceStore
	and $t4, $t0, $t5 #we check first  
	beqz $t4, storeFirst #if its 0 we store second char else first
	sb $t2, 0($t1) #store first char
	b continueFirst
storeFirst:
	sb $t3, 0($t1) #store second char
continueFirst:
	addi $t1, $t1, 1 #add one to the pointer of buffer
	srl $t5, $t5, 1 # we shit value in t5 one to check next bit
	b loopSequenceStore
doneLoopSequenceStore:
	move $v0, $t1
	jr $ra 
##########################################################################
#
# END storeSequence
#
##########################################################################

##############################################################################
#isCharLetter
#parms, (char a) 
#return true or false if it is a char letter
##############################################################################
isCharLetter:
	move $t0, $a0 #this holds the char

	beq $t0, '\0', notLetterChar #check if we have null termination
	beq $t0,0x2c ,letterChar
	beq $t0,0x21 ,letterChar
	beq $t0,0x20 ,letterChar
	beq $t0,0x2e ,letterChar
	beq $t0,0x27 ,letterChar
	blt $t0, 0x41 , notLetterChar #check lower bound uppercase
	bgt $t0, 0x7A, notLetterChar #check upper bound lowercase
	bge $t0, 0x61, letterChar #check if its lowercase
	ble $t0, 0x5A, letterChar # check if its uppercase
	#27(apostrofe), 2C(coma), 41(admiracion), 20(space) 2E (dot)
letterChar:
	li $v0, 1 #return one if it is
	b isCharLetterExit
notLetterChar:
	li $v0, 0 #return zero if its not
isCharLetterExit:
	jr $ra
##############################################################################
#end countChars
##############################################################################
