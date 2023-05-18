# 1) Basics:
#
# Type your code here.
lw $t0, 0($s0)
sw $t0, 0($s1)

# 2) Arithmetic expression - add/sub:
#
# Type your code here.
# Do not initialize register values here.
add $t0, $s0, $s1
add $t0, $t0, $s2
sub $s4, $t0, $s3

# 3) Arithmetic expression - add/sub/mult:
#
# Type your code here.
add $s0, $s0, $s1
sub $s2, $s2, $s3
mult $s0, $s2
mflo $s4

# 4) rray of squares - lw/sw:
#
# Type your code here.
# Do not initialize $s0 and $s1 here. 
# Use the + button under the Register display to initialize $s0 and $s1.

# $t1 -> value of $s0
# $t2 -> value of $s1

lw $t1, 0($s0)
mult $t1, $t1
mflo $t2
sw $t2, 0($s1)
addi $s0, $s0, 4
addi $s1, $s1, 4

lw $t1, 0($s0)
mult $t1, $t1
mflo $t2
sw $t2, 0($s1)
addi $s0, $s0, 4
addi $s1, $s1, 4

lw $t1, 0($s0)
mult $t1, $t1
mflo $t2
sw $t2, 0($s1)
addi $s0, $s0, 4
addi $s1, $s1, 4

lw $t1, 0($s0)
mult $t1, $t1
mflo $t2
sw $t2, 0($s1)

# 5) Array of Fibonacci sequence - loop:
#
# Type your code here.
# Do not initialize $s0 and $s1 here. 
# Use the + button under the Register display to initialize $s0 and $s1.

# $t1 <- f(n)
# $t2 <- f(n+1)
# $t3 <- count
# $t4 <- sum
# $t5 <- 1

         ori $t1, $zero, 0
         ori $t2, $zero, 1
         sw $t1, 0($s1)
         addi $s1, $s1, 4 # new arr count
         addi $t3, $t3, 1 # loop count
         sw $t2, 0($s1)
         addi $s1, $s1, 4 # new arr count
         addi $t3, $t3, 1 # loop count
         
         ori $t5, $zero, 8
         sub $s1, $s1, $t5
loop:
         bge $t3, $s0, end
         
         lw $t1, 0($s1)
         lw $t2, 4($s1)
         add $t4, $t1, $t2
         sw $t4, 8($s1)
         
         addi $t3, $t3, 1 # loop count
         addi $s1, $s1, 4 # arr count
         j loop
end:

# 6) Procedure calls: 
#
Main:
      # Type your code here.
      move $a0, $s0
      move $a1, $s1
      jal Sum
      move $s2, $v0
      
      move $a0, $s1
      move $a1, $s0
      jal Dif
      move $s3, $v0
      j End

# Procedure Sum (Do not modify)
Sum:
      add $v0, $a0, $a1
      jr $ra

# Procedure Dif (Do not modify)
Dif:
      sub $v0, $a0, $a1
      jr $ra

End:

# 7) Nested procedures:
#
addi $sp, $zero, 6000   # Assume Stack memory starts at 6000. Do not modify.

# Procedure Main (Do not modify)
Main:
      add $a0, $zero, $s0
      add $a1, $zero, $s1
      
      jal Sum
      
      add $s2, $s0, $s1
      add $s2, $s2, $v0
      
      j End

# Procedure Sum
Sum:
      # Type your code here.
      add $s3, $zero, $ra
      # save return
      
      add $t0, $zero, $s0 # m
      add $t1, $zero, $s1 # n
      # save args into $t0/$t1
      addi $t4, $zero, 1
      
      # int p = Dif(n+1, m-1);
      
      addi $a0, $t1, 1 # n+1
      sub $a1, $t0, $t4 # m-1
      jal Dif
      add $t2, $zero, $v0 # p

      #  int q = Dif(m+1, n-1);
   
      addi $a0, $t0, 1 # m+1
      sub $a1, $t1, $t4 # n-1
      jal Dif
      add $t3, $zero, $v0 # q
      
      # return p + q
      
      add $v0, $t2, $t3
      
      or $ra, $zero, $ra
      add $ra, $zero, $s3
      jr $ra

# Procedure Dif (Do not modify)
Dif:
      sub $v0, $a1, $a0
      jr $ra

End: