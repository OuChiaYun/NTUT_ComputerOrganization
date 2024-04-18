    .data
    	under_weight: .asciiz"underweight\n"
	over_weight: .asciiz"overweight\n"
	next_line: .asciiz"\n"
    .text
main:    
loop:

#s s1 = height s2 = weight s3 = bmi

    li $v0,5
    syscall
    move $s1,$v0
#scanf("%d", &height);
    
    li $t1 ,-1
    beq $s1,$t1,exit
#if (height == -1)
#	break;
   
    li $v0,5
    syscall
    move $s2,$v0
#scanf("%d", &weight);

    move $a1,$s1
    move $a2,$s2
    jal calculateBMI
   #    calculateBMI(height, weight);
    move $s3,$v0
   
    move $a0,$s3
    jal printResult
   #printResult(bmi);

    j loop    

calculateBMI:
    move $s1,$a1
    move $s2,$a2
    
    li $t0,10000
    mul $s2,$s2,$t0
    #(weight * 10000)
    mul $s1,$s1,$s1
    #(height * height)
    div $s2,$s1
    mflo $s3
    #int bmi = (weight * 10000) / (height * height);
    
    move $v0,$s3
    #return bmi;
    jr $ra
    
printResult:
    
    li $t0,18
    blt $a0,$t0,b1
    #    if (bmi < 18)
    
    addi $t0,$zero,24
    bgt $a0,$t0,b2
    #else if (bmi > 24)
    
    li $v0,1
    syscall
    
    li $v0,4
    la $a0,next_line
   #printf("%d\n", bmi);
    syscall
    
    jr $ra
    
b1:
    li $v0,4
    la $a0,under_weight
    syscall
    jr $ra
    #printf("%s", "underweight\n");


b2:
    li $v0,4
    la $a0,over_weight
    syscall
    jr $ra
    # printf("%s", "overweight\n");
    
exit:
    li $v0, 10         # °h¥Xµ{§Ç
    syscall
