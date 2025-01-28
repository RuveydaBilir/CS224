.data:
	.align 4 # Makes sure that the address array is divisible by 4
	array: .space 400 # ???? NOT SURE!!!
	inputPrompt: .asciiz "Enter the array size: "
	sizeError: .asciiz "ERROR: The array size cannot be more than 100, it is adjusted as 100.\n"
	elementPrompt: .asciiz "Enter the element: "
	menu: .asciiz "\nChoose one action:\n1)Find the maximum number stored in the array and display that number.\n2)Find the number of times the maximum number appears in the array.\n3)Find how many numbers we have (other than the maximum number) that we can divide the maximum number without a remainder.\n4)Quit\nEnter your decision: "
	endPrompt: .asciiz "\nQuitting the program...."
	arrPrompt: .asciiz "\n\nArray is: "
	space: .asciiz " "
	maxNumPrompt: .asciiz "\nMax number in the array: "
	maxCountPrompt: .asciiz "\nNumber of times max number occur in the array: "
	maxDivPrompt: .asciiz "\nCount of numbers that can divide max number: "
	
.text:
main:
	la $s2, array # holds the array address
	li $s0, 100 # max size
	
	li $v0, 4
	la $a0, inputPrompt
	syscall
	li $v0, 5
	syscall
	move $t0, $v0 # array size
	
	li $t1, 0  # i
	add $t7, $0, $s2 # array address counter
	sge $t2, $t0, $s0
	beq $t2, 1, changeSize
	
	j create_array
	
menuLabel:
	jal display
	li $v0, 4
	la $a0, menu
	syscall
	li $v0, 5
	syscall
	
	move $t4, $v0 # user decision	
	add $t7, $s2, $0 # go back to the beginning address of the array
	
	beq $t4, 1, display_max_num
	beq $t4, 2, display_max_count
	beq $t4, 3, display_divider_num
	j end

display:
	li $v0, 4
	la $a0, arrPrompt
	syscall
	
	add $t4, $t0, 0 # loop for display t4 = size (j)
	add $t7, $s2, $0 # go back to the beginning address of the array
	
	j displayLoop

displayLoop:
	
	slt $t2, $0, $t4
	beq $t2, 0, endLoop
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

endLoop: jr $ra

changeSize:
	li $v0, 4
	la $a0, sizeError
	syscall
	li $t0, 100
	j create_array
	
create_array:

	slt $t2, $t1, $t0 # loop
	beq $t2, 0, endCreateArr
	li $v0, 4
	la $a0, elementPrompt
	syscall
	li $v0, 5
	syscall
	move $t3, $v0 

	sw $t3, 0($t7)
	add $t7, $t7, 4
	
	addi $t1, $t1, 1
	j create_array

endCreateArr:
	add $t7, $s2, $0 # go back to the beginning address of the array
	jal find_max_num
	add $t7, $s2, $0 # go back to the beginning address of the array
	jal find_max_count
	add $t7, $s2, $0 # go back to the beginning address of the array
	jal find_divider_num
	sub $s4, $s4, $s3
	j menuLabel
	
find_max_num:
	addi $t1, $t0, 0
	li $s1, 0
	j find_max_num_loop
	
find_max_num_loop:
	slt $t2, $0, $t1
	beq $t2, 0, endLoop
	sub $t1, $t1, 1
	lw $t3, 0($t7)
	addi $t7, $t7, 4
	blt $t3, $s1, find_max_num_loop
	move $s1, $t3
	j find_max_num_loop

display_max_num:
	li $v0, 4
	la $a0, maxNumPrompt
	syscall
	li $v0, 1
	move $a0, $s1
	syscall
	j menuLabel
	
find_max_count:
	addi $t1, $t0, 0
	li $s3, 0
	j find_max_count_loop

find_max_count_loop:
	slt $t2, $0, $t1
	beq $t2, 0, endLoop
	sub $t1, $t1, 1
	lw $t3, 0($t7)
	add $t7, $t7, 4
	bne $t3, $s1, find_max_count_loop
	add $s3, $s3, 1
	j find_max_count_loop
	
display_max_count:
	li $v0, 4
	la $a0, maxCountPrompt
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	
	j menuLabel
find_divider_num:
	addi $t1, $t0, 0
	li $s4, 0 # keeps the divider num
	j find_divider_num_loop
	
find_divider_num_loop:
	slt $t2, $0, $t1
	beq $t2, 0, endLoop
	sub $t1, $t1, 1
	lw $t3, 0($t7)
	add $t7, $t7, 4
	beq $t3, $0, find_divider_num_loop
	div $s1, $t3
	mfhi $t5
	bne $t5, $0, find_divider_num_loop
	add $s4, $s4, 1
	j find_divider_num_loop
	
display_divider_num:
	li $v0, 4
	la $a0, maxDivPrompt
	syscall
	li $v0, 1
	move $a0, $s4
	syscall
	j menuLabel
	
end:
	li $v0, 4
	la $a0, endPrompt
	syscall
	li $v0, 10
	syscall
