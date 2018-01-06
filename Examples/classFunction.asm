#6 steps: 
#before	1. place parameters in arg register ($a0-$a1)
#	2.save return address & then call function
#		jal label ; jump & link ,
#after	3. Allocate space for a function (local variables/ some registers)
#	4. Do work
#	5. place return in Registers (v0,v1)
#	6.Return control to calling program (jr $ra)
#int sum(int x, int y) returns x+ y;
.text
.globl main
sum:
	add $v0, $a0, $a1
	jr $ra
main: 
addFun: 
	li $a0, 7 #place in arg
	li $a1, 10
	jal sum
display:
	move $a0, $v0
	li $v0, 1
	syscall
exit:
	li $v0, 10
	syscall