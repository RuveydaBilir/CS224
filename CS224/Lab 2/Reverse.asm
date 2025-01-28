.data:
	userPrompt: .asciiz "Enter the value: "
	hex: .asciiz "Value in hex: "
	continue: .asciiz "\nDo you want to continue? (1 for YES, 0 for NO): " 
	reverse: .asciiz "\nReversed value (in hex): "
	
.text:
main:
	jal getValue 
	addi $a1, $v1, 0 # save the value to the argument register
	jal reverseFunc
	addi $a2, $v1, 0 # save the reverse value
	jal display
	
	la $a0, continue
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	beq $v0, 1, main
	
	addi $v0, $0, 10
	syscall

getValue:
	la $a0, userPrompt
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	add $v1, $0, $v0
	
	la $a0, hex
	addi $v0, $0, 4
	syscall
	addi $a0, $v1, 0
	addi $v0, $0, 34
	syscall
	jr $ra
	
reverseFunc:
	sw $ra, 0($sp)
	addi $s0, $a1, 0
	addi $s1, $0, 0 # reversed value
	addi $s2, $0, 0 # bit counter
	jal loop
	addi $v1, $s1, 0 # return value
	lw $ra, 0($sp)
	jr $ra

loop:
	beq $s2, 31, endLoop
	andi $s3, $s0, 1 #comparitor
	add $s1, $s1, $s3 # add it to reversed value
	srl $s0, $s0, 1
	sll $s1, $s1, 1
	addi $s2, $s2, 1
	j loop

display:
	la $a0, reverse
	addi $v0, $0, 4
	syscall
	addi $a0, $v1, 0
	addi $v0, $0, 34
	syscall
	jr $ra
	
endLoop:
	andi $s3, $s0, 1  # adds final bit (for - numbers)
	add $s1, $s1, $s3
	jr $ra