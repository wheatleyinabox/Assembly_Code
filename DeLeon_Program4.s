# 2D Array Manipulation
# CS 2640
#
# Description: A program that will work with a 2D array, to replace a value, 
# calculate the summation, print the array, or exit the program
#
#	x x x
#	x x x
#	x x x
#	x x x
#	x x x
#
.data
arr: 		.space 60 	# array of 15 ints (4 bytes each) in 5x3 array
space: 		.asciiz " "
newline: 	.asciiz "\n"
sum:		.asciiz "Sum: "
menu:		.asciiz "\nPick one of the following options: \n1) replace values \n2) calculate sum \n3) print 2d array \n4) exit"

	# $t0 = pointer to current beginning of row
	# $t1 = row counter & index
	# $t2 = column counter & index
	# $t3 = pointer to current address to store data
	# $t4 = value to be stored in each array element
	# $t5 = general loop counter

.text
main:		la $t0, arr			# initialize pointer to start of array
		move $t1, $zero			# initialize row counter/index
		li $t4, 5			# put value to be loaded in array in $t4

rowLoop:	move $t2, $zero			# initialize column counter/index
		move $t3, $t0			# initialize col. pointer to 1st element of row

columnLoop:	sw $t4, 0($t3)			# store value in current array element
		addi $t2, $t2, 1		# increment column counter/index by 1
		beq $t2, 5, nextRow		# go to next row if column counter = 5
		addi $t3, $t3, 4		# increment the column pointer
		j columnLoop

nextRow:	addi $t1, $t1, 1		# increment row counter/index by 1
		beq $t1, 3, printArr		# leave row loop if row counter = 3
		add $t0, $t0, 20		# increment the beginning-of-row pointer 
						# by 20 (num of byte in row)
		j rowLoop

printArr:	
		
end:
		li $v0, 10		# code for termination
		syscall			# terminate program run