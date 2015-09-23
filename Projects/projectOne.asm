#Homework #1
#name: Jose Rodriguez
#sbuid: 107927299
.text
#$s0 will contain the value till part two, $s1 will be used for part three on
.globl main
#-----------------------------	MACROS ----------------------------------
#prints out a message from a label 
.macro printMessage (%label)
	la $a0,%label #load address into register
	li $v0, 4 	    #load immediate 4 to printout message
	syscall 
.end_macro 
#prints out a new line
.macro newLine
	la $a0, newL
	li $v0, 4
	syscall
.end_macro
#prints out a tab
.macro tab
	la $a0, tabL
	li $v0, 4
	syscall
.end_macro
#call for binary value
.macro binaryValue(%value)
	move $a0,%value
	li $v0, 35
	syscall
.end_macro
#call for twos complement
.macro twosComplementDecimal(%value)
	move $a0,%value
	li $v0, 1
	syscall
.end_macro
#print hexadecimal value
.macro hexadecimalValue(%value)
	move $a0,%value
	li $v0, 34
	syscall
.end_macro
#------------------------END MACROS--------------------------------
main:
	li $t9, 0 # THIS REGISTER WE WILL USE FOR THE END AS A CHECK TO SEE IF WE NEED TO EXIT EARLIER
#printout message to take input
	printMessage(inputMessage)
#ask user for value
	li $v0, 5
	syscall
	move $s0, $v0
	move $s1,$s0 # we also save the value here for future parts
#display twos complement
partFour:
	printMessage(twosComplement) #display message
	#display the decimal value 2's complement
	tab
	twosComplementDecimal($s0)
	#display the hexadecimal value
	tab
	hexadecimalValue($s0)
	#display the binary value
	tab
	binaryValue($s0)
	#display the two bit representation in decimal
	tab
	twosComplementDecimal($s0)
	newLine
#display ones complement
	printMessage(onesComplement)#display message
	bgez $s0,printonescomplement#if value is negative we negate then add one then negate again 
	not $s0,$s0 #flip to get positive value
	addi $s0,$s0,1 #then we add one to obtain original
	not $s0,$s0 #we negate again to obtain value
printonescomplement:#else we just print it out
	#display the decimal value ones complement
	tab
	move $a0, $s0
	li $v0, 100
	syscall
	#printout the hex value
	tab
	hexadecimalValue($s0)
	#display the binary value
	tab
	binaryValue($s0)
	#display the decimal value
	tab
	twosComplementDecimal($s0)
	newLine
#display neg ones complement
	printMessage(negOneComplement)#display message
	#display the value in negative 
	tab
	not $s0,$s0
	move $a0, $s0
	li $v0, 100
	syscall
	#display hex
	tab
	hexadecimalValue($s0)
	#display the binary value
	tab
	binaryValue($s0)
	#display the decimal value
	tab
	twosComplementDecimal($s0)
	newLine
#display neg signed magnitude
	bgez $s0,printsigned #if value is greater or equal to zero we skip this
	not $s0,$s0 #we not to get the positive value from ones complement
	ori $s0,$s0,0x80000000 #we or with this value to turn on the first bit value
printsigned:#else we just print it out
	printMessage(negSignedMagnitude)#display message
	#display the value in signed magnitude
	tab
	move $a0, $s0
	li $v0, 101
	syscall
	#display hex
	tab
	hexadecimalValue($s0)
	#display the binary value
	tab
	binaryValue($s0)
	#display the decimal value 2's complement
	tab
	twosComplementDecimal($s0)
	newLine
	beq $t9, 1, exit #IF ONE EXIT
