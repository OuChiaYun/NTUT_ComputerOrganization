.data
    A: .space  36
    transposeOfA1: .space 36
    transposeOfA2: .space 36
.text
    main:
        la $s0,A                #s0 = A[3][3]
        la $s1,transposeOfA1    #s1 = transposeOfA1[3][3]
        la $s2,transposeOfA2    #s2 = transposeOfA2[3][3]

        add $a0,$s0,$0
        jal inputMatrix

        add $a0,$s0,$0
        add $a1,$s1,$0
        li $a2,3
        jal transposeMatrixA1

        add $a0,$s0,$0
        add $a1,$s2,$0
        li $a2,3
        jal transposeMatrixA2

        add $a1,$s1,$0
        jal outputMatrix

        add $a1,$s2,$0
        jal outputMatrix
    
    # Tell the system that the program is done.
    li $v0, 10
    syscall

    inputMatrix:
        # addr = baseAddr + (rowIndex * colSize + colIndex)*datasize
        add $t0,$zero,$0 #i=0
        for1InputMatrix:
            slti $at,$t0,3
            beq $at, $zero,exitfor1InputMatrix
            add $t1,$zero,$0 #j=0
                for2InputMatrix:
                    slti $at,$t1,3
                    beq $at,$zero,exitfor2InputMatrix
                    mul $t4,$t0,3
                    add $t4,$t4,$t1
                    mul $t4,$t4,4
                    add $t4,$t4,$a0

                    li $v0,5
                    syscall

                    sw $v0,0($t4)

                    addi $t1,$t1,1
                    j for2InputMatrix
                exitfor2InputMatrix:
            addi $t0,$t0,1
            j for1InputMatrix
        exitfor1InputMatrix:
    jr $ra

    transposeMatrixA2:
        add $t0,$a0,$0 #ptrB = B
        add $t1,$a1,$0    #ptrT = T
        li $t2,1        # i =1
        forTransposeMatrixA2:
            mul $t3,$a2,$a2
            sll $t3,$t3,2           #t3*=4
            add $t3,$t3,$a0         #t3 = (B + (size * size)
            slt $at,$t0,$t3
            beq $at, $zero,exitForTransposeMatrixA2

            #*ptrT = *ptrB
            lw $t3,0($t0)
            sw $t3,0($t1)

            slt $at,$t2,$a2
            beq $at,$zero,L1
                sll $t3,$a2,2
                add $t1,$t1,$t3     #ptrT += size
                addi $t2,$t2,1      #i++
                j L2
            L1:
                subi $t3,$a2,1
                mul  $t3,$t3,$a2
                subi $t3,$t3,1          #$t3 = (size * (size - 1) - 1)
                sll $t3,$t3,2           #$t3 *= 4
                sub $t1,$t1,$t3         #prtT -= (size * (size - 1) - 1)
                li $t2,1                #i = 1
            L2:
            addi $t0,$t0,4 #ptrB++
            j forTransposeMatrixA2
        exitForTransposeMatrixA2:
    jr $ra
    transposeMatrixA1:
        add $t0,$zero,$0 # i = 0
        for1TransposeMatrixA1:
            slt $at,$t0,$a2
            beq $at,$zero,exitfor1TransposeMatrixA1
            add $t1,$zero, $0 # j = 0
                for2TransposeMatrixA1:
                    slt $at,$t1,$a2
                    beq $at,$zero,exitfor2TransposeMatrixA1

                    mul $t3,$t0,$a2
                    add $t3,$t3,$t1
                    mul $t3,$t3,4
                    add $t3,$t3,$a0 #t3 = A[i][j] address

                    mul $t4,$t1,$a2
                    add $t4,$t4,$t0
                    mul $t4,$t4,4
                    add $t4,$t4,$a1 #t4 = T[i][j] address

                    lw $t5,0($t3)
                    sw $t5,0($t4)

                    addi $t1,$t1,1
                    j for2TransposeMatrixA1
                exitfor2TransposeMatrixA1:
            addi $t0,$t0,1
            j for1TransposeMatrixA1
        exitfor1TransposeMatrixA1:
    jr $ra

    outputMatrix:
        add $t0,$zero,$0
        for1OutputMatrix:
            slti $at,$t0,3
            beq $at,$zero,exitFor1OutputMatrix
            add $t1,$zero,$0
            for2OutputMatrix:
            	slti $at,$t1,3
            	beq $at,$zero,exitFor2OutputMatrix

                mul $t3,$t0,3
                add $t3,$t3,$t1
                mul $t3,$t3,4
                add $t3,$t3,$a1 #t3 = A[i][j] address

                lw $a0,0($t3)
                li $v0,1
                syscall

                # print space, 32 is ASCII code for space
                li $a0, 32
                li $v0, 11  # syscall number for printing character
                syscall

                addi $t1,$t1,1
                j for2OutputMatrix
            exitFor2OutputMatrix:
            #?ç∞?á∫??õË??
            addi $a0, $0, 0xA
            addi $v0, $0, 0xB
            syscall
            addi $t0,$t0,1
            j for1OutputMatrix
        exitFor1OutputMatrix:
    jr $ra