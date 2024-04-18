.data
data: .space 800
nextLine: .asciiz"\n"

.text
.main:
addi $s0,$zero,0   # $s0 = answer = 0
addi $s1,$zero,0  #  $s1 = num = 0
addi $t0,$zero,0 # $t0 = 0 index

# filled all elements in array data to 0
Loop:
slti $t1,$t0,200
beq $t1,$zero,Scan
sll $t1,$t0,2   #  $t1 = index * 4 
sw $zero,data($t1) # data[i] = 0
addi $t0,$t0,1
j Loop

Scan:
li $v0,5
syscall
move $s1,$v0  # $s1 = num
add $a0,$s1,$zero # $a0 = $s1=num
la $a1,data  # $a1 = array data base address
jal fib
move $s0,$v0
li $v0,1
move $a0,$s0
syscall
li $v0,4
la $a0,nextLine
syscall
 
li $v0,10
syscall

fib:
sll $t0,$a0,2 # $ t0 = n * 4
add $t0,$a1,$t0 # $t0 = base address data[n]
lw $t0,0($t0) # $t0 = data[n]
beq $t0,$zero,StartRecursive
add $t1,$a0,$zero # $t1 = $a0
li $v0,1
move $a0,$t0
syscall
li $v0,4
la $a0,nextLine
syscall
move $v0,$t0
move $a0,$t1
jr $ra

StartRecursive:
addi $t0,$zero,1 # $t0 = 1
addi $t1,$zero,2 # $t1 = 2
beq $a0,$t0,Base # $a0 = 1 go to Recursive
beq $a0,$t1,Base # $a0 = 2 go to Recursive
j Recursive

Base:
sll $t1,$a0,2 # n * 4
add $t1,$a1,$t1 # $t1 = base address + n * 4
sw $t0,0($t1) # data[n] = 1
move $v0,$t0
jr $ra

Recursive:
addi $sp,$sp,-12
 sw $ra,8($sp)
 sw $a0,4($sp)
addi $a0,$a0,-1
jal fib
sw $v0,0($sp) # store f(n-1)
lw $a0 , 4($sp)
addi $a0,$a0,-2
jal fib
lw $t3, 0( $sp ) #  restore f(n-1) = $t3
add $t0,$v0,$t3 # $t0 = f(n-1) + f(n-2)
lw $a0,4($sp)
addi $sp,$sp,8  # $sp point $ra

sll $t1,$a0,2 
add $t1,$a1,$t1 
sw $t0,0($t1)  # $t0 = data[n] = f(n-1) + f(n-2)
addi $t2,$zero,3 # $t2 = 3
divu $t0,$t2  #  $t0 / 3
mfhi $t2 # t2 = t0 % 3
bne $t2,$zero,Return
addi $sp,$sp,-4
sw $a0,0($sp)
li $v0,1
move $a0,$t0
syscall
li $v0,4
la $a0,nextLine
syscall
lw $a0,0($sp)
addi $sp,$sp,4
Return:
lw $ra,0($sp)
move $v0,$t0
addi $sp,$sp,4
jr $ra