#for PART THREE
	newLine
	printMessage(ieeeSingle)#display message
	#here we will get the exponent value for single precision
	sll $t0, $s1, 1 #first we shift logically left one 
	srl $t0, $t0, 24 #we now get the actual value by shifting logically right
	move $t1, $t0 #save value for infinity check part
	move $a0, $t0
	li $v0, 1
	syscall
	#here we obtain single precision excess value
	tab
	addi $t0,$t0,-127
	move $a0, $t0
	li $v0, 1
	syscall
	#if we have all zeros we will do this
	move $t0, $t1
	bgtz $t0, infinityCheck #here we check the value
	#if we have all ones we will do this
zeroPrint:
	#now i check if the 23 values on the right are zeros
	andi $t0, $s1, 0x7FFFFF
	bgtz $t0, endSingle #if the value on the 23 bits are bigger we jump to jsut print it out
	#else we continue to check sign bit to print negative or positive 
	srl $t0, $s1, 31 
	beqz $t0, posZero #if its zero we jump and print zero, else we print negative 
	tab
	printMessage (negativeZero)
	b endSingle
posZero:
	tab
	printMessage (positiveZero)
	b endSingle
infinityCheck:
	bne $t0, 0xFF, endSingle # we check if the number has all 8 bits on , if not we jump to continue
	#now we check the last 23 bits 
	andi $t0, $s1, 0x7FFFFF # we AND to get the last 23 bits
	beqz $t0, infSignCheck
	tab
	printMessage (notANumber) #if we have a value greater than 0 than its not a real value
	b endSingle
infSignCheck:
	# here we will check the sign bit to determine if its postivive infinity or negative
	srl $t0, $s1, 31 
	beqz $t0, posInf
	tab 
	printMessage(negativeInf)
	b endSingle
posInf: 
	tab 
	printMessage(positiveInf)
endSingle:
	newLine
	#here we will get the exponen value for double precision 
	printMessage(ieeeDouble)#display message
	sll $t0, $s1, 1 #first we shift logically left one 
	srl $t0, $s1, 20 #we now get the actual value by shifting logically right
	move $a0, $t0
	li $v0, 1
	syscall
	#here we obtain single precision excess value
	tab
	addi $t0,$t0,-1023
	move $a0, $t0
	li $v0, 1
	syscall
	newLine
#---PART FOUR PROJECT 
	#li $t0, 3 #this will contain our i variable
	#la $t1, arrayChar
#loop:
	printMessage(charMessage) #ask for a character four times and store it in different register
	li $v0, 12
	syscall
	move $t1, $v0
	newLine
	printMessage(charMessage)
	li $v0, 12
	syscall
	move $t2, $v0
	newLine
	printMessage(charMessage)
	li $v0, 12
	syscall
	move $t3, $v0
	newLine
	printMessage(charMessage)
	li $v0, 12
	syscall
	move $t4, $v0
	sll $t2, $t2, 8 #shift to obtain position for combining 
	sll $t3, $t3, 16
	sll $t4, $t4, 24
	or $t1, $t2, $t1 #we combine all the values from the registers
	or $t1, $t3, $t1
	or $t1, $t4, $t1
	li $t9, 1	#sets the bit to exit early of the top portion
	move $s0, $t1 #move the value to the register we used to get the values at top
	newLine
	b partFour #goes to top to printout 
#to exit the program
exit:
	li $v0, 10
	syscall

.data
inputMessage: .asciiz "Enter an interger number: "
#labels for type of output
twosComplement: .asciiz "2's complement: "
onesComplement: .asciiz "1's complement: "
negOneComplement: .asciiz "Neg 1's complement: "
negSignedMagnitude: .asciiz "Neg Signed Magnitude: "
ieeeSingle: .asciiz "IEEE-754 single precision: "
ieeeDouble: .asciiz "IEEE-754 double precision: "
newL: .asciiz "\n"
tabL: .asciiz "\t"
negativeZero: .asciiz "-0"
positiveZero: .asciiz "+0"
negativeInf: .asciiz "-INF"
positiveInf: .asciiz "+INF"
notANumber: .asciiz "NaN"
charMessage: .asciiz "Enter a character: "
