.data
decodeNull_header: .asciiz "\n\n********* decodeNull *********\n"
decodeNull_text: .asciiz "Whenever students program lovely code very late at night, my brain explodes! *sigh sigh sigh*"
decodeNull_buffer: .space 101
.align 2
decodeNull_length: .word 100
decodeNull_pattern: .word 1, 5, 0, 5, 2, 1, 4, 0, 0, 1, 4, 3, 1, -1

# genBacon
genBacon_header: .asciiz "\n\n********* genBacon *********\n"
genBacon_plaintext1: .asciiz "Cse220!"
.text
la $t1, decodeNull_buffer
li $s1, 'a'
sb $s1, 0($t1)
li $s1, 'a'
addi $t1,$t1, 1
sb $s1, 0($t1)
li $s1, 'a'
addi $t1,$t1, 1
sb $s1, 0($t1)
li $s1, 'a'
addi $t1,$t1, 1
sb $s1, 0($t1)
la $t1, decodeNull_buffer
move $a0, $t1
li $v0, 4
syscall