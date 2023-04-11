# Average Calculator
# CS 2640
#
.data
	first: .asciiz "Please enter an integer: "
	next: .asciiz "Please enter another integer: "
	avg: .asciiz "The average of your numbers is: "
.text
main:	
	li $v0, 4		# code for print_str
	la, $a0, first		# str store in print register
	syscall 		# print string
	li $v0, 5		# code for read int
	syscall			# stores int
	move $t0, $v0		# Move int to a temp $t0

	li $v0, 4		# code for print_str
	la, $a0, next		# str store in print register
	syscall 		# print string
	li $v0, 5		# code for read int
	syscall			# stores int
	move $t1, $v0		# Move int to a temp $t1

	li $v0, 4		# code for print_str
	la, $a0, next		# str store in print register
	syscall 		# print string
	li $v0, 5		# code for read int
	syscall			# stores int
	move $t2, $v0		# Move int to a temp $t2

	li $v0, 4		# code for print_str
	la, $a0, next		# str store in print register
	syscall 		# print string
	li $v0, 5		# code for read int
	syscall			# stores int
	move $t3, $v0		# Move int to a temp $t3

	li $v0, 4		# code for print_str
	la, $a0, next		# str store in print register
	syscall 		# print string
	li $v0, 5		# code for read int
	syscall			# stores int
	move $t4, $v0		# Move int to a temp $t4

	add $t1, $t0, $t1
	add $t1, $t2, $t1	# adding int together
	add $t1, $t3, $t1
	add $t1, $t4, $t1
	li $t6, 5		# loads a temp $t6 with int 5
	div $t1, $t6		# divides
	mflo $t1		# keeps the quotient & stores in $t5

	li $v0, 4		# code for print_string
	la $a0, avg		# str avg in print register
	syscall			# print string
	li $v0, 1		# code for print_int
	move $a0, $t1		# move sum to print register
	syscall			# print sum

	li $v0, 10		# code for termination
	syscall			# terminate program
.end