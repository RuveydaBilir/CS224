# Recursive Reverse Linked List
.data:
	sizeInput: .asciiz "Enter the size of the linked list: "
	keyInput: .asciiz "Enter the product key: "
	copiesInput: .asciiz "Enter the number of copies sold: "
	printHeader: .asciiz "\n\nReversed LinkedList:"
	seperator: .asciiz "\n------------------------------"
	keyLabel: .asciiz "\nKey: "
	copyLabel: .asciiz "\nNumber of copies sold: "
	
.text:

main: 
	la $a0, sizeInput
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	addi $a0, $v0, 0 # a0 now holds the size of the linkedlist as argument
	
	blt $a0, 1, main # dont let 0 to be an input
	
	jal createLinkedList
	addi $a0, $v0, 0 # pass this argument to print linkedList
	jal printLinkedList
	
	addi $v0, $0, 10
	syscall
	
createLinkedList:
	addi	$sp, $sp, -28
	sw	$s0, 24($sp) # total node number
	sw	$s1, 20($sp) # node counter 
	sw	$s2, 16($sp) # front ptr
	sw	$s3, 12($sp)  # head addr
	sw	$s4, 8($sp) # key value
	sw 	$s5, 4($sp) # copy num
	sw	$ra, 0($sp)
	
	addi	$s0, $a0, 0	# Node number
	addi	$s1, $0, 1	# $s1: Node counter

	addi	$a0, $0, 16 # 4 bit - hold key, 4 bit-hold copy num, 4-bit next, 4bit - prev
	addi	$v0, $0, 9 # dynamically allocate 16 bit in memory
	syscall

	addi	$s2, $v0, 0 # will traverse the list
	addi    $s3, $v0, 0 # will keep the prev addr
	#addi    $s4, $v0, 0 # will hold the head ptr
	
	# create first node
	la $a0, keyInput
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	
	addi $s4, $v0, 0 # keep the value of key
	la $a0, copiesInput
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	addi $s5, $v0, 0 # keep the value of copy num
	
	sw $s4, 0($s2)
	sw $s5, 4($s2)
	sw $zero, 12($s2) # set prev as nullptr
	j addNode

addNode:
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1
		
	addi	$a0, $0, 16 		
	addi	$v0, $0, 9
	syscall
	sw	$v0, 8($s2)

	addi	$s2, $v0, 0	# $s2 now points to the new node.
	
	la $a0, keyInput
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	addi $s4, $v0, 0 # keep the value of key
	
	la $a0, copiesInput
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	addi $s5, $v0, 0 # keep the value of copy num
	
	sw $s4, 0($s2)
	sw $s5, 4($s2)
	sw $s3, 12($s2) # set prev ptr
	
	addi $s3, $s2, 0 # will now hold the value of cur s2 for the next traversal
	j addNode
	
allDone:
	sw	$zero, 8($s2) # set next of the last element as null ptr
	addi	$v0, $s3, 0	# return the last ptr
	
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
	
printLinkedList:
	addi	$sp, $sp, -24
	sw	$a0, 20($sp)
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	
	addi $s0, $a0, 0
	bne $s0, $zero, printCont
	# nothing to return
	addi $sp, $sp, 24 # restore sp
	jr	$ra

printCont: 
	lw $s1, 12($s0) # prev addr
	lw $s2, 0($s0) # key
	lw $s3, 4($s0) # copy num
	la $a0, seperator
	addi $v0, $0, 4
	syscall
	
	la $a0, keyLabel
	addi $v0, $0, 4
	syscall
	addi	$a0, $s2, 0 
	addi	$v0, $0, 1
	syscall
	
	la $a0, copyLabel
	addi $v0, $0, 4
	syscall
	addi	$a0, $s3, 0
	addi	$v0, $0, 1
	syscall
	
	addi $a0, $s1, 0
	jal printLinkedList
	
	lw	$ra, 0($sp) # restore items
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	lw	$a0, 20($sp)
	addi	$sp, $sp, 24
	jr $ra

