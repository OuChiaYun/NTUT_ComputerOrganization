.data
	data: .space 800
	next_line : .ascii "\n"
	line : .ascii "line\n"

.text

.main:
	#int data[200]; s0
	#int answer = 0, num = 0, i=0;    s1,s2,s3
	
	la $s0,data
	li $s1,0
	li $s2,0
	li $s3,0
	
loop:

	sll $t0,$s3,4
	sw $zero,0($s0)
	
	slti $t0,$s3,9 #(t0 == 1 if  s3<200)
	beq $t0,$zero,end_loop
	
	addi $s3,$s3,1
	j loop
	
end_loop:
	li $v0,5
	syscall
	
	move $s2,$v0

	move $a0,$s2
	move $a1,$s0

	jal fib
	
	li $v0,10
	syscall
	
	
fib:
	addi $sp,$sp,-16 #$ra,$a0,$a1,$v0
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	sw $v0,12($sp)
	
	move $t3,$a0
	
	li $v0,1
	move $a0,$a0
	syscall
	
	li $v0,4
	la $a0,line
	syscall
	
	move $a0,$t3
	
	sll $t0,$a0,2
	add $t0,$a1,$t0
	lw $t0,0($t0)
	
	bne $t0,$zero,L1 #((dp[n]!= 0))
	
	li $t0,1
	beq $a0,$t0,L2 #((n == 0))
	li $t0,2
	beq $a0,$t0,L2 #(n == 0))
	
	
	sub $a0,$a0,1
	
	jal fib  ########## n-1
	
	lw $t0,12($sp)
	add $t0,$t0,$v0
	sw $t0,12($sp)
	
	sub $a0,$a0,1
	
	jal fib ##############n-2
	

	lw $a0,4($sp)
	lw $ra,0($sp)
	
	addi $sp,$sp,16

	sll $t1,$a0,2
	add $t1,$a1,$t1
	sw $t0,0($t1)
	
	lw $t0,0($t1)
	li $t1,3
	div $t0,$t1
	mfhi $t1
	
	#beq $t1,$zero,L3
	
	move $v0,$t0
	
	jr $ra
	
	
	
	
L1 : 
	move $t1,$a0
	
	li $v0,1
	move $a0,$t0
	#syscall
	
	li $v0,4
	la $a0,next_line
	#syscall
	
	move $a0,$t1
	
	move $v0,$t0 
	
	lw $a0,4($sp)
	lw $ra,0($sp)
	
	addi $sp,$sp,16
	jr $ra
L2 : 

	sll $t0,$a0,2
	add $t0,$a1,$t0
	
	li $t1,1
	sw $t1,0($t0)
	
	move $v0,$t1
	
	lw $a0,4($sp)
	lw $ra,0($sp)
	
	addi $sp,$sp,16
	jr $ra
	
L3:
	move $t3,$a0
	
	li $v0,1
	move $a0,$t0
	syscall
	
	li $v0,4
	la $a0,line
	syscall
	
	move $a0,$t3
	
	move $v0,$t0
	
	lw $a0,4($sp)
	lw $ra,0($sp)
	addi $sp,$sp,16
	jr $ra
