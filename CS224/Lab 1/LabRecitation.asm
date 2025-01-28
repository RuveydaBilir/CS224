# ArithmeticExpression
.data
	inputA: .asciiz "Enter A: "
	inputB: .asciiz "Enter B: "
	inputC: .asciiz "Enter C: "
	remainder: .asciiz "\nRemainder: "
	result: .asciiz "\nResult: "
	part1: .asciiz "\nA+7 = "
	part2: .asciiz "\nB Mod (A+7) = "
	part3: .asciiz "\nB-A = "
	error: .asciiz "\nError: Zero division"
	exp: .asciiz "\nExplanation: \"(B Mod (A+7))/(B-A)\" is calculated."
.text
main:	
	li $v0,4
	la $a0, inputA
	syscall
	li $v0, 5
	syscall
	move $s1, $v0 #A
	
	li $v0,4
	la $a0, inputB
	syscall
	li $v0, 5
	syscall
	move $s2, $v0 #B
	
	li $s0, 0 # result 
	li $s3, 0 # remainder
	
	move $t4, $s1 # a for temp
	move $t5, $s2 # b for temp
	
	add $s7, $s1, 7 #result of a+7
	
	li $v0,4 #TEST
	la $a0, part1
	syscall
	li $v0,1
	move $a0, $s7
	syscall
	
	move $t4, $s2 #temp c
	move $t5, $s7 # temp a
	jal divv
	move $s5, $s3 # result of B mod a+7 (take remainder register = s3)
	
	li $v0,4 #TEST
	la $a0, part2
	syscall
	li $v0,1
	move $a0, $s5
	syscall
	
	sub $s6, $s2, $s1
	
	li $v0,4
	la $a0, part3
	syscall
	li $v0,1
	move $a0, $s6
	syscall
	
	move $t4, $s5 # temp s6 = (A/B + C mod A -B)
	move $t5, $s6 # temp a
	jal divv
	move $s6, $s0 # final result	
	
	li $v0,4
	la $a0, result
	syscall
	li $v0,1
	move $a0, $s6
	syscall
	
	li $v0,4
	la $a0, remainder
	syscall
	li $v0,1
	move $a0, $s3
	syscall
	
	li $v0,4
	la $a0, exp
	syscall
	
	j end

divv:
	beq $t5, $0, zerodiv
	div $t4, $t5
	mflo $s0
	mfhi $s3
	jr $ra
	
zerodiv:
	li $v0,4
	la $a0, error
	syscall
	
	j end	

end: 
	li $v0, 10
	syscall
	
