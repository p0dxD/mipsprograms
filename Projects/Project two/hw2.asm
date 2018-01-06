##############################################################
# Homework #2
# name: Jose Rodriguez
# sbuid: 107927299
##############################################################
.text

##############################
# EASY HELPER FUNCTIONS 
# Suggestion: Do these first
##############################
##############################################################################
#toUpper
#params, char a
# returns the char in upper case
##############################################################################
toUpper:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only to allow main program to run without fully implementing the function
	li $v0, '?'
	############################################
#we load the data
	#li $t0, 0x20
	move $t1, $a0 #move the argument to $t1 register, the char

	#beq $t1, 0x20, doneToUpper #branh to exit if space NO NEED FOR THIS
	beq $t1,'\0', doneToUpper #check if its a null
	blt $t1, 0x61, doneToUpper #check if its already uppercase
	bgt $t1, 0x7A, doneToUpper #check upper boundary
	#convert
	xori $t1, $t1, 0x20 #convert to uppercase
doneToUpper:	
	move $v0, $t1 #move result to the $v0 register
	jr $ra
##############################################################################
#helper method for decode null
##############################################################################

##############################################################################
#countChars 
#params char[] string
#returns the number of chars letters
##############################################################################
countChars:
	#Define your code here
	li $t2, 0 #will hold our answer
	move $t0, $a0 #this holds the address
topCount:
	lb $t1, 0($t0) #load the char at this byte
	beq $t1, '\0', countCharsExit #check if we have null termination
	blt $t1, 0x41 , loopBack #check lower bound uppercase
	bgt $t1, 0x7A, loopBack #check upper bound lowercase
	bge $t1, 0x61, addOne #check if its lowercase
	ble $t1, 0x5A, addOne # check if its uppercase
	b loopBack #else we branch here
addOne:
	addi $t2, $t2, 1 #add one to 
loopBack:
	addi $t0, $t0, 1 #move one byte
	b topCount
countCharsExit:
	move $v0, $t2
	jr $ra
##############################################################################
#end countChars
##############################################################################

##############################################################################
#toLower 
#params, char[] string
#returns string address
##############################################################################
toLower:
	#Define your code here
	###########################################
	# DELETE THIS CODE. Only to allow main program to run without fully implementing the function
	la $v0, toLower_Alphabet
	############################################
#we load the data
	li $t0, 32
	move $t1, $a0

##loop
while: 
	lb $t2, 0($t1) #load the char
	#beq $t2, 0x20, doney #branh to exit if space NO NEED FOR THIS
	beq $t2,'\0', doneTolower
	bge $t2, 0x41, convertToLower
	#ble $t2, 0x5A, convertToLower
	b repeatLoop
	#convert
convertToLower:
	bgt $t2, 0x5A, repeatLoop
	xor $t2, $t0, $t2
	#print char
	sb $t2, 0($t1)
	#prints new line
repeatLoop:
	addi $t1,$t1,1
	b while
doneTolower: 	
	move $v0, $a0
	jr $ra
##############################################################################
#end toLower
##############################################################################

##############################
# PART 1 FUNCTION
##############################

##############################################################################
#decodeNull
#
#
##############################################################################
decodeNull:
	move $t0, $a0 #contains the address to the string
	move $t1, $a1 #area what we will use to store the words
	move $t2, $a2 #size of buffer
	move $t3, $a3 #contains the address to the number list

loopDecodeArray:
	lw $t4, 0($t3) #load the next word into $t2
	beq $t4, -1, exit #if we have a -1 we exit we are done 

	#store the values of T registers before calling function
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $t3, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t4, 20($sp)
	#pass the parameters 
	move $a0, $t4
	move $a1, $t0 
	
	jal getChar#get char takes two arguments and returns two values	
	
	lw $t4, 20($sp)
	lw $t2, 16($sp)
	lw $t1, 12($sp)
	lw $t0, 8($sp)
	lw $t3, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 24
	
	move $t0, $v1#move adress of string
	#store it if the number got is not 0
	beqz $t4, nextNumber
	sb $v0, 0($t1)
	addi $t1,$t1, 1
