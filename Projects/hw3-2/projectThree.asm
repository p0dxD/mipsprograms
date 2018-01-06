#EXTRACREDIT
##############################################################
# Homework #3
# name: Jose Rodriguez
# sbuid: 107927299
##############################################################
.text
##############################
# Part 1 FUNCTION
##############################
##############################################################################
#arrayFill
#@param arr
#@param fileName
#@param maxBytes
##############################################################################

arrayFill:
	#message(insideArrayFill)
	move $t0, $a0 #has the array pointer
	move $t1, $a1 #has the fileName string
	move $t2, $a2 #has the max bytes
	move $t3, $zero #will have count of bytes read
#open file
	li $v0, 13
	move $a0, $t1 #move the name of the file
	move $a1, $0 #move 0 into a1
	move $a2, $0 #move 0 into a2
	syscall
	beq $v0, -1, doneFill
	move $t9, $v0 #has file descriptor 
#read from file
readFile:
	beqz $t2, closeFile
	move $a0, $t9 #move file descriptor
	move $a1, $t0 #move buffer pointer
	li $a2, 1# read byte at a time
	li $v0, 14
	syscall 
	beqz $v0, closeFile
	addi $t2, $t2, -1 #sub one from maxbytes
	addi $t0, $t0, 1 #add one to the buffer
	addi $t3, $t3, 1 #add one to counter
	j readFile
closeFile:
#close file
	move $a0, $t9 #move file descriptor
	li $v0, 16
	syscall
	move $v0, $t3 #move the number of bytes read
doneFill:
	#message(outArrayFill)
jr $ra
##############################################################################
#find2Byte
#@param arr Base address of the array in memory. a0
#@param value The 2-byte value to search for in the array. a1
#@param row The number of rows in the array. a2
#@param column The number of columns in the array. a3
##############################################################################
find2Byte:
	li $t4, 0 #counter for i
	li $t5, 0 #counter for j
refresh:
	blez $a2, doneFind2Byte
	move $t0, $a3 #move initial columns to iterate
loopColumns:
	lh $t1, 0($a0) #load the contents of the halfword 
	beq $t1, $a1, found #if they are equal it was found
	addi $t0, $t0, -1 #sub one from the column count
	addi $a0, $a0, 2 #add two bytes to the address of the buffer
	addi $t5, $t5, 1 #add one to column
	blez $t0, decrementRow
	b loopColumns #go back to loop through other columns
decrementRow:
	li $t5, 0 #reset column count
	addi $t4, $t4, 1 #add one to row
	addi $a2, $a2, -1 #take one from row
	b refresh
found:
	#addi $a0, $a0, 2 #add two bytes to the address of the buffer
	
	move $v0, $t4
	move $v1, $t5
	b exit
doneFind2Byte:
	li $v0, -1
	li $v1, -1
exit:	
jr $ra
##############################
# PART 2/3 FUNCTION
##############################
##############################################################################
#playGame
#@param A Base address of the memory array. a0
#@param start_r The row of the mower. a1
#@param start_c The column of the mower. a2
#@param moves Address of string of characters for moves. a3
##############################################################################
playGame:
#will store s registers that will be used
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)#saving ra
	
	#move the arguments 
	move $s0, $a0 #base address 
	move $s1, $a1 #row of mower
	move $s2, $a2 #column of mower
	move $s3, $a3 #string address
	move $s4, $zero #where we will have current address
	
	#move $t0, $a0
	#lw $a0, position
	#li $v0, 1
	#syscall
	#move $a0, $t0
	#Define your code here
	blt $s1, -1, donePlayGame
	blt $s2, -1, donePlayGame
	bge $s1, 25, donePlayGame
	bge $s2, 80, donePlayGame
	beq $s1, -1, addMower #check x for -1
	beq $s2, -1, addMower #check y for -1 
	add $t1, $s1, $s2 #if its zero then coordinate was (0,0)
	beqz $t1, zeroHandle
	#else we calculate the address of given coordinates
	# args are already in the correct registers 
	b calculateAddress
zeroHandle:
	#s1, and s2 have 0 already
	lh $t2, 0($s0)
	andi $t3, $t2, 0xff20
	la $t4, color
	sh $t3, 0($t4)
	########
	li $t0, 0x2f2b #load the mower
	move $s4, $s0
	sh $t0, 0($s4) #into the calculated address
	b loopString
addMower:#add mower or check for existing one
#first we check the memory location to see if the function was previously called
	lw $s4, position #has a 0 or if we called it already has a value
	beqz $s4, addMowerToEnd
	#if its not zero we will get x and y and store in s1, s2
	sub $t3, $s4, $s0 #sub base address minus the position
	li $t2, 160
	div $t3, $t2 #div t3 with offset, with 160 to get columns and rows
	mfhi $s2 #has the remainder columns
	srl $s2, $s2, 1
	mflo $s1 #has the rows
	j loopString # we dont need to calculate address because we already have it in s4
