# Recursive Division
.data:
	divisor: .asciiz "\n\nEnter Denominator: "
	divident: .asciiz "Enter Numerator: "
	quotient: .asciiz "Quotient is: "

.text:
main:
	la $a0, divisor
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	ble $v0, $0, end
	addi $a1, $v0, 0 # holds divisor
	
	la $a0, divident
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	ble $v0, $0, end
	addi $a0, $v0, 0 # holds divident
	addi $a2, $0, 0 # counter
	
	jal division
	
	addi $a1, $v0, 0 # keep the return value for print
	la $a0, quotient
	addi $v0, $0, 4
	syscall
	addi $a0, $a1, 0
	addi $v0, $0, 1
	syscall
	
	j main
	
division:
	addi $sp,$sp, -24
	sw $a0, 20($sp) # keep numerator
	sw $a1, 16($sp) # keep denominator
	sw $a2, 12($sp) # keep counter
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	sle $s0, $a0, $a1
	beq $s0, 1, cont
	addi $sp, $sp, 24
	addi $v0, $a2, 0 # return counter
	jr $ra

cont: 
	sub $a1, $a1, $a0
	addi $a2, $a2, 1

	jal division
	lw $a0, 20($sp) # pop numerator
	lw $a1, 16($sp) # pop denominator
	lw $a2, 12($sp) # pop counter
	lw $ra, 0($sp)
	
	addi $sp, $sp, 24
	jr $ra	
end: 
	addi $v0, $0, 10
	syscall