nextNumber:
###
	addi $t3, $t3, 4 # we add 4 to the address to get the next value
	j loopDecodeArray
exit:	
##null terminate the buffer
	li $t5,'\0' #NULL TERMINATED<--------------------------#############<><><><><>
	sb $t5, 0($t1)
	jr $ra
##############################################################################
#end decodeNull
##############################################################################

##############################################################################
#getChar 
#helper method for decode null
#
##############################################################################
getChar: #this will get the char at position $a0
	
	move $t0, $a0 #move the number we want to find on string
	move $t1, $a1 #move the address of the string
	li $t2, 0 #counter that will tell us in which char we are at
loopGetChar:
	lb $t3, 0($t1) #will load each char of the strong
	beq $t3, 0x0, exitGetChar #if we encounter a null we exit
	beq $t3, 0x20, exitGetChar #if we encounter a space we exit
	blt $t3, 0x41 , loopBackGetChar #check lower bound uppercase
	bgt $t3, 0x7A, loopBackGetChar #check upper bound lowercase
	bge $t3, 0x61, addOneGetChar #check if its lowercase
	ble $t3, 0x5A, addOneGetChar # check if its uppercase
addOneGetChar: # here we add one to the counter if we encounter a char
	addi $t2,$t2,1
	beq $t0, $t2, storeChar# if we get the char we want we store it and loop
loopBackGetChar:
	addi $t1, $t1, 1 #add one to the char address
	b loopGetChar #we loop back to top
storeChar:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	#
	move $a0, $t3
	jal toUpper #make it uppercase the value will remain in $v0
	
	lw $t3, 16($sp)
	lw $t2, 12($sp)	
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20

	b loopGetChar #we keep looping till we hit a space or null
exitGetChar:
	addi $t1, $t1, 1 #add one to the char address
	move $v1, $t1#store the adress for return
	jr $ra
##############################################################################
#end getChar
##############################################################################

##############################
# PART 2 FUNCTIONS
##############################

##############################################################################
#genBacon 
#
#
##############################################################################
genBacon:
	#Define your code here

	###########################################
	# DELETE THIS CODE. Only to allow main program to run without fully implementing the function
	la $v0, genBacon_buffer1
	############################################
	move $t0, $a0 #plain text address
	move $t1, $a1 #buffer address
	move $t9, $a1 #move buffer for end
	move $t2, $a2 #first char 
	move $t3, $a3 #second char
	##store the buffer address for end'
	#sw $t9, addressOfbuffer
	addi $sp, $sp, -24
	#store registers to call toLower method on string
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $ra, 16($sp)
	sw $t9, 20($sp)
	move $a0, $t0 #move the address of the string 
	jal toLower
	lw $t9, 20($sp)
	lw $ra, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 24
	move $t0, $v0 #move the result into $v0 contains address

##main function loop
loopMain:
	lb $t4, 0($t0) #load the first char
	beq $t4, 0x0, endLoopMain #exit if its null
	
	##check if its a letter to being with
	addi $sp, $sp, -28
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $ra, 20($sp)
	sw $t9, 24($sp)
	move $a0, $t4  #arg
	jal isCharLetter #check f its letter
	beqz $v0, noSequenceChar
	lw $t9, 24($sp)
	lw $ra, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 28
	
	move $a0, $t4 #move the char to generate 
	move $a1, $t1 #pass the buffer as argument
	move $a2, $t2 #load first sequence
	move $a3, $t3 #load second sequence 
	addi $sp, $sp, -28
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $ra, 20($sp)
	sw $t9, 24($sp)
	jal storeSequence
	lw $t9, 24($sp)
	lw $ra, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 28
	move $t1, $v0 #new location of buffer
	b nextLoopItem
noSequenceChar:
	lw $t9, 24($sp)
	lw $ra, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 28
nextLoopItem:
	addi $t0, $t0, 1
	b loopMain
	#print
