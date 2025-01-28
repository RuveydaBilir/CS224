.data:
	nPrompt: .asciiz "Enter size of the matrix (N): "
	fillArr: .asciiz "\nThe array is created"
	menu: .asciiz "\nChoose one of the following actions:\n1)Display the element.\n2)Display row-by-row summation.\n3)Display column-by-column summation.\nEnter your decision: "
	x: .asciiz "\n Enter X:"
	y: .asciiz " Enter Y:"
	contentP: .asciiz "\nContent is: "
	rowSumP: .asciiz "\nRow sum is: "
	colSumP: .asciiz "\nCol sum is: "
	invalid: .asciiz "\nINVALID!"
	
.text:
main:	
	li $v0, 4
	la $a0, nPrompt
	syscall 
	li $v0, 5
	syscall
	move $s1, $v0 # holds n
	
	mul $t1, $t0, $t0 # holds n^2
	mul $t2, $t1, 4 # holds 4*n^2
	
	li $v0, 9
	move $a0, $t2 
	syscall
	
	move $s0, $v0 # holds beginning address
	move $a0, $s1 # n as arg
	jal fillArray
	
	li $v0, 4
	la $a0, fillArr
	syscall 
	
menuLoop:
	li $v0, 4
	la $a0, menu
	syscall 
	li $v0, 5
	syscall
	
	beq $v0, 1, content
	beq $v0, 2, rowSum
	beq $v0, 3, colSum
	j endMain

endMain: 
	li $v0, 10
	syscall
		
content:
	li $v0, 4
	la $a0, x
	syscall 
	li $v0, 5
	syscall
	
	move $a1, $v0 # col num
	
	li $v0, 4
	la $a0, y
	syscall 
	li $v0, 5
	syscall
	
	move $a2, $v0 # row num
	move $a0, $s0 # begin address
	move $a3, $s1 # n
	
	bgt $a1, $a3, err
	bgt $a2, $a3, err
	blt $a1, 1, err
	blt $a2, 1, err
	 
	jal find
	li $v0, 4
	la $a0, contentP
	syscall 
	li $v0, 1
	move $a0, $v1
	syscall
	j menuLoop

err: 
	li $v0, 4
	la $a0, invalid
	syscall
	
	j menuLoop
fillArray: 
	move $t0, $v0 # traverse address
	mul $t1, $a0, $a0 # arr size
	addi $t1, $t1, 1 # arrSize+1
	addi $t2, $0, 1 # i
loop: 
	beq $t2, $t1, endLoop
	sw $t2, 0($t0)
	addi $t2, $t2, 1
	addi $t0, $t0, 4
	j loop

endLoop:
	jr $ra

find:
	#addi $sp, $sp, -24
	#sw $s0, 20($sp)
	#sw $s1, 16($sp)
	#sw $s2, 12($sp)
	#sw $s3, 8($sp)
	#sw $s4, 4($sp)
	#sw $ra, 0($sp)
	
	move $t9, $a0 # begin addr 
	move $t8, $a1 #  x
	move $t7, $a2 # y
	move $t6, $a3 # n
	
	sub $t8, $t8, 1
	sub $t7, $t7, 1
	mul $t8, $t8, $t6
	add $s4, $t8, $t7
	mul $s4, $s4, 4
	add $s4, $s4, $t9
	
	lw $v1, 0($s4)	
	#lw $s0, 20($sp)
	#lw $s1, 16($sp)
	#lw $s2, 12($sp)
	#lw $s3, 8($sp)
	#lw $s4, 4($sp)
	#lw $ra, 0($sp)
	
	#addi $sp, $sp, 24
	jr $ra

rowSum:
	addi $t0, $0, 1 #x
	addi $t1, $0, 1 #y
	addi $t2, $0, 0 #sum
	
rowLoop:
	move $a0, $s0  # begin addr
	move $a1, $t0	#x
	move $a2, $t1	#y
	move $a3, $s1  #n
	
	jal find
	add $t2, $t2, $v1
	addi $t0, $t0, 1
	
	bgt $t0, $s1, check
	bgt $t1, $s1, endRow
	
	j rowLoop
check:
	addi $t0, $0, 1
	addi $t1, $t1, 1
	bgt $t1, $s1, endRow
	
	j rowLoop
endRow:
	li $v0, 4
	la $a0, rowSumP
	syscall 
	li $v0, 1
	move $a0, $t2
	syscall
	j menuLoop	
colSum:
	addi $t0, $0, 1 #x
	addi $t1, $0, 1 #y
	addi $t2, $0, 0 #sum
	move $t3, $s0  # begin addr
	addi $t4, $0, 0 # i
	mul $t6, $s1, $s1

colLoop:	
	beq $t4, $t6, endCol
	lw $t5, 0($t3)
	add $t2, $t2, $t5
	addi $t3, $t3, 4
	addi $t4, $t4, 1
	j colLoop

endCol:
	li $v0, 4
	la $a0, colSumP
	syscall 
	li $v0, 1
	move $a0, $t2
	syscall
	j menuLoop
	
