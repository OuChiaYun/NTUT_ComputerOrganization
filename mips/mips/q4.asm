.data
	A : .space 64
	transposeOfA1: .space 64
	transposeOfA2: .space 64
	next_line :.asciiz "\n"
	space:.asciiz " "
	
.text
.main:
	la $s0,A
	la $s1,transposeOfA1
	la $s2,transposeOfA2
	move $s4,$s0
	move $s5,$s2
	
	move $a0,$s0
	jal inputMatrix
	
	move $a0,$s0
	move $a1,$s1
	li $a2,3

	jal transposeMatrixA1
	
	move $a0,$s4
	move $a1,$s5
	li $a2,3
	jal transposeMatrixA2
	
	move $a0,$s1
	jal OuputMatrix
	
	move $a0,$s2
	jal OuputMatrix
	
	li $v0,10
	syscall
	
inputMatrix:

	li $t0,0 # i
	li $t2,3 #flag = 3
		
	j loop_i	
loop_i:
	
	beq $t0,$t2,end_loop_i
	
	li $t1,0 # j
	
	j loop_j
	
loop_j:
	beq $t1,$t2,end_loop_j
	
	mul $t4,$t0,$t2 # t2 = point to A
			# i *= 3
			
	add $t4,$t4,$t1 #  t4= i*3 + j
	sll $t4,$t4,2   # t4= 4*t4
	
	add $t4,$a0,$t4	
	
	li $v0,5
	syscall 

	sw $v0, 0($t4)
	
	addi $t1,$t1,1
	j loop_j 
	
end_loop_j:
	addi $t0,$t0,1
	j loop_i
	
end_loop_i:
	move $v0,$t3
	jr $ra

#######################################################################
	

transposeMatrixA1:
	li $t0,0 # i

	j transposeMatrixA1_loop_i	
transposeMatrixA1_loop_i:

	beq $t0,$a2,transposeMatrixA1_end_loop_i
	li $t1,0 # j
	j transposeMatrixA1_loop_j
	
transposeMatrixA1_loop_j:
	beq $t1,$a2,transposeMatrixA1_end_loop_j
	
	mul $t4,$t0,$a2 # t2 = point to A
			# i *= 3
	add $t4,$t4,$t1 #  t4= i*3 + j
	sll $t4,$t4,2   # t4= 4*t4
	add $t4,$a0,$t4	
	#move $t5,$v0
	lw $t5, 0($t4) #A[i][j]
	
	mul $t4,$t1,$a2 # t4 = point to A
			# j*= 3
	add $t4,$t4,$t0 #  t4= j*3 + i
	sll $t4,$t4,2   # t4= 4*t4
	add $t4,$a1,$t4	
	
	sw $t5,0($t4)
	
	addi $t1,$t1,1
	j transposeMatrixA1_loop_j 
	
transposeMatrixA1_end_loop_j:

	#syscall
	addi $t0,$t0,1
	j transposeMatrixA1_loop_i
	
transposeMatrixA1_end_loop_i:
	#move $v0,$t7
	jr $ra	

	
	
	
#####################################################################

transposeMatrixA2:
	
	addi $sp,$sp,-12
	sw $s0,0($sp)
	sw $s1,4($sp)
	sw $s2,8($sp)
	
	move $s0,$a0 #  B
	move $s1,$a1 # T
	li $s2,1
	
	j transposeMatrixA2_loop_i
		
transposeMatrixA2_loop_i:

	mul $t7,$a2,$a2
	sll $t7,$t7,2
	add $t7,$a0,$t7

	slt $t0,$s0,$t7
	beq $t0,$zero,transposeMatrixA2_end_loop_i
	
	lw $t0,0($s0)
	sw $t0,0($s1)
	
	slt $t0,$s2,$a2
	beq $t0,$zero,else
	
	sll $t7,$a2,2
	add $s1,$s1,$t7
	addi $s2,$s2,1
	
	addi $s0,$s0,4
	j transposeMatrixA2_loop_i
	
transposeMatrixA2_end_loop_i:
	
	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $s2,8($sp)
	addi $sp,$sp,12
	
	jr $ra

else:

	sub $t7,$a2,1
	mul $t7,$a2,$t7
	sub $t7,$t7,1
	
	sll $t7,$t7,2
	sub $s1,$s1,$t7
	
	li $s2,1
	
	addi $s0,$s0,4
	j transposeMatrixA2_loop_i
#####################################################################


OuputMatrix:
	li $t0,0 # i
	li $t2,3 #flag = 3
	
	#move $t3,$a0 #   $t3 = &A[0][0]
		
	j OuputMatrix_loop_i	
OuputMatrix_loop_i:

	beq $t0,$t2,OuputMatrix_end_loop_i
	li $t1,0 # j
	j OuputMatrix_loop_j
	
OuputMatrix_loop_j:
	beq $t1,$t2,OuputMatrix_end_loop_j
	
	mul $t4,$t0,$t2 # t2 = point to A
			# i *= 3
	add $t4,$t4,$t1 #  t4= i*3 + j
	sll $t4,$t4,2   # t4= 4*t4
	add $t4,$a0,$t4	
	#move $t5,$v0
	lw $t3, 0($t4)
	
	move $t5,$a0
	
	li $v0,1
	move $a0,$t3
	syscall
	
	li $v0,4
	la $a0,space
	syscall
	
	move $a0,$t5
	
	addi $t1,$t1,1
	j OuputMatrix_loop_j 
	
OuputMatrix_end_loop_j:
	move $t3,$a0
	
	li $v0,4
	la $a0,next_line
	syscall
	
	move $a0,$t3
	
	addi $t0,$t0,1
	j OuputMatrix_loop_i
	
OuputMatrix_end_loop_i:
	
	jr $ra
