.data
array : .space 20
next_line :.asciiz "\n"
.text
.main:

	li $t0,0 #i = 0
	li $t1,0 #i flag
	la $s0,array
loop_1:
	
	# t1 unuse
	slti $t1,$t0,5 
	beq $t1,$zero,end_loop_1 
	
	li $v0,5
	syscall
	
	sll $t1,$t0,2
	add $t1,$s0,$t1
	sw $v0,0($t1)
	
	addi $t0,$t0,1
	
	j loop_1

end_loop_1:

	la $a0,array
	li $a1,5
	
	jal insertionSort
	
	li $t0,0 #i = 0
	li $t1,0 # i flag
loop_2:
	
	sll $t1,$t0,2
	add $t1,$s0,$t1
	
	lw $t2,0($t1)
	
	li $v0,1
	move $a0,$t2
	syscall
	
	li $v0,4
	la $a0,next_line
	syscall
	
	addi $t0,$t0,1
	slti $t1,$t0,5 
	beq $t1,$zero,end_loop_2
	j loop_2

end_loop_2:
	li $v0,10
	syscall
	

insertionSort:

	addi $sp,$sp,-8
	sw $s0,0($sp)
	sw $s1,4($sp)
	
	li $t2,1 # i
	li $t3,0 #end i flag
	j  insertionSort_loop
	
insertionSort_loop:
	slt $t3,$t2,$a1
	beq $t3,$zero,insertionSort_loop_end
	sll $t3,$t2,2
	add $t3,$a0,$t3
	
	lw $s0,0($t3) #current
	
	subi $s1,$t2,1 # $t4  = j
	
	li $t5,0 #end j flag, end array[j] > current
	j insertionSort_while

insertionSort_while:

	slti $t5,$s1,0
	bne $t5,$zero,insertionSort_loop_2

	sll $t5,$s1,2
	add $t5,$a0,$t5
	
	move $t6,$t5 #t6 = &array[j]
	
	lw $t5,0($t5) #t5 = array[j]
	
	slt $t1,$t5,$s0
	
	bne $t1,$zero,insertionSort_loop_2 #array[j] > current
	beq $t5,$s0,insertionSort_loop_2 #array[j] > current
	
	sw $t5,4($t6) #array[j + 1] = array[j];
	subi $s1,$s1,1
	
	j insertionSort_while
	
insertionSort_loop_2:
	addi $t4,$s1,1
	
	move $t1,$a0
	
	li $v0,1
	move $a0,$t4 #printf("%d\n", j + 1);
	syscall
	
	li $v0,4
	la $a0,next_line
	syscall
	
	move $a0,$t1
	
	sll $t4,$t4,2
	add $t4,$a0,$t4
	
	sw $s0,0($t4) #array[j + 1] = current;
	
	addi $t2,$t2,1
	
	j insertionSort_loop
	
	
insertionSort_loop_end:

	lw $s0,0($sp)
	lw $s1,4($sp)
	addi $sp,$sp,8

	jr $ra
