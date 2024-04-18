.data
.text

.main:

	addi $a0,$zero,5
	
	jal L1
	
	li $v0,10
	syscall


L1:

	addi $sp,$sp,-8
	sw $a0,0($sp)
	sw $ra,4($sp)
	
	beq $a0,$zero,L2
	
	
	li $v0,1
	add $a0,$zero,$a0
	syscall
	
	lw $a0,0($sp)
	addi $a0,$a0,-1
	jal L1
	
	li $v0,1
	add $a0,$zero,$a0
	syscall
	
	lw $a0,0($sp)
	
	
	jal L2
	
L2:
	lw $ra,4($sp)
	addi $sp ,$sp,8
	lw $a0,0($sp)
	
	jr $ra
	
	
