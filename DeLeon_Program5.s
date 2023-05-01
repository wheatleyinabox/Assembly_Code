# 2D Array Manipulation PART 2
# CS 2640
#
# Description: A program that will create a 2D array (10x3) for [string, int, int] to hold a record.
# Each will be read in by the user and then printed out in an organized matter. A menu will allow for swap information between records or to exit.
#
#	strArr: [name1, name2, name3, name4, name5, name6, name7, name8, name9, name10]
#	intArr: [age1, ID1, age2, ID2, age3, ID3, age4, ID4, age5, ID5, age6, ID6, age7, ID7, age8, ID8, age9, ID9, age10, ID10]
#
#
.data
	newline: 	.asciiz "\n"
	space: 		.asciiz " "
	colon:		.asciiz ": "

	prefix:		.asciiz "Record "
	inputNames:	.asciiz "Enter in the names for 10 students: "
	inputAgeID:	.asciiz "Enter the [age, ID] for 10 students: "
	menuPrompt:	.asciiz "Menu: \n1) Swap 2 records \n2) Exit \nChoose one of the above options: \n"
	swapONE:	.asciiz "Enter 1st record number: "
	swapTWO:	.asciiz "Enter 2nd record number: "

	.align 2
	intArr:		.space 80		# 20 ints, 4 bytes each (80)
	strArr:		.space 410 		# 10 strings, 40 chars max length + null char (410)
#
# Registers:
#	$t0 <- general loop counter / str counter
#	$t1 <- int counter
#	$t2 <- record counter
#
.text
main:	# call methods
		li $t0, 0				# load $t0 <- 0
		li $t1, 0				# load $t1 <- 0
		li $t2, 1				# load $t2 <- 1

		jal store				# call store subroutine
		sll $0, $0, 0				# no-op

		li $v0, 4				# code for print_str
		la $a0, newline				# $a0 <- newline
		syscall					# print str

		li $t0, 0				# load $t0 <- 0

		jal print				# call print subroutine
		sll $0, $0, 0				# no-op
		
		# reset all values
		li $t0, 0				# load $t0 <- 0
		li $t1, 0				# load $t1 <- 0
		li $t2, 1				# load $t2 <- 1

		j menuLoop				# go to 'menuLoop'
menuLoop:	
		li $v0, 4				# code for print_str
		la $a0, newline				# $a0 <- newline
		syscall					# print newline

		li $v0, 4				# code for print_str
		la $a0, menuPrompt			# $a0 <- menuPrompt
		syscall					# print str

		la $v0, 5				# code for read_int
		syscall					# read int
		beq $v0, 2, end				# if input = 2, end
		beq $v0, 1, swap			# if input = 1, swap

		j menuLoop				# loop
return:
		jr $ra					# return to main
		sll $0, $0, 0				# no-op

#------------------------------------------------------------------------------------------------------------------------
#
# Registers:
#	$t0 <- str / int counter
#
store:
		li $v0, 4				# code for print_str
		la $a0, inputNames			# $a0 <- inputNames
		syscall					# print str

		li $v0, 4				# code for print_str
		la $a0, newline				# $a0 <- newline
		syscall					# print str

		readStrs:
			beq $t0, 410, printIntPrompt	# if count = strings.length, go to 'printIntPrompt'

			li $v0, 8			# code for read_str
			la $a0, strArr($t0)		# store str in strings($t0)
			la $a1, 41			# numberOfChars + 1
			syscall				# store str
		
			addi $t0, $t0, 41		# increment count (str)

			j readStrs			# loop

		printIntPrompt:
			li $v0, 4			# code for print_str
			la $a0, newline			# $a0 <- newline
			syscall				# print str

 			li $v0, 4			# code for print_str
			la $a0, inputAgeID		# $a0 <- inputAgeID
			syscall				# print str

			li $v0, 4			# code for print_str
			la $a0, newline			# $a0 <- newline
			syscall				# print str

			j resetCount			# go to 'resetCount'			

		resetCount:
			li $t0, 0			# set $t0 = 0
			j readAgeID			# go to 'readAgeID'

		readAgeID:
			beq $t0, 80, return   		# if count = integers.length, return to main

			li $v0, 5			# code for read_int
			syscall				# store int

			sw $v0, intArr($t0)		# move int in integers($t0)
			add $t0, $t0, 4			# increment count (int)

			j readAgeID			# loop