endLoopMain:
	move $a0, $t3  #char
	move $a1, $t1  #buffer address
	addi $sp, $sp, -8
	sw $ra, 0($sp) #load for back
	sw $t9, 4($sp)
	jal endMessage
	#we will call to count the string of the buffer
	lw $a0, 4($sp)
	jal countChars
	move $v1, $v0 #move the size number to $v1
	lw $v0, 4($sp) #returns the address
	
	lw $ra, 0($sp) #load for back
	addi $sp, $sp, 8
	jr $ra
##############################################################################
#end genBacon
##############################################################################

##############################################################################
#hideEncoding 
#
#
##############################################################################
hideEncoding:
	#Define your code here
	move $t0, $a0 #baconian sequence address
	move $t1, $a1 #hide encoding text 
	move $t2, $a2 #symbol to make uppercase
	move $t3, $a3 #length of the encoding
	li $t9, 0 #count for number of bacon used 
	addi $sp, $sp, -24
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $ra, 16($sp)
	sw $t9, 20($sp)
	move $a0, $t1 #load address of string
	jal toLower #make it lowercase
	lw $t9, 20($sp)
	lw $ra, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 24
	blez $t3, exitHideEncoding #if the encoding size is zero then we just exit
loadByteSequence:	
	lb $t4, 0($t0) #load the next byte sequence 
loadByteChar: 
	lb $t5, 0($t1) #load next byte text
	beqz $t4, exitHideEncoding #if null we exit
	beqz $t5, exitHideEncoding #if null we exit
	#save all these stuff
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $ra, 24($sp)
	sw $t9, 28($sp)
	move $a0, $t5 #load char
	jal isCharLetterHideEncoding
	lw $t9, 28($sp)
	lw $ra, 24($sp)
	lw $t5, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 32
	beqz $v0, getNextHideEncodingChar
	bne $t2, $t4, continueHideEncoding
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $ra, 24($sp)
	sw $t9, 28($sp)
	move $a0, $t5 #move char to make uppercase
	jal toUpper
	lw $t9, 28($sp)
	lw $ra, 24($sp)
	lw $t5, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 32
	sb $v0, 0($t1) #load the byte back 
	
continueHideEncoding: #in case we dont have to make it uppercase
	addi $t9, $t9, 1
	addi $t1, $t1, 1 #increment pointer of text 
	addi $t0, $t0, 1 #increment pointer of text 
	b loadByteSequence
getNextHideEncodingChar:
	addi $t1, $t1, 1 #increment pointer of text 
	b loadByteChar
exitHideEncoding:
	beq $t3, $t9, equalSize
	li $v1, 0
continueHide:
	move $v0, $t9
exitHide:
	jr $ra
equalSize: 
	li $v1, 1
	b continueHide
##############################################################################
#end hideEncoding
##############################################################################

##############################################################################
#findEncoding
#
#
##############################################################################
findEncoding:
	#Define your code here
	move $t0, $a0 #address of where to store it
	move $t1, $a1 #text address
	move $t2, $a2 #upper case symbol
	move $t3, $a3 #size of storage + additional for null
	move $t6, $t0 #save the start of buffer for later
loopFindEncoding:
	lb $t4, 0($t1) #move the char to check	
  	beqz $t4, exitFindEncoding
  	#find out if char is a letter 
  	addi $sp, $sp, -28
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $ra, 20($sp)
	sw $t6, 24($sp)
	move $a0, $t4
  	jal isCharLetterHideEncoding
	beqz $v0, nextCharFindEncoding #if its not a letter we just skip else we continue
	lw $a0, 16($sp) #load the char for argument
	jal isUpper #check if its upper
	lw $t6, 24($sp)
	lw $ra, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 28
	beqz $v0, storeLowerCaseChar #check if its upper or lower
	#store byte that is uppercase symbol
	sb $t2, 0($t0) #store it in buffer
	addi $t0, $t0, 1
	addi $t3, $t3, -1 #TAKE ONE FROM BUFFER SIZE LEFT
	b loopBackFindEncoding
