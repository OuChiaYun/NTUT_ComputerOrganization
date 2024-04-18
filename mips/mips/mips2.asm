
.data
data : .space 800
next_line : .asciiz "\n"
line : .asciiz "line\n"
.text
.main:
#int data[200];
#int answer = 0, num = 0, i = 0;
#s1,s2,s3

	li $s1,0
	li $s2,0
	li $s3,0
	li $t0,0 #i
	li $t1,0 # i *4

loop: 
	slti $t1,$t0,6
	beq $t1,$zero,end_loop
	sll $t1,$t0,2
	sw $zero,data($t1)
	
	
	addi $t0,$t0,1
	j loop
	
	
end_loop:

	li $v0,5
	syscall 

	move $a1,$v0
	la $a2,data


	jal fib

	li $v0,1
	move $a0,$v1
	syscall


	li $v0,10
	syscall

fib:    

	addi $sp, $sp, -12
	sw $a1, 4($sp)
	sw $ra,0($sp)
	sw $a3, 8($sp)

	move $t0,$a1
	sll $t0,$t0,2
	add $t1,$a2,$t0
	lw $t1,0($t1)

	bne $t1,$zero,if_1

	li $t2,1
	beq $a1,$t2,if_2
	li $t2,2
	beq $a1,$t2,if_2
	
	addi $a1,$a1,-1
	
	jal fib
	
	move $a3,$v1
	
	addi $a1,$a1,1
	addi $a1,$a1,-2
	
	jal fib   

	
	add $v1,$v1,$a3
	
	
	addi $a1,$a1,2
	move $t0,$a1
	sll $t0,$t0,2
	add $t1,$a2,$t0
	
	move $t2,$v1
	sw $t2,0($t1) 
	
	li $t3,3
	
	div $v1,$t3
	mfhi $t2
	
	bne $t2,$zero,exit_fib
	
	li $v0,1
	move $a0,$v1
	syscall
	
	li $v0,4
	la $a0,next_line
	syscall
	
	j exit_fib

if_1:

	move $t0,$a1
	sll $t0,$t0,2
	add $t1,$a2,$t0
	lw $t1,0($t1)
	
	li $v0,1
	move $a0,$t1
	syscall
	
	li $v0,4
	la $a0,next_line
	syscall

	
	move $v1,$t1

	j exit_fib
	
if_2:

	move $t0,$a1
	sll $t0,$t0,2
	add $t1,$a2,$t0
	
	li $t2,1
	sw $t2,0($t1) 
	
	li $v1,1
	
	j exit_fib
	
exit_fib:

	
	lw $ra, 0($sp)
	lw $a1, 4($sp) 
	lw   $a3, 8($sp) 
	
	
    	addi, $sp, $sp, 12
	jr $ra

