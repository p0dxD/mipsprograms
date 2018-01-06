.data 
list:  .space 16
.globl main
.text

main:

    li $v0, 5
    syscall
    sw $v0, list

    move $a0, $v0
    li $v0, 1
    syscall