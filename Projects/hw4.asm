	.macro space
	li $a0, 20
	li $v0, 11
	syscall
.end_macro
	
	# New line
	.macro newline
		li $v0, 4
		la $a0, nl
		syscall
	.end_macro
	# Print Decimal Value
	.macro printDecvalue(%x)
		li $v0, 1
		move $a0,%x
		syscall
	.end_macro
.macro printCoord(%a, %b)
		li $v0, 4		
		la $a0, pSudoku1
		syscall
	
		li $v0, 1
		move $a0, $a1
		syscall
	
		li $v0, 4		
		la $a0, pSudoku2
		syscall
	
		li $v0, 1
		move $a0, $a2
		syscall
	
		li $v0, 4		
		la $a0, pSudoku3
		syscall
		newline
	.end_macro

############################################################
# sudoku solver function
# public (byte [], int) colSet (byte[][] board, int x, int y)
############################################################		
sudoku2:
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	
	move $fp, $sp

	#sw $zero, 0($sp)
	#sw $zero, 4($sp)
	#sw $zero, 8($sp)
	#sw $zero, 12($sp)
	
	addi $sp, $sp, -20
	sw $s0, 0($sp)			# Address of Board
	sw $s1, 4($sp)			# Row
	sw $s2, 8($sp)			# Column
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	
	move $s0, $a0			# Address of Board
	move $s1, $a1			# Row
	move $s2, $a2			# Column
	li $s4, 0		# Counter
	
	printCoord($s1,$s2)		# Print the coordinates
	
	###################### CHECK IF SOLUTION ######################
	move $a0, $s1			# Load row into a0
	move $a1, $s2			# Load column into a1
	jal isSolution			# Check if its a solution
	###############################################################
	
	###################### Else branch to solved ##################
	beq $v0, 1, solved		# If solution then go to solved
	###############################################################
	
	###################### Add one to column ######################
	addi $s2, $s2, 1 		# Add 1 to Column
	bgt $s2, 8, nextRow		# If at the end of the row
	j checkCell
	###############################################################
	
	###################### Go to next row #########################
	nextRow:
		addi $s1, $s1, 1	# Add 1 to the row
		li $s2, 0		# Reset column to 0
	###############################################################
		
	###################### CHECK THE CELL #########################
	checkCell:
		li $t1, 9
		mul $t1, $t0, $s1 
		add $t0, $s2, $t1 
		add $t0, $s0, $t0 
		lb $t1, 0($t0) 
		beqz $t1, getCandidates	
	
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		jal sudoku2
		j constantExit
		
	getCandidates:
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		move $a3, $fp
		jal constructCandidates
		##
		newline
move $t0, $fp
li $t9, 9
loopTestconstructCandidates1:
	lb $a0, 0($t0)
	beqz $t9, exitLoopTestconstructCandidates1
	#beqz $a0, exitLoopTestconstructCandidates
	li $v0, 1
	syscall
	space
	addi $t9, $t9, -1
	addi $t0, $t0, 1
	b loopTestconstructCandidates1
exitLoopTestconstructCandidates1:
newline
		##
		sw $v0, 12($fp)
		li $s3, 0 	
		lw $t1, 12($fp)
	
		solveLoop:
			lw $t1, 12($fp)
			blt $s3, $t1,addToBoard
			j constantExit
			
			addToBoard:
	move $a0, $s0
		jal printSolution
				  li $t0, 9 
				  mul $t1, $t0, $s1 
	 			  add $t0, $s2, $t1 
				  add $t0, $s0, $t0 
				  add $t2, $fp, $s3  
				  sb $t2, 0($t0)
	move $a0, $s0
		jal printSolution
			callSudoku:
				move $a0, $s0
				move $a1, $s1
				move $a2, $s2
				jal sudoku2
			backtrack:
				li $t1, 9
				mul $t0, $s1, $t1	# multiply row by 9
				add $t2, $t0, $s2	# ( i * 9) + (j * 1)
				add $t3, $t2, $s0	# Add to base address
				sb $zero, 0($t3) 
				lb $t7, FINISHED
				beq $t7, 1, constantExit
				addi $s3, $s3, 1
				j solveLoop
	############### SOLVED ################################
	solved:
		move $a0, $s0
		jal printSolution
		li $t0, 1
		sb $t0, FINISHED
	#######################################################
	constantExit:
		lw $ra, 20($fp)
		lw $fp, 16($fp)
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp) 
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		addi $sp, $sp, 44
		jr $ra
	#######################################################

