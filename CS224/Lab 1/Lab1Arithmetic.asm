# ArithmeticExpression
.data
	inputA: .asciiz "Enter A: "
	inputB: .asciiz "Enter B: "
	inputC: .asciiz "Enter C: "
	remainder: .asciiz "\nRemainder: "
	result: .asciiz "\nResult: "
	part1: .asciiz "\nA/B = "
	part2: .asciiz "\nC Mod A = "
	part3: .asciiz "\nA/B + (C Mod A) - B = "
	error: .asciiz "\nError: Zero division"
	exp: .asciiz "\nExplanation: \"(A/B + (C Mod A)-B)/A\" is calculated."
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
	
	li $v0,4
	la $a0, inputC
	syscall
	li $v0, 5
	syscall
	move $s4, $v0 #C
	
	li $s0, 0 # result 
	li $s3, 0 # remainder
	
	move $t4, $s1 # a for temp
	move $t5, $s2 # b for temp
	
	jal division # a/b
	move $s7, $s0 #result of a/b
	
	li $v0,4 #TEST
	la $a0, part1
	syscall
	li $v0,1
	move $a0, $s7
	syscall
	
	move $t4, $s4 #temp c
	move $t5, $s1 # temp a
	jal division
	move $s5, $s3 # result of c mod a (take remainder register = s3)
	
	li $v0,4 #TEST
	la $a0, part2
	syscall
	li $v0,1
	move $a0, $s5
	syscall
	
	add $s6, $s7, $s5
	sub $s6, $s6, $s2
	
	li $v0,4
	la $a0, part3
	syscall
	li $v0,1
	move $a0, $s6
	syscall
	
	move $t4, $s6 # temp s6 = (A/B + C mod A -B)
	move $t5, $s1 # temp a
	jal division
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
	
division: #X/Y
	li $t3, 0 # counter
	move $t7, $t4 # keep initial X
	move $t8, $t5 # Keep initial Y
	slt $t0, $0, $t4 
	slt $t1, $0, $t5
	and $t2, $t0, $t1 
	beq $t5, $0, zerodiv
	beq $t2, 1, ppdiv
	or $t2, $t0, $t1
	beq $t2, $0, nndiv
	blt $t4, $0, npdiv
	blt $t5, $0, pndiv
	
ppdiv:
	sub $t4, $t4, $t5
	slt $t6, $t4, $0
	beq $t6, 1, enddiv
	add $t3, $t3, 1
	j ppdiv
	
npdiv:
	add $t4, $t4, $t5
	slt $t6, $0, $t4
	beq $t6, 1, enddiv
	add $t3, $t3, -1
	j npdiv
	
pndiv:
	add $t4, $t4, $t5
	slt $t6, $t4, $0
	beq $t6, 1, enddiv
	add $t3, $t3, -1
	j pndiv
	
nndiv:	
	sub $t4, $0, $t4
	sub $t5, $0, $t5
	j ppdiv
	
enddiv: 
	move $s0, $t3
	mul $t2, $t8, $s0
	sub $s3, $t7, $t2 # remainder
	jr $ra

zerodiv:
	li $v0,4
	la $a0, error
	syscall
	
	j end	

end: 
	li $v0, 10
	syscall
	
