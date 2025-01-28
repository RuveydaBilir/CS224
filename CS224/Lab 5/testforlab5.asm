.text
addi $t0, $zero, 15 

addi $t1, $zero, 2 

addi $t2, $zero, 9 

addi $s0, $zero, 150 

add $t0, $t0, $t0 

or $t3, $t1, $t2 

and $t4, $t1, $t2 

j label

add $t0, $zero, $zero 

label: sw $t0, 0($s0) 

slt $t5, $t2, $t0 

slt $t6, $t0, $t2 

sub $t0, $t2, $t1 

lw $t7, 0($s0) 
