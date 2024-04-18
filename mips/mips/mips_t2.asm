.data
    myArray:  .space 800
    newLine: .asciiz "\n"
.text
    main:

    add $s0,$zero, $0 #answer = 0
    add $s1,$zero,$zero #num = 0
    li $s3,0            # i = 0

    la $s4,myArray #data[200]

    forInMain:

       slti $at,$s3,200
       beq $at,$zero,exitForInMain

       sll $t0,$s3,2
       add $t0,$t0,$s4
       sw $zero,0($t0)

       addi $s3,$s3,1
       j forInMain
    exitForInMain:

    # Read the number from the user.  
    li $v0, 5
    syscall
    
    add $s1,$v0,$0
    
    # Call the factorial function
    add $a0,$s1,$0
    add $s1,$v0,$0
    add $a1,$s4,$0
    jal  fib
    
    add $s0,$v0,$0

    # Display the results    
    li $v0, 1
    add $a0,$s0,$0
    syscall

    la $a0,newLine
    li $v0,4
    syscall

  # Tell the system that the program is done.
  li $v0, 10
  syscall

   fib:
           sub  $sp, $sp, 12
           sw    $ra, 0($sp)
           sw    $s0, 4($sp)
           sw    $s1, 8($sp)     

           add $s0,$a0,$0
           
           # Base Case: already have value in myArray
           sll $t0,$s0,2
           add $t0,$t0, $a1
           lw $t0, 0( $t0)

           beqz $t0, L1
           
           li $v0, 1
           add $a0,$t0,$0
           syscall
           
          la $a0,newLine
          li $v0,4
          syscall

           add $v0,$t0,$0
           j fibDone
           
            L1:    
           # Base Case: parameter  is 1 or 2
           beq $s0, 1, skip   
           li $t0, 1          
           j end              
           		skip:
           li $t0, 0
           		end:
           
           beq $s0, 2, skip2 
           li $t1, 1        
           j end2              
           		skip2:
           li $t1, 0
           		end2:
           		
           and $t0, $t0, $t1
           beq $t0,1,L2
           
           sll $t0,$s0,2
           add $t0,$t0, $a1
           li $t1,1
           sw $t1,0($t0)
           li $v0,1
           j fibDone

          L2:
           # Recursive Case: findFibonacci (theNumber - 1)
           sub $a0, $s0, 1
           jal fib
           add $s1, $v0, $0
           
           # Recursive Case: findFibonacci (theNumber - 2)
           sub $a0, $s0, 2
           jal fib
           
           #calculate!
          add $t1, $s1, $v0
          #save result in array
          sll $t0,$s0, 2
          add $t0, $a1, $t0
          sw $t1, 0( $t0 )
          
          li $t2,3
          div $t1,$t2
          
          mfhi $t2
          bne $t2,$zero, L3
          
          add $a0,$t1,$0
          li $v0,1
          syscall
          la $a0,newLine
          li $v0,4
          syscall
          
           L3:

          add $v0,$t1,$0
            
          fibDone:
           lw   $ra, 0($sp)
           lw   $s0,  4( $sp)
           lw    $s1, 8($sp)
           add  $sp, $sp, 12
           jr $ra