storeLowerCaseChar:
	addi $t2, $t2, 1
	sb $t2, 0($t0) #store it in buffer
	addi $t3, $t3, -1 #TAKE ONE FROM BUFFER SIZE LEFT
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t2, $t2, -1#return to orginal symbol
	b loopFindEncoding
nextCharFindEncoding:
	lw $t6, 24($sp)
	lw $ra, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 28
	addi $t1, $t1, 1
	b loopFindEncoding
loopBackFindEncoding:
 	addi $t1, $t1, 1
ble $t3,1, exitFindEncoding #IF ITS ZERO THEN WE USED IT ALL UP AND WE JUST STORE THE NULL
	b loopFindEncoding
  exitFindEncoding:
  	li $t5, '\0' 			#NULL TERMINATED<--------------------------#############<><><><><>
  	sb $t5, 0($t0) #store it in buffer ##end it with null
 	
 	######
 	#do other stuff here countChar, say if its complete or not 
 	######
 	#count char add 1 to counter if we encounter A..then we reset else we add one if 5 then we got EOM
 	addi $sp, $sp, -8
 	sw $ra, 0($sp)
 	sw $t6, 4($sp) #save buffer start
 	move $a0, $t6	
 	jal countChars
 	lw $t6, 4($sp) #load buffer
 	lw $ra, 0($sp)
 	addi $sp, $sp, 8
 	move $t1, $v0 #more length result
 	move $t3, $v0
 	li $t2, 5
 	div $t1, $t2 #divide
 	mfhi $t1 #remainder
 	beqz $t1, noRemainder
 	li $t1, 0
 	b exitFindBacon
 noRemainder:
 	li $t1, 1
 exitFindBacon:
 	move $v1, $t1
 	move $v0, $t3
	jr $ra

##############################################################################
#end findEncoding
##############################################################################

##############################################################################
#decodeBacon
#
#
##############################################################################
decodeBacon:
	#Define your code here
	move $t0, $a0 #baconian sequence string
	move $t1, $a1 #symbol which denotes 0 
	move $t2, $a2 #buffer address 
	move $t3, $a3 #length of the buffer
	li $t4, 0 #count for bits
	li $t5, 0 #count to keep track of symbol # EOM
	li $t6, 0x10 #number we will be adding but with time
	li $t7, 0 #result letter
	li $t9, 0 #will denote whether the string had a EOM OR NOT
loopDecodeBacon:
	beq $t5, 5, hasEOM #check if EOM
	beq $t4, 5, printDecodeBacon #save the char
	lb $t8, 0($t0) #baconian char
	beqz $t8, exitDecodeBacon
	bne $t8, $t1, weGotZeroBit #if we got zero or one
	add $t7, $t7, $t6
	srl $t6, $t6, 1
	addi $t5, $t5, 1 #ADD ONE TO EOM if 5 then we exit
	b continueLoopDecode
weGotZeroBit:#counts as a 0
	srl $t6, $t6, 1
	li $t5,0 #we reset count for EOM
continueLoopDecode:
	addi $t4, $t4, 1
	addi $t0, $t0, 1
	b loopDecodeBacon
printDecodeBacon:
	ori $t7, $t7, 0x60
	addi $t7, $t7, 1
	#check if they are special chars 
	beq $t7, 0x79, storeSpaceDecodeBacon#space
	beq $t7, 0x7A, storeAdmirationDecodeBacon#space
	beq $t7, 0x7B, storeColonDecodeBacon#space
	beq $t7, 0x7C, storeComaDecodeBacon#space
	beq $t7, 0x7D, storeDotDecodeBacon#space
	b continuePrintDecodeBacon
storeSpaceDecodeBacon:
	li $t7, ' '
	b continuePrintDecodeBacon
storeAdmirationDecodeBacon:
	li $t7, '!'
	b continuePrintDecodeBacon
storeColonDecodeBacon:
	li $t7, '‘'
	b continuePrintDecodeBacon
