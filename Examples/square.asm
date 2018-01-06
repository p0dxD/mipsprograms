#the following will compute $s0 = srt($a0*$a0 + $a1*$a1)
.text
.globl main
main:

li $a0, 2
li $a1, 3
mult $a0, $a0
mflo $t0
mult $a1, $a1
mflo $t1
add $a0, $t1, $t0
jal srt
move $s0, $v0 #the result is usually in $v0 after sqr is returned

srt:
	syscall