# Homework #4
# name: Jose Rodriguez
# sbuid: 107927299
##############################################################
# Computes the Nth number of the Hofsadter Female Sequence
# public int F (int n)
#
F:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $s0, 8($sp)
	
	move $s0, $a0
	#text print
	la $a0, fText
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 1
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
	##
	beqz $s0, baseF
	##pass it F(n-1)
	addi $a0, $s0, -1
	jal F
	move $a0, $v0
	jal M
	sub $v0, $s0, $v0
	j exitF
baseF:
	li $v0, 1
exitF:
	lw $s0, 8($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
jr $ra

#
# Computes the Nth number of the Hofsadter Male Sequence
# public int M (int n)
#	
M:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $s0, 8($sp)
	
	move $s0, $a0
	#text print
	la $a0, mText
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 1
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
	##
	beqz $s0, baseM
	##pass it F(n-1)
	addi $a0, $s0, -1
	jal M
	move $a0, $v0
	jal F
	sub $v0, $s0, $v0
	j exitM
baseM:
	li $v0, 0
exitM:
	lw $s0, 8($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
jr $ra

#
# Tak Function
# public int tak (int x, int y, int z)
#
tak:
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $a0, 4($sp) #x
	sw $a1, 8($sp) #y
	sw $a2, 12($sp) #z
	sw $s0, 16($sp) 
	sw $s1, 20($sp)
	sw $s2, 24($sp)
	
	bge $a1, $a0, baseTak
	addi $a0, $a0, -1
	jal tak
	move $s0, $v0
	
	lw $a0, 8($sp)#y
	addi $a0, $a0, -1
	lw $a1, 12($sp) #z
	lw $a2, 4($sp) #x
	jal tak
	move $s1, $v0
	
	lw $a0, 12($sp)#z
	addi $a0, $a0, -1
	lw $a1, 4($sp) #x
	lw $a2, 8($sp) #y
	jal tak
	move $s2, $v0
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	jal tak
	
	j exitTak
baseTak:
	move $v0, $a2
exitTak:
	lw $ra, 0($sp)
	lw $a0, 4($sp) #x
	lw $a1, 8($sp) #y
	lw $a2, 12($sp) #z
	lw $s0, 16($sp) 
	lw $s1, 20($sp)
	lw $s2, 24($sp)
	addi $sp, $sp, 28
jr $ra

#
# Helper function for solving sudoku
# public boolean isSolution (int row, int col)
#
isSolution:
	#row a0
	#col a1
	bne $a0, 8, notSolution
	bne $a1, 8, notSolution
	li $v0, 1
	b exitIsSolution
notSolution:
	li $v0, 0
exitIsSolution:
jr $ra

#
# Helper function for solving sudoku
# public void printSolution (byte[][] board)
#
printSolution:
	#a0 has array board pointer
	move $t0, $a0 #save because we dont wan tto lose it
	##mesage
	la $a0, sudokuSolution
	li $v0, 4
	syscall
	
	li $a0, 10#new line
	li $v0, 11
	syscall
	##
	li $t1, 9 #counter columns
	li $t2, 9 #counter rows
loopPrintSolution:
	beqz $t2, exitPrintSolution
	beqz $t1, printNewRow
	#to print it
	lb $a0, 0($t0)
	li $v0, 1
	syscall
	li $a0, 20#space
	li $v0, 11
	syscall
	#
	addi $t0, $t0, 1
	addi $t1, $t1, -1
	b loopPrintSolution
printNewRow:
	#print new line
	li $a0, 10
	li $v0, 11
	syscall 
	#
	li $t1, 9 #reset counter
	addi $t2, $t2, -1 #sub one from rows left
	b loopPrintSolution#go back top
exitPrintSolution:
jr $ra

#
# Helper function for solving sudoku
# public (byte [], int) gridSet (byte[][] board, int row, int col)
#
gridSet:
	#a0 pointer to board
	#a1 row 
	#a2 col
	li $t0, 3 #for division and multiplication
	div $a1, $t0
	mflo $t1 
	mul $t1, $t1, $t0 #t1 has first result
	#$t1 has r_start
	div $a2, $t0
	mflo $t2 
	mul $t2, $t2, $t0 #t1 has first result 
	#t2 has c_start
	li $t0, 0 #count start
	
	li $t3, 9
	mul $t1, $t1, $t3 #mul to get initial value in array
	add $a0, $t2, $a0 #add the column offset
	add $a0, $a0, $t1 #added off set to board address
	
	la $t4, gSet #load the address of gset for later use
	li $t1, 3 #for row
	li $t2, 3  #for column
##start loop
loopGridSet:
	lb $t3, 0($a0)#get the element 
	beqz $t1, doneGridSet
	beqz $t2, incRowGridSet
	beqz $t3, getNextElement #jump if 0, not to add to counter nor to the other array
	sb $t3, 0($t4) #put it in the set
	addi $t4, $t4, 1 #add one to the pointer of the set
	addi $t0, $t0, 1 #add one to the count 
getNextElement:
	addi $t2, $t2, -1 #sub one to column
	addi $a0, $a0, 1 #add one to the address of a0
	b loopGridSet
incRowGridSet:
	li $t2, 3  #for column put at start
	addi $t1, $t1, -1 #sub one to row
	addi $a0, $a0, 6 #add offset of row
	b loopGridSet
doneGridSet:
	#la $v0, gSet
	move $v0, $t0 #move the count to result
jr $ra

#
# Helper function for solving sudoku
# public (byte [], int) colSet (byte[][] board, int col)
#	
colSet:
	#a0 has address
	#a1 col number
	la $t0,cSet #where we will store them
	li $t1, 0 #counter to zero
	
	li $t2, 9 #for setting offset and then for loop
	#mul $t3, $t2, $a1 
	add $a0, $a0, $a1 #add the offset to the initial address
	
loopColSet:
	lb $t3, 0($a0)#get number
	beqz $t2, endColSet #check if we looped all 9 and end if so
	beqz $t3, getNextColNumber
	#else we store it
	sb $t3, 0($t0) #store it in array
	addi $t0, $t0, 1 #add one to the address
	addi $t1, $t1, 1 #add one to the count
getNextColNumber:
	addi $a0, $a0, 9 #add one to get next column 
	addi $t2, $t2, -1 #sub one from row count
	b loopColSet
endColSet:
	#la $v0, cSet
	move $v0, $t1	
	jr $ra
#
# Helper function for solving sudoku
# public (byte [], int) rowSet (byte[][] board, int row)
#		
rowSet:
	#a0 has address
	#a1 row number
	la $t0,rSet #where we will store them
	li $t1, 0 #counter to zero
	
	li $t2, 9 #for setting offset and then for loop
	mul $t3, $t2, $a1 
	add $a0, $a0, $t3 #add the offset to the initial address
	
loopRowSet:
	lb $t3, 0($a0)#get number
	beqz $t2, endRowSet #check if we looped all 9 and end if so
	beqz $t3, getNextRowNumber
	#else we store it
	sb $t3, 0($t0) #store it in array
	addi $t0, $t0, 1 #add one to the address
	addi $t1, $t1, 1 #add one to the count
getNextRowNumber:
	addi $a0, $a0, 1 #add one to get next column 
	addi $t2, $t2, -1 #sub one from column count
	b loopRowSet
endRowSet:
	#la $v0, rSet
	move $v0, $t1
jr $ra

#
# Helper function for solving sudoku
# public (byte [], int) colSet (byte[][] board, int row, int col)
#			
############################################################
# Helper function for solving sudoku
# public (byte [], int) colSet (byte[][] board, int row, int col)
############################################################			
constructCandidates:
	addi $sp, $sp, -36 		# Save arguments to stack
	sw $a0, 0($sp)			# Base Address for board		
	sw $a1, 4($sp)			# Row
	sw $a2, 8($sp)			# Column
	sw $a3, 12($sp)			# Base Address for candidates
	sw $s0, 16($sp)
	sw $s1, 20($sp)
	sw $s2, 24($sp)
	sw $s3, 28($sp)
	sw $ra, 32($sp)			# Save ra

	addi $s0, $zero, 1		# Counter for loop
	addi $s1, $zero, 0		# r_length
	addi $s2, $zero, 0		# c_length
	addi $s3, $zero, 0		# g_length
	
	
	jal rowSet
	move $s1, $v0			# Move row count to s1
	
	lw $a1, 8($sp)			# Move column to a1
	jal colSet
	move $s2, $v0			# Move colcount to s2
	
	lw $a1, 4($sp)			# Move row to a1
	lw $a2, 8($sp)			# Move col to a2
	jal gridSet
	move $s3, $v0			# Move gridcount to s3
	
	############################################################
	# MOVE THE ADDRESS FOR CANDIDTATES
	lw $a3, 12($sp)	
	move $t2, $a3		# Load address of candidates
	############################################################
	
	addi $t4, $zero, 0
forLoop:
	addi $t3, $zero, 0		# candidates counter
	bgt $s0, 9, conDone		# If greater then 9 leave 
	la $t0, rSet			# Load Address of rset
	rloop:	
	     bgt $t3, $s1, cnext	# Not in row go to cloop
	     lb $t1, 0($t0)		# Load that byte
	     beq $t1, $s0, checkNext	# Compare, if equal exit OW go to cloop
	     addi $t0, $t0, 1		# Add 1 to rset
	     addi $t3, $t3, 1		# Add 1 to offset
	     j rloop
       cnext:
	     addi $t3, $zero, 0		# Zero out offset
	     la $t0, cSet		# Load Address of cset
       cloop:
	     bgt $t3, $s2, gnext	# Not in column go to gloop
	     lb $t1, 0($t0)		# Load that byte
	     beq $t1, $s0, checkNext	# Compare, if equal exit OW go to gloop
	     addi $t0, $t0, 1		# Add 1 to cset
	     addi $t3, $t3, 1		# Add 1 to offset
	     j cloop
       gnext:
       	     addi $t3, $zero, 0
       	     la $t0, gSet		# Load Address of gset
       gloop:
	     lb $t1, 0($t0)		# Load that byte
	     beq $t1, $s0, checkNext      # Compare, if equal exit OW continue
	     addi $t0, $t0, 1		# Add 1 to gset
	     addi $t3, $t3, 1		# Add 1 to offset
	     bgt $t3, $s3, addToCan
	     j gloop
    addToCan:
    	     sb $s0, 0($t2)
    	     addi $t2, $t2, 1
    	     addi $s0, $s0, 1
    	     addi $t4, $t4, 1
    	     j forLoop
    checkNext:
    	     addi $s0, $s0, 1
    	     j forLoop
conDone:
	move $v0, $t4
	lw $a0, 0($sp)			# Restore stack
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $s0, 16($sp)
	lw $s1, 20($sp)
	lw $s2, 24($sp)
	lw $s3, 28($sp)
	lw $ra, 32($sp)					
	addi $sp, $sp, 36 		
	jr $ra

#
# sudoku solver function
# public (byte [], int) colSet (byte[][] board, int x, int y)
#	
sudoku:
	addiu $sp, $sp, -24
	sw $ra, 20($sp)
	sw $fp, 16($sp)

	#sw 12 candidateLength
	#sw 8 8
	#sw 4 4-7
	#sw 0 0-3
	move $fp, $sp #fp points to sp last place
	addiu $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp) 
	sw $s3, 12($sp)#for c
	
	
	
	move $s0, $a0 #move board s0
	move $s1, $a1 #move x s1
	move $s2, $a2 #move y s2

##text print #
	la $a0, sudokuText
	li $v0, 4
	syscall 
	#row
	move $a0, $s1
	li $v0, 1
	syscall
	#][
	la $a0, sudokuTextTwo
	li $v0, 4
	syscall
	#col
	move $a0, $s2
	li $v0, 1
	syscall
	#last part ]
	la $a0, sudokuTextThree
	li $v0, 4
	syscall
	#new line
	li $a0, 10
	li $v0, 11
	syscall
##text print end
	
	##check if is solution
	move $a0, $s1 #move row to arg a0
	move $a1, $s2 #move col to arg a1
	jal isSolution
	
	beq $v0, 1, baseSudoku #if 1 then its solved
#####################else#####################
	addi $s2, $s2, 1 #add one to column
	bgt $s2, 8, goFirstColumnOfNextRow#If we go past the last column
	b notLastColumn #else we use the original values
goFirstColumnOfNextRow:
	addi $s1, $s1, 1 #add one to x
	li $s2, 0 #make column 0

notLastColumn:
##calculate the item
	li $t0, 9 #move the 160(80colums*2bytes) to multiply it by
	mul $t1, $t0, $s1 #multiply x by 9
	add $t0, $s2, $t1 #add (x*9*1)+(y*1)
	add $t0, $s0, $t0 #add baseAddress+(x*9*1)+(y*1)
	lb $t1, 0($t0) #get the item board[x][y]
	beqz $t1, otherwise 
	#if its not blank
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal sudoku
	b doneSudoku
otherwise:#else we jump here

	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $fp #this will we the address to store the candidates
	jal constructCandidates
	sw $v0, 12($fp)#store it at the top of the stack number of candidates

	li $s3, 0 #initial of loop
	lw $t1, 12($fp)
	
whileCandidates: 
	lw $t1, 12($fp)
	blt  $s3, $t1, placeCandidate #we go into loop
	b doneSudoku
placeCandidate:
	#board[x][y] = candidates[c]
	li $t0, 9 #move the 160(80colums*2bytes) to multiply it by
	mul $t1, $t0, $s1 #multiply x by 9
	add $t0, $s2, $t1 #add (x*9*1)+(y*1)
	add $t0, $s0, $t0 #add baseAddress+(x*9*1)+(y*1)#has address
	add $t2, $fp, $s3 #get candidate address
	lb $t1, 0($t2) #has the candidate to save
	sb $t1, 0($t0) #save board[x][y] and save it there

	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal sudoku
	
	#board[x][y] = 0
	li $t0, 9 #move the 160(80colums*2bytes) to multiply it by
	mul $t1, $t0, $s1 #multiply x by 9
	add $t0, $s2, $t1 #add (x*9*1)+(y*1)
	add $t0, $s0, $t0 #add baseAddress+(x*9*1)+(y*1)#has address
	li $t1, 0
	sb $t1, 0($t0) # board[x][y] save 0 backtrack par

	lb $t1, FINISHED
	beq $t1, 1, doneSudoku #done
	#else 
	addi $s3, $s3, 1 #add one to c
	b whileCandidates
baseSudoku:
	move $a0, $s0 #move board to print
	jal printSolution
	li $t0, 1
	sb $t0, FINISHED #make finished 1
doneSudoku:
	
	lw $ra, 20($fp)
	lw $fp, 16($fp)
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp) 
	lw $s3, 12($sp)#for c
	addiu $sp, $sp, 40
	jr $ra

.data

rSet: 		.byte 0:9
cSet: 		.byte 0:9
gSet: 		.byte 0:9
FINISHED: 	.byte 0
fText: 		.asciiz "F: "
mText: 		.asciiz "M: "
sudokuText: 	.asciiz "Sudoku ["
sudokuTextTwo: 	.asciiz "]["
sudokuTextThree: .asciiz "]"
sudokuSolution: .asciiz "Solution: "



pSudoku1: .asciiz "Sudoku ["
pSudoku2: .asciiz "]["
pSudoku3: .asciiz "]"
nl: .asciiz "\n"