#------------------------------------------------------------------------------------------------------------------------
#
# Registers:
#	$t0 <- str counter
#	$t1 <- int counter
#	$t2 <- record counter
#
print:	
		beq $t0, 410, return			# if $t0 = strings.length, return to main
		beq $t1, 80, return			# if $t1 = integers.length, return to main
	
		li $v0, 4				# code for print_str
		la $a0, prefix				# $a0 <- prefix
		syscall					# print str

		li $v0, 1				# code for print_int
		move $a0, $t2				# $a0 <- count
		syscall					# print int

		li $v0, 4				# code for print_str
		la $a0, colon				# $a0 <- colon
		syscall					# print str

		li $v0, 4				# code for print_str
		la $a0, strArr($t0)			# $a0 <- strings($t0)
		syscall					# print str

		li $v0, 4				# code for print_str
		la $a0, space				# $a0 <- space
		syscall					# print space

		li $v0, 1				# code for print_int
		lw $a0, intArr($t1)			# $a0 <- integers($t1)
		syscall					# print int

		addi $t1, $t1, 4			# increment count (int)

		li $v0, 4				# code for print_str
		la $a0, space				# $a0 <- space
		syscall					# print space

		li $v0, 1				# code for print_int
		lw $a0, intArr($t1)			# $a0 <- integers($t1)
		syscall					# print int

		li $v0, 4				# code for print_str
		la $a0, newline				# $a0 <- newline
		syscall					# print newline

		addi $t1, $t1, 4			# increment count (int)		
		addi $t0, $t0, 41			# increment count (str)
		addi $t2, $t2, 1			# increment count (record)

		j print					# loop
		
#------------------------------------------------------------------------------------------------------------------------
#
# Visualization:
#
#	s, s, s, s, s, s, s, s, s, s
#	0  1  2  3  4  5  6  7  8  9
#
#	ii, ii, ii, ii, ii, ii,  ii,  ii,  ii,  ii
#	01  23  45  67  89  1011 1213 1415 1617 1819
#	0/4, 8/12, 16/20, 24/28, 32/36, 40/44, 48/52, 56/60, 64/68, 72/76
#
# Registers:
#
#	$s0 <- record num 1 
#	$s1 <- record num 2
# 	$s2 <- 1
#   $s3 <- 4
#	$s4 <- 40
# 	$s5 <- intArr address
# 	$s6 <- strArr address
#
#	$s7 - $ra
#
#	$t3 <- index int
#	$t4 <- index int
#	$t5 <- index str
#	$t6 <- index str
#	$t7 <- temp $s to swap
#	$t8 <- temp $s to swap
#
swap:
		add $s7, $zero, $ra			# save $ra

		li $v0, 4				# code for print_str
		la $a0, newline				# $a0 <- newline
		syscall					# print newline
		
		li $v0, 4				# code for print_str
		la $a0, swapONE				# $a0 <- swapONE
		syscall					# print swapONE

		li $v0, 5				# code for read_int
		syscall					# $a0 <- input
		move $v0, $s0				# $s0 <- record num 1

		li $v0, 4				# code for print_str
		la $a0, newline				# $a0 <- newline
		syscall					# print newline
		
		li $v0, 4				# code for print_str
		la $a0, swapTWO				# $a0 <- swapTWO
		syscall					# print swapTWO

		li $v0, 5				# code for read_int
		syscall					# $a0 <- input
		move $v0, $s1				# $s1 <- record num 2

		li $s2, 1				# $s2 <- 1
		sub $s0, $s0, $s2			# $s0 - 1
		sub $s1, $s1, $s2       		# $s1 - 1

		li $s3, 4				# $s3 <- 4
		li $s4, 40				# $s4 <- 40
		la $s5, intArr				# $s5 <- intArr address
		la $s6, strArr				# $s6 <- strArr address

#======================================================================================

		mult $s0, $s4		    		# $t5 <- index str
		mflo $t5
		mult $s1, $s4				# $t6 <- index str
		mflo $t6

		add $t5, $t5, $s6			# address + index str
		add $t6, $t6, $s6			# address + index str

		lw $t7, ($t5)				# $t7 <- value @ strArr[]
		lw $t8, ($t6)				# $t8 <- value @ strArr[]

		sw $t7, ($t6)				# swap
		sw $t8, ($t5)				# swap

#======================================================================================

		# mult $s0, $s3 			# $t0 <- index int
		# mflo $t3
		# mult $s1, $s3				# $t1 <- index int
		# mflo $t4



#======================================================================================

		jal print				# go to 'print'
		li $ra, 0				# clear $ra

		add $ra, $zero, $s7			# load with proper $ra

		jr $ra					# return to main

#------------------------------------------------------------------------------------------------------------------------

end:
		li $v0, 10				# code for termination
		syscall					# terminate program run