addMowerToEnd:#if we dont have a mower then we know it will be in 24, 79
#in here we know the address if its stored else we give it (24,79)
	li $s1, 24 #load the default road and column
	li $s2, 79 
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	jal baseAddressCalculator
	li $t0, 0x2f2b #load the mower
	#load the green to the space in memory because we didnt have any other color previously
	lh $t2, 0($v0)
	andi $t3, $t2, 0xff20
	la $t4, color
	sh $t3, 0($t4)
	########
	move $s4, $v0
	sh $t0, 0($s4) #into the calculated address
	b loopString
calculateAddress:
	jal baseAddressCalculator
	move $s4, $v0
	#get the color under it
	lh $t4, 0($v0)
	la $t2, color
	andi $t3, $t4, 0xff20
	sh $t3, 0($t2)
	########
loopString:
	#s3 contains address of string
	lb $t0, 0($s3)#load first char
	beqz $t0, donePlayGame #if its a null we are done
	beq $t0, 'd', right
	beq $t0, 'a', left
	beq $t0, 'w', up
	beq $t0, 's', down
	addi $s3, $s3, 1 #add one to address of string
	b loopString
################################################################################################right
right:
	addi $s2, $s2, 1 #add one to the column
	move $t0, $s2
	#check if its a corner we are going to and is movable
	#else just continue normally
	beq $s2, 80, checkLeftCorner
	b regularCheckRight
checkLeftCorner:
	addi $t0, $s2, -80
regularCheckRight:
	move $a0, $s0
	move $a1, $s1
	move $a2, $t0
	jal isMovable
	li $t9, 80 #constains max value
	li $t8, -80 #what should be
	bnez $v0, moveRightLeft
	addi $s2, $s2, -1 #add one to the column
	addi $s3, $s3, 1 #add one to address of string
	b loopString 
#############################################################################right
left:
	addi $s2, $s2, -1 #add one to the column
	move $t0, $s2
	#check if its a corner we are going to and is movable
	#else just continue normally
	beq $s2, -1, checkRightCorner
	b regularCheckLeft
checkRightCorner:
	addi $t0, $s2, 80
regularCheckLeft:
	move $a0, $s0
	move $a1, $s1
	move $a2, $t0
	jal isMovable
	li $t9, -1 #constains max value
	li $t8, 80 #what should be
	bnez $v0, moveRightLeft
	addi $s2, $s2, 1 #add one to the column
	addi $s3, $s3, 1 #add one to address of string
	b loopString 
#############################################################################up
up:
	addi $s1, $s1, -1 #sub one to the column
	move $t0, $s1
	#check if its a corner we are going to and is movable
	#else just continue normally
	beq $s1, -1, checkLowerCorner
	b regularCheckUp
checkLowerCorner:
	addi $t0, $s1, 25
regularCheckUp:
	move $a0, $s0
	move $a1, $t0
	move $a2, $s2
	jal isMovable
	li $t9, -1 #constains max value
	li $t8, 25 #what should be added
	bnez $v0, moveUpDown
	addi $s1, $s1, 1 #add one to the column
	addi $s3, $s3, 1 #add one to address of string
	b loopString 
#############################################################################down
down:
	addi $s1, $s1, 1 #add one to the column
	move $t0, $s1
	#check if its a corner we are going to and is movable
	#else just continue normally
	beq $s1, 25, checkTopCorner
	b regularCheckDown
checkTopCorner:
	addi $t0, $s1, -25
regularCheckDown:
	move $a0, $s0
	move $a1, $t0
	move $a2, $s2
	jal isMovable
	li $t9, 25 #constains max value
	li $t8, -25 #what should be added
	bnez $v0, moveUpDown
	addi $s1, $s1, -1 #add one to the column
	addi $s3, $s3, 1 #add one to address of string
	b loopString 
moveRightLeft:
	addi $s3, $s3, 1 #add one to address of string 
	beq $s2, $t9, returnOtherSide
	#if not 80 save current 
	la $t2, color
	lh $t1, 0($t2)
	andi $t1,$t1, 0xff20
	ori $t1, $t1, 0x8020 #make it a space at the end 
	sh $t1, 0($s4)
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal baseAddressCalculator
	b putMower
returnOtherSide:
	add $s2, $s2, $t8 #make the column 0
	#color
	lh $t2, color
	andi $t1,$t1, 0xff20
	ori $t2, $t2, 0x8000 #make it a space at the end 
	sh $t2, 0($s4)
	#now calculate new address
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal baseAddressCalculator
	#we use the address to move the mower
	b putMower
moveUpDown:
	addi $s3, $s3, 1 #add one to address of string 
	#addi $s2, $s2, 1 #add one to the column
	beq $s1, $t9, returnOtherSideUpDown
	#if not 80 save current 
	la $t2, color
	lh $t1, 0($t2)
	andi $t1,$t1, 0xff20
	ori $t1, $t1, 0x8000 #make it a space at the end 
	sh $t1, 0($s4)
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal baseAddressCalculator
	b putMower
