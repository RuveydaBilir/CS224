.data:
	prompt1: .asciiz "Value to be assigned to Register 1: "
	prompt2: .asciiz "Value to be assigned to Register 2: "
	hex1: .asciiz "\nRegister 1 value in hex: "
	hex2: .asciiz "\nRegister 2 value in hex: "
	dist: .asciiz "\nHamming distance: "
	continue: .asciiz "\nDo you want to continue (enter 1 for YES, 0 for NO): "
	
.text:
main:
	addi $sp, $sp, -16
	
	jal userInput
	sw $v0, 16($sp)
	sw $v1, 12($sp)
	
	addi $a1, $v0, 0 # reg1 value
	addi $a2, $v1, 0 # reg2 value
	
	jal toHex
	sw $v1, 8($sp) #save reg1 hex
	sw $v0, 4($sp) #save reg2 hex
	
	jal calculate
	sw $v1, 0($sp) # save hamming distance
		
	addi $sp, $sp, 16 # clear stack
	
	la $a0, continue
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5 # read integer
	syscall	
	beq $v0, 1, main
	
	#Exit program
	addi $v0, $0, 10
	syscall

userInput:
	la $a0, prompt1
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5 # read integer
	syscall	
	addi $s0, $v0, 0 # assign it to $s0
	la $a0, prompt2
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5 # read integer
	syscall	
	addi $s1, $v0, 0 # assign it to $s0
	# return values:
	addi $v0, $s0, 0
	addi $v1, $s1, 0
	jr $ra
	
toHex:
	la $a0, hex1
	addi $v0, $0, 4
	syscall
	addi $a0, $a1, 0
	addi $v0, $0, 34 # turn in hex
	syscall	
	addi $v1, $v0, 0 
	la $a0, hex2
	addi $v0, $0, 4
	syscall
	addi $a0, $a2, 0
	addi $v0, $0, 34 # turn in hex
	syscall	
	jr $ra
	
calculate:
	xor $s0, $a1, $a2 
	addi $s1, $0, 0 # hamming counter
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal loop
	addi $v1, $s1, 0 # return value
	
	la $a0, dist
	addi $v0, $0, 4
	syscall
	addi $a0, $s1, 0
	addi $v0, $0, 1
	syscall 
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra # return to main

loop:
	beq $s0, 0, exitLoop
	andi $s2, $s0, 1
	beq $s2, 1, increment
	srl $s0, $s0, 1
	j loop

increment:
	addi $s1, $s1, 1
	srl $s0, $s0, 1
	j loop

exitLoop:
	jr $ra