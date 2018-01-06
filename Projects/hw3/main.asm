.data
first: .asciiz "landscape1.map" 
#moves: .asciiz "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd"
moves: .asciiz "wwwwwwasdadweqweresdqwerwsdcewsdewsaqswedsqedwsadewsadedwsadcfewsadedwdswsxwdewsd"
movestwo: .asciiz "w123123huadhgj"
movesThree: .asciiz "wwwwwasaaasaaaawwwwwwwwwwsssssssssssssswddddddddddddsd"
#.align 1
.text
	li $a0, 0xffff0000
	la $a1, first
	li $a2, 0xFA0
	#li $a2, 320
	jal arrayFill
	
	
	#move $a0, $v0
	#li $v0, 1
	#syscall
#@param arr Base address of the array in memory. a0
#@param value The 2-byte value to search for in the array. a1
#@param row The number of rows in the array. a2
#@param column The number of columns in the array. a3
	li $a0, 0xffff0000
	#li $a1, 0x2f2b #value to search for
	li $a1, 0x2f2b #value to search for
	li $a2, 25
	li $a3, 80
	jal find2Byte
	
	#move $a0, $v0
	#li $v0, 1
	#syscall
	
	#move $a0, $v1
	#li $v0, 1
	#syscall
#@param A Base address of the memory array. a0
#@param start_r The row of the mower. a1
#@param start_c The column of the mower. a2
#@param moves Address of string of characters for moves. a3
	li $s0, 1
	li $s1, 2
	li $s2, 3
	li $s3, 4
	li $a0, 0xffff0000
	move $a1, $v0
	move $a2, $v1
	#li $a1, -1
	#li $a2, -1
	la $a3, moves
	jal playGame
	
	
	li $a0, 0xffff0000
	#move $a1, $v0
	#move $a2, $v1
	li $a1, 3
	li $a2, 4
	la $a3, movestwo
	#jal playGame

	li $a0, 0xffff0000
	#move $a1, $v0
	#move $a2, $v1
	li $a1, -2
	li $a2, -2
	la $a3, movesThree
	#jal playGame
#close
#jal extraCreditLogo
	li $v0, 10
	syscall
.include "hw3.asm"
