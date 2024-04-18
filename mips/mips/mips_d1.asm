.data
	underweight : .asciiz "underweight\n"
	overweight : .asciiz "overweight\n"
	next_line : .asciiz "\n"
.text
.main:

    #int height, weight, bmi;
    # s0, s1, s2
    j main_while
main_while:
	li $v0,5
	syscall
	
	add $s0,$zero,$v0
	li $t0,-1
	beq $s0,$t0,main_while_end
	
	li $v0,5
	syscall
	
	add $s1,$zero,$v0
	
	add $a0,$zero,$s0
	add $a1,$zero,$s1
	
	jal calculateBMI
	
	add $a0,$zero,$v0
	
	jal printResult 	
	j main_while
	
main_while_end:
	li $v0,10
	syscall


calculateBMI:
	addi $sp,$sp,-4 
	sw $s0,0($sp)
	li $t0,10000
	
	mul $t0,$a1,$t0
	mul $t1,$a0,$a0
	
	div $t0,$t1
	mflo $s0
	
	add $v0,$zero,$s0
	lw $s0,0($sp)	
	addi $sp,$sp,4 

	jr $ra
	

printResult:
	li $t0,0 # flag
	#add $t3,$zero,$a0
	
	slti $t0,$a0,18
	bne $t0,$zero,p1
	
	
	slti $t0,$a0,25
	beq $t0,$zero,p2
	
	li $v0,1
	add $a0,$zero,$a0
	syscall
	
	li $v0,4
	la $a0,next_line 
	syscall
	
	jr $ra
	
p1:
	li $v0,4
	la $a0,underweight
	syscall
	
	jr $ra
p2:
	li $v0,4
	la $a0,overweight
	syscall
	
	jr $ra
	