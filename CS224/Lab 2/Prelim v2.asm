.data:
	userPrompt: .asciiz "Enter the size of the array: "
	enter: .asciiz "Enter a positive integer: "
	arrPrompt: .asciiz "Array is: "
	space: .asciiz " "
	newLine: .asciiz "\n"
	freqTable: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		# Defined in data segment and assume that it is only accessible by Main (its address will be passed to FindFreq).
		# FreqTable 1st word contains the number times the number 0 appears in the array
		# FreqTable 10th word contains the number times the number 9 appears in the array
		# FreqTable 11th word contains the number times any number other than 0 to 9 appears in the array
	
.text:
main:
	jal createArray
	lw $a1, 4($sp) # get arr addr
	lw $a2, 0($sp) # get size
	la $a3, freqTable # get addr of freq table
	addi $sp, $sp, 24 # clear stack
	jal findFreq
	la $a1, freqTable
	addi $sp, $sp, 20 # clear stack again
	jal printFreqTable
	addi $sp, $sp, 8 # clear stack
	j exitProgram	
	
createArray:
	sw $ra, 0($sp) # save the return address to stack
	addi $sp, $sp, -28 # move stack downwards
	la $a0, userPrompt
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5 # read integer
	syscall
	add $s1, $0, $v0
	mul $a0, $v0, 4 # save the size (1 int = 4 bytes)
	
	addi $v0, $0, 9
	syscall
	
	addi $s0, $v0, 0 # beginning addr
	add $s4, $s0, $a0 # end addr
	addi $s2, $s0, 0
	jal initializeArray
	jal showArray
	la $a0, newLine
	addi $v0, $0, 4
	syscall
	lw $ra, 28($sp) # get the main return address
	addi $v0, $s0, 0 # return array addr
	sw $v0, 4($sp) #save the begin addr of arr
	addi $v1, $s1, 0 # return array size
	sw $v1, 0($sp) # save the size of the arr
	sw $s0, 12($sp) # saving s reg:
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s4, 24($sp)
	jr $ra
	
initializeArray:
	sltu $s3, $s2, $s4 #compare addr
	beq $s3, $0, exitFunc
	la $a0, enter
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5 # read integer
	syscall
	blt $v0, 0, initializeArray
	sw $v0, 0($s2)
	add $s2, $s2, 4
	j initializeArray

exitFunc:
	jr $ra
	
showArray:
	add $s2, $s0, 0
	la $a0, arrPrompt
	addi $v0, $0, 4
	syscall
	j loop

loop:
	sltu $s3, $s2, $s4
	beq $s3, $0, exitFunc
	lw $s3, 0($s2)
	addi $v0, $0, 1
	addi $a0, $s3, 0
	syscall
	addi $v0, $0, 4
	la $a0, space
	syscall
	add $s2, $s2, 4
	j loop
	
findFreq:
	sw $ra, 0($sp)
	addi $sp, $sp, -20
	addi $s0, $a1, 0 # arr addr
	addi $s1, $a2, 0 # arr size
	addi $s2, $a3, 0 # freqTemp addr
	addi $s3, $0 , 0# index counter for freq Arr
	addi $s6, $0, 10
	sw $s0, 0($sp) # saving s reg:
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s3, 16($sp)
	j loopFreq
	
loopFreq:
    	slt $s5, $s3, $s6        # Compare index with array size
    	addi $v0, $0, 0          # Initialize frequency count to 0
    	add $s0, $a1, 0          # reset $s0
    	addi $s4, $0, 0 	  # findNum counter (to check array size)
    	beq $s5, $0, lastElement # Exit if all elements are processed
    	jal findNum              # Call findNum 
    	sw $v0, 0($s2)           # Store the result in freq array
    	addi $s2, $s2, 4         # Increment pointer to next element in freq array
    	addi $s3, $s3, 1         # Increment index counter
    	j loopFreq
	
findNum:
	beq $s4, $s1, exitFunc
	lw $s5, 0($s0)
	beq $s5, $s3, increment
	addi $s0, $s0, 4
	addi $s4, $s4, 1
	j findNum

increment:
	addi $v0, $v0, 1
	addi $s0, $s0, 4
	addi $s4, $s4, 1
	j findNum
	
lastElement:
	lw $ra, 20($sp)
	beq $s4, $s1, exitFunc
	lw $s5, 0($s0)
	bgt $s5, 9, incrementLast
	addi $s0, $s0, 4
	addi $s4, $s4, 1
	j lastElement

incrementLast:
	addi $v0, $v0, 1
	addi $s0, $s0, 4
	addi $s4, $s4, 1
	sw $v0, 0($s2)
	j lastElement

printFreqTable:
	addi $s0, $a1, 0 #begin addr
	addi $s2, $0, 11 #size
	mulu $s1, $s2, 4
	add $s2, $s1, $a1 # end addr
	addi $sp, $sp, -8
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	j printLoop
	
printLoop:
	sltu $s3, $s0, $s2
	beq $s3, $0, exitFunc
	lw $s3, 0($s0)
	addi $v0, $0, 1
	addi $a0, $s3, 0
	syscall
	addi $v0, $0, 4
	la $a0, space
	syscall
	add $s0, $s0, 4
	j printLoop
	
exitProgram:
	addi $v0, $0, 10
	syscall
