.data
	underweight: .asciiz "underweight\n"
	overweight: .asciiz "overweight\n"
	next_line: .asciiz "\n"
.text
.main:
	# int height, weight, bmi;
	# s0,s1,s2
	j loop	
loop:
	li $v0,5
	syscall 
	
	move $s0,$v0
	
	li $t0,-1
	beq $s0,$t0,end_loop
	
	li $v0,5
	syscall 
	
	move $s1,$v0
	
	move $a0, $s0
	move $a1, $s1

	jal calculateBMI
	
	move $s2,$v0
	
	move $a0,$s2
	
	jal printResult
	j loop
	
	
end_loop:
	li $v0,10
	syscall
	
calculateBMI:	
	addi $sp, $sp, -4 #
	sw $s0, 0($sp)
	
	li $t0,10000
	
	mul $t0,$a1,$t0
	mul $t1,$a0,$a0
	div $s0,$t0,$t1
	
	move $v0,$s0

	lw $s0,0($sp)
	addi $sp,$sp,4
	jr $ra
	
printResult:
	slti $t0,$a0,18 #($t0 == 1 if a0<18)
	bne $t0,$zero,print1 #(t0  < 18)
	
	slti $t0,$a0,25 #($t0 == 1 if a0<25)
	beq $t0,$zero,print2
	
	move $t0,$a0
	
	li $v0,1
	move $a0,$t0
	syscall
	
	li $v0,4
	la $a0,next_line
	syscall
	
	move $a0,$t0
	
	jr $ra
	
	
print1:
	li $v0,4
	la $a0,underweight
	syscall
	jr $ra
	
print2:
	li $v0,4
	la $a0,overweight
	syscall
	jr $ra
	
	
	
	
	
	
	