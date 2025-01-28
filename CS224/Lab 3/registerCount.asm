### Register Count
.data:
	registerInput: .asciiz "\nEnter register number: "
	output: .asciiz "The number of times the selected register used: "
	exitStr: .asciiz "\nExiting the program"
	
.text:

main:
	la $a0, registerInput
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	addi $a0, $v0, 0 # $a0 holds the register num
	blt $a0, 0, exitProgram
	bgt $a0, 31, exitProgram
	
	addi $s0, $0, 0 # wanted reg counter
	
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	la $a1, registerCount
	la $a2, end
	jal registerCount
	
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	j main
	
registerCount:
	slt $s4, $a2, $a1
	beq $s4, 1, exitFunc 
	# s3 holds the current instruction
	lw $s3, 0($a1)
	srl $s1, $s3, 26 # get the opcode
	beq $s1, $0, rType
	addi $s5, $0, 3
	slt $s4, $s5, $s1
	beq $s4, 1, iType
	
	addi $a1, $a1, 4 # move to the next instruction
	
	j registerCount
	
rType:
	srl $s2, $s3, 21 # get the rs register (opcode is already zero)
	andi $s2, $s2, 0x1f # get the lower 5 bits
	bne $s2, $a0, skip 
	addi $s0,$s0, 1
skip:	
	srl $s2, $s3, 16 # get the rt register
	andi $s2, $s2, 0x1f 
	bne $s2, $a0, skip1 
	addi $s0,$s0, 1
skip1:
	
	srl $s2, $s3, 11 # get the rd register
	andi $s2, $s2, 0x1f
	bne $s2, $a0, skip2 
	addi $s0,$s0, 1
skip2:
	
	addi $a1, $a1, 4
	j registerCount
iType:
	srl $s2, $s3, 21 # get the rs register (opcode is already zero)
	andi $s2, $s2, 0x1f # get the lower 5 bits
	bne $s2, $a0, skip3
	addi $s0,$s0, 1
skip3:
	
	srl $s2, $s3, 16 # get the rt register
	andi $s2, $s2, 0x1f 
	bne $s2, $a0, skip4 
	addi $s0,$s0, 1
skip4:
	addi $a1, $a1, 4
	j registerCount
	
exitFunc:
	la $a0, output
	addi $v0, $0, 4
	syscall
	
	addi $a0, $s0, 0
	addi $v0, $0, 1
	syscall
	
end:	jr $ra
	  
exitProgram: 
	la $a0, exitStr
	addi $v0, $0, 4
	syscall

	addi $v0, $0, 10
	syscall