storeComaDecodeBacon:
	li $t7, ','
	b continuePrintDecodeBacon
storeDotDecodeBacon:
	li $t7, '.'
	#reset all counts
continuePrintDecodeBacon: 
	sb $t7, 0($t2) #store it in buffer
	addi $t2, $t2, 1 #add one to buffer
	addi $t3, $t3, -1 #SUB ONE FROM BUFFER SIZE IF = 0 THEN WE EXIT   
ble $t3,1, bufferExceded #IF ITS ZERO THEN WE USED IT ALL UP AND WE JUST STORE THE NULL
	li $t4, 0 #count for bits
	li $t5, 0 #count to keep track of symbol # EOM
	li $t6, 0x10 #number we will be adding but with time
	li $t7, 0 #result letter
	b loopDecodeBacon
hasEOM:
	li $t9, 1 #has a eom
exitDecodeBacon:
#add a null ending
bufferExceded:
	li $t7, '\0' 	#NULL TERMINATED<--------------------------#############<><><><><>
	sb $t7, 0($t2) #store it in buffer
	addi $t2, $t2, 1 #add one to buffer 
#count the number 
	move $a0, $a2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal countCharsForDecodeBacon
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	addi $v0, $v0, 1 #add one to account for null
	move $v1, $t9 #returns one if  has eom else it wont
	jr $ra
##############################################################################
#end decodeBacon
##############################################################################

##############################
# PART 2 FUNCTIONS END
##############################
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
	li $t0, '\0' #NULL TERMINATED<--------------------------#############
	sb $t0, 0($t1)
	move $v0, $t1
	jr $ra
	
##########################################################################
# END endMessage
##########################################################################

##############################################################################
# storeSequence method takes 4 param 
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
	srl $t5, $t5, 1 # we save value in t5 one to check next bit
	b loopSequenceStore
doneLoopSequenceStore:
	move $v0, $t1
	jr $ra 
##########################################################################
# END storeSequence
##########################################################################

countCharsForDecodeBacon:
	move $t0, $a0 #this holds the address
	li $t1, 0 #count 
whileCountChars:
	lb $t2, 0($t0)
	beqz $t2, exitCountCharsForDecodeBacon
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	b whileCountChars
exitCountCharsForDecodeBacon:
	move $v0, $t1
jr $ra

##########################################################################
# END countCharsForDecodeBacon
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

##############################################################################
#isCharLetterHideEncoding
#parms, (char a) 
#return true or false if it is a char letter
##############################################################################
isCharLetterHideEncoding:
	move $t0, $a0 #this holds the char

	#beq $t0, '\0', notLetterChar #check if we have null termination
	blt $t0, 0x41 , notLetterCharHideEncoding #check lower bound uppercase
	bgt $t0, 0x7A, notLetterCharHideEncoding #check upper bound lowercase
	bge $t0, 0x61, letterCharHideEncoding #check if its lowercase
	ble $t0, 0x5A, letterCharHideEncoding # check if its uppercase
	#27(apostrofe), 2C(coma), 41(admiracion), 20(space) 2E (dot)
letterCharHideEncoding:
	li $v0, 1 #return one if it is
	b isCharLetterExit
notLetterCharHideEncoding:
	li $v0, 0 #return zero if its not
isCharLetterHideEncodingExit:
	jr $ra
##############################################################################
#end countChars
##############################################################################

##############################################################################
#isUpper
#parms, (char a) 
#return true or false if it is a upper letter
##############################################################################
isUpper:
	move $t1, $a0 #move the argument to $t1 register, the char
	beq $t1,'\0', doneIsUpper #check if its a null
	blt $t1, 0x61, doneIsUpper #check if its already uppercase
	bgt $t1, 0x7A, doneIsUpper #check upper boundary
	li $v0, 0
	b exitIsUpper
doneIsUpper:	
	li $v0, 1 #move result to the $v0 register
exitIsUpper:
	jr $ra
##############################################################################
#end countChars
##############################################################################
.data
