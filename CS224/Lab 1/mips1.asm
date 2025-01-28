    .data
prompt:     .asciiz "Enter a number: "
result_msg: .asciiz "The result is: "
newline:    .asciiz "\n"

    .text
    .globl main

main:
    # Prompt user for input
    li $v0, 4                # syscall for print_string
    la $a0, prompt           # load address of prompt
    syscall

    # Read an integer
    li $v0, 5                # syscall for read_int
    syscall
    move $t0, $v0            # store input in $t0

    # Perform some arithmetic
    addi $t1, $t0, 10        # add 10 to the input
    sub $t2, $t0, 5          # subtract 5 from the input
    mul $t3, $t0, 2          # multiply input by 2
    div $t4, $t0, 2          # divide input by 2
    mflo $t4                  # get the quotient

    # Print results
    li $v0, 4                # syscall for print_string
    la $a0, result_msg       # load address of result_msg
    syscall

    # Print the addition result
    move $a0, $t1            # move result to $a0
    li $v0, 1                # syscall for print_int
    syscall

    li $v0, 4                # print newline
    la $a0, newline
    syscall

    # Print the subtraction result
    move $a0, $t2            # move result to $a0
    li $v0, 1                # syscall for print_int
    syscall

    li $v0, 4                # print newline
    la $a0, newline
    syscall

    # Print the multiplication result
    move $a0, $t3            # move result to $a0
    li $v0, 1                # syscall for print_int
    syscall

    li $v0, 4                # print newline
    la $a0, newline
    syscall

    # Print the division result
    move $a0, $t4            # move result to $a0
    li $v0, 1                # syscall for print_int
    syscall

    # Exit program
    li $v0, 10               # syscall for exit
    syscall
