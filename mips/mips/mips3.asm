.data
array : .space 20
next_line :.asciiz "\n"
k_line : .asciiz "kkkk\n"
.text
.main:

	li $t0,0 #i = 0
	li $t1,0 #i flag

loop_1:
	
	# t1 unuse
	slti $t1,$t0,5 
	beq $t1,$zero,end_loop_1 
	
	li $v0,5
	syscall
	
	sll $t1,$t0,2
	sw $v0,array($t1)
	
	addi $t0,$t0,1
	
	j loop_1

end_loop_1:

	la $a1,array
	li $a2,5
	
	jal insertionSort
	
	li $t0,0 #i = 0
	li $t1,0 # i flag
loop_2:
	
	sll $t1,$t0,2
	lw $t2,array($t1)
	
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
	move $t0,$a1 #array
	move $t1,$a2 #length
	
	li $t2,1 # i
	li $t3,0 #end i flag
	j  insertionSort_loop
	
insertionSort_loop:
	slt $t3,$t2,$t1
	beq $t3,$zero,insertionSort_loop_end
	#t3 unuse
	
	sll $t3,$t2,2
	add $t3,$t0,$t3
	lw $t3,0($t3) #current
	
	subi $t4,$t2,1 # $t4  = j
	
	li $t5,0 #end j flag, end array[j] > current
	j insertionSort_while

insertionSort_while:

	bltz $t4,insertionSort_loop_2 #j >= 0
	#t5 unuse
	
	sll $t5,$t4,2
	add $t5,$t0,$t5
	move $t6,$t5 #t6 = &array[j]
	lw $t5,0($t5) #t5 = array[j]
	
	ble $t5,$t3,insertionSort_loop_2 #array[j] > current
	sw $t5,4($t6) #array[j + 1] = array[j];
	
	subi $t4,$t4,1
	
	j insertionSort_while
	
insertionSort_loop_2:
	addi $t4,$t4,1
	
	li $v0,1
	move $a0,$t4 #printf("%d\n", j + 1);
	syscall
	
	li $v0,4
	la $a0,next_line
	syscall
	
	sll $t4,$t4,2
	add $t4,$t0,$t4
	
	sw $t3,0($t4) #array[j + 1] = current;
	addi $t2,$t2,1
	
	j insertionSort_loop
	
	
insertionSort_loop_end:

	jr $ra



	
	
	
	
	
	

		
	