returnOtherSideUpDown:
	add $s1, $s1, $t8 #make the row 0
	#color
	lh $t2, color
	andi $t1,$t1, 0xff20
	ori $t2, $t2, 0x8000 #make it a space at the end 
	sh $t2, 0($s4)
	#now calculate new address
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal baseAddressCalculator
	#we use the address to move the mower
	b putMower
putMower:
	#save the color in the position
	lh $t1, 0($v0)
	la $t2, color
	sh $t1, 0($t2)
	#save color end
	li $t0, 0x2f2b
	sh $t0, 0($v0)
	move $s4, $v0 #current location of mower
	li $a0, 500
	li $v0, 32
	syscall
	b loopString

donePlayGame:
#save position
	#la $t0, position
	sw $s4, position

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)#saving ra
	addi $sp, $sp, 24
jr $ra

#############################################################################
##############################################################################
#isMovable
#@param address located a0
#@param i row located a1
#@param j column located a2
#one true, 0 false
##############################################################################
isMovable:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal baseAddressCalculator
	
	li $t1, 0xB06F #for the flowers, they are special
	lhu $t0, 0($v0)
	beq $t0, 0x7F52,notMove#check if its a rock
	beq $t0, 0x4F20,notMove#check if its water
	beq $t0, 0x2F5E, notMove#check if its a tree
	beq $t0, 0x3F20, notMove#check if its dirt204F
	beq $t0, $t1, notMove#check if its flowers
	li $v0, 1
	b doneIsMovable
notMove:
	li $v0, 0
doneIsMovable:
	lw $ra, 0($sp) #load the address of ra back
	addi $sp, $sp, 4
jr $ra 
##############################################################################
#baseAddressCalculator
#@param address located a0
#@param i row located a1
#@param j column located a2
##############################################################################
baseAddressCalculator:
	li $t0, 160 #move the 160(80colums*2bytes) to multiply it by
	mul $t1, $t0, $a1 #multiply i by 160
	sll $a2, $a2, 1 #multiply the columns by 2
	add $t0, $a2, $t1 #add (i*80*2)+(j*2)
	add $v0, $a0, $t0 #add baseAddress+((i*80*2)+(j*2))
#return
jr $ra
##############################################################################
#extraCreditLogo
##############################################################################

extraCreditLogo:
	li $t2, 0xffff0000
	la $t0, extraCreditMapString
loopExtraCreditLogo:
	lb $t1, 0($t0)
	beqz $t1, doneExtraCreditLogo
	sb $t1, ($t2)
	addi $t2, $t2, 1
	addi $t0, $t0, 1
	b loopExtraCreditLogo
doneExtraCreditLogo:
jr $ra

.data
.align 2
position: .word 0 #to store where the mower will be at
.align 1
color: .space 2
extraCreditMapString: .asciiz " / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o / / o             O             O             O O             O             O           o / / o             O             O             O O             O             O           o / / o             O             O             O O             O             O           o / / o    O O O O O O O O O O    O O O O O O O O O O    O O O O O O O O O O O O O O O O O O O O    O O O O O O O O O O    O    O O O O    o / / o    O O O O O O O O O O    O O O O O O O O O O    O O O O O O O O O O O O O O O O O O O O    O O O O O O O O O O    O    O O O O    o / / o    O O O O O O O O O O    O O O O O O O O O O    O O O O O O O O O O O O O O O O O O O O    O O O O O O O O O O    O    O O O O    o / / o    O O O O O O O O O O    O O O O O O O O O O    O O O O O O O O O O O O O O O O O O O O    O O O O O O O O O O    O    O O O O    o / / o    O O O O O O O O O O    O O O O O O O O O O    O O O O O O O O O O O O O O O O O O O O    O O O O O O O O O O    O    O O O O    o / / o    O O O O O O O O O O             O             O O             O             O    O O O O    o / / o    O O O O O O O O O O             O             O O             O             O    O O O O    o / / o    O O O O O O O O O O             O             O O             O             O    O O O O    o / / o    O O O O O O O O O O O O O O O O O O O    O    O O O O O O O O O O O    O O O O O O O O O O    O O O O O O O O O O    O O O O    o / / o    O O O O O O O O O O O O O O O O O O O    O    O O O O O O O O O O O    O O O O O O O O O O    O O O O O O O O O O    O O O O    o / / o    O O O O O O O O O O O O O O O O O O O    O    O O O O O O O O O O O    O O O O O O O O O O    O O O O O O O O O O    O O O O    o / / o    O O O O O O O O O O O O O O O O O O O    O    O O O O O O O O O O O    O O O O O O O O O O    O O O O O O O O O O    O O O O    o / / o    O O O O O O O O O O O O O O O O O O O    O    O O O O O O O O O O O    O O O O O O O O O O    O O O O O O O O O O    O O O O    o / / o             O             O             O O             O             O           o / / o             O             O             O O             O             O           o / / o             O             O             O O             O             O           o / / o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú Ú" 
