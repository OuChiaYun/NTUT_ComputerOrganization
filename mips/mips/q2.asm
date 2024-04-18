.data
	data: .space 800
	next_line : .asciiz "\n"
	line : .asciiz "line\n"
	hh_line : .asciiz "hh_line\n"
	kk_line : .asciiz "kkk_line\n"

.text
.main:
	#int data[200]; s0
	#int answer = 0, num = 0, i=0;    s1,s2,s3
	
	la $s0,data
	li $s1,0
	li $s2,0
	li $s3,0
loop:

	sll $t0,$s3,6
	sw $zero,0($s0)
	
	slti $t0,$s3,6 #(t0 == 1 if  s3<200)
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
	
	move $s3,$v0
	li $v0,1
	move $a0,$s3
	syscall
	
	li $v0,4
	la $a0,next_line
	syscall
	
	j exit_all
	


fib:
	addi $sp,$sp,-16 #(ra,a0,a1,v0)
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	sw $v0,12($sp)
	
	sll $t0,$a0,2
	add $t0,$a1,$t0
	lw $t0,0($t0)
	
	bne $t0,$zero,L1
	
	li $t1,1
	beq $a0,$t1,L2
	li $t1,2
	beq $a0,$t1,L2
	
	addi $a0,$a0,-1
	
	jal fib ################### n-1
	
	addi $sp,$sp,16 ### n
	
	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $a1,8($sp)
	sw $v0,12($sp) #### vo(n-1) => return to v0 (n)
	
	addi $a0,$a0,-2
	
	jal fib ###################### n-2
	
	
	addi $sp,$sp,16
	lw $ra,0($sp)   ##### n
	lw $a0,4($sp)
	lw $a1,8($sp)
	lw $t1,12($sp) #### n-2
	
	
	sll $t0,$a0,2
	add $t0,$a1,$t0
	
	add $t1,$t1,$v0
	sw $t1,0($t0)
	
	li $t0,3
	div $t1,$t0
	mfhi $t2
	move $v0,$t1
	
	beq $t2,$zero,L3
	
	jr $ra
	
	

L1:

	move $t1,$a0
	
	li $v0,1
	move $a0,$t0
	syscall
	
	li $v0,4
	la $a0,next_line
	syscall
	
	move $a0,$t1
	
	move $v0,$t0
	
	jr $ra
	
L2:
	sll $t0,$a0,2
	
	add $t0,$a1,$t0
	
	li $t1,1
	sw $t1,0($t0)
	
	li $v0,1
	
	jr $ra
L3:


	move $t2,$a0
	
	li $v0,1
	move $a0,$t1
	syscall
	
	li $v0,4
	la $a0,next_line
	syscall
	
	move $a0,$t2
	
	move $v0,$t1
	jr $ra

	
exit_all:
	li $v0,10
	syscall
