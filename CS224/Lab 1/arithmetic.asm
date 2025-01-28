# Arithmetic Expression Lab1
# Ruveyda Bilir
# 22203082

.data:
	inputA: .asciiz "Enter A: "
	inputB: .asciiz "Enter B: "
	inputC: .asciiz "Enter C: "
	output: .asciiz "Result: "
	exp: .asciiz "\nBla bla bla"

.text:
main:
	li $v0, 4
	la $a0, inputA
	syscall
	li $v0, 5
	syscall
	add $s0,$0, $v0
	
	li $v0, 4
	la $a0, inputB
	syscall
	li $v0, 5
	syscall
	add $s1, $0, $v0
	
	li $v0, 4
	la $a0, inputC
	syscall
	li $v0, 5
	syscall
	add $s2, $0, $v0
	
	li $t0, 0
	jal mod
	add $a1, $0, $t0 #a1-> holds  the result of mod operation
	
	li $v0, 4
	move $a0, $a1
	syscall
	
	jal division
	
mod: 	
	blt $s1, $0, modNeg
	blt $0,$s1, modPos
	
	j exitMod
	
modPos:
	sub $t1,$s2,$s0
	add $t0, $t0, 1
	
	slt $t2, $t1, $0
	beq $t2, 1, exitMod
	
	j modPos
	
modNeg:
	sub $t1,$s2,$s0
	add $t0, $t0, 1
	
	slt $t2, $0, $t1
	beq $t2, 1, exitMod
	
	j modNeg	

exitMod: 
	jr $ra
	
division:
	li $v0, 10 #exit
	syscall
	
	
end: 
	li $v0, 10 #exit
	syscall
	
