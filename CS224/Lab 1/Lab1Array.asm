# ARRAY Lab1 
# Ruveyda Bilir
# 22203082
.data: 
	.align 4 # Makes sure that the address array is divisible by 4
	array: .space 80
	inputPrompt: .asciiz "Enter the array size: "
	sizeError: .asciiz "ERROR: The array size cannot be more than 20, it is adjusted as 20.\n"
	elementPrompt: .asciiz "Enter the element: "
	displayPrompt: .asciiz "The array is: \n"
	swapPrompt: .asciiz "\n-Swapping- \n"
	space: .asciiz " "

.text:

main: 	
	la $s2, array # save array address to a register
	li $s0, 20 # max size
	li $v0, 4
	la $a0, inputPrompt
	syscall
	
	li $v0, 5 # read integer ????
	syscall
	move $t0, $v0 # size
	li $t1, 0  # i
	add $t7, $0, $s2 # array address counter
	sge $t2, $t0, $s0
	li $s3, 0 # flagh to check if swap operation is visited or not
	beq $t2, 1, changeSize
	j loop

changeSize:
	li $v0, 4
	la $a0, sizeError
	syscall
	li $t0, 20
	j loop
	
loop: 	
	slt $t2, $t1, $t0 # loop
	beq $t2, 0, display
	li $v0, 4
	la $a0, elementPrompt
	syscall
	li $v0, 5
	syscall
	move $t3, $v0 # t3 - holds the temp value before stack ?????????

	sw $t3, 0($t7)
	add $t7, $t7, 4
	
	addi $t1, $t1, 1
	j loop

display:
	li $v0, 4
	la $a0, displayPrompt
	syscall
	
	add $t4, $t0, 0 # loop for display t4 = size (j)
	add $t7, $s2, $0 # go back to the beginning address of the array
	
	j displayLoop

displayLoop:
	
	slt $t2, $0, $t4
	beq $t2, 0, swap ## DONT FORGET TO CHANGE HERE
	add $t4, $t4, -1
	
	lw $t3, 0($t7)
	li $v0, 1
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	add $t7, $t7, 4 # move 4 bytes forward, next address
	j displayLoop

swap: 
	beq $s3, 1, end
	li $v0, 4
	la $a0, swapPrompt
	syscall
	
	li $s3, 1 # flag =1 bc swap is visited
	
	add $t5, $0, $s2 # the first element address of the array
	mul $t9, $t0, 4
	add $t9, $t9, -4
	add $t7, $s2, $t9
	#t6,t8 -> not to lose the variable
	j swapLoop
	
swapLoop: 
	sle $t2, $t5, $t7
	beq $t2, 0, display
	lw $t6, 0($t5)
	lw $t8, 0($t7)
	sw $t8, 0($t5)
	sw $t6, 0($t7)
	
	add $t7, $t7, -4
	add $t5, $t5, 4 

	j swapLoop
	
end: 
	li $v0, 10 #exit
	syscall
