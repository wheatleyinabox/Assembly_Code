# 2D Array Manipulation PART 2
# CS 2640
#
# Description: A program that will create a 2D array (10x3) for [string, int, int] to hold a record.
# Each will be read in by the user and then printed out in an organized matter. A menu will allow for swap information between records or to exit.
#
#	strArr: [name1, name2, name3, name4, name5, name6, name7, name8, name9, name10]
#	intArr: [age1, age2, age3, age4, age5, age6, age7, age8, age9, age10]
#	        [ID1, ID2, ID3, ID4, ID5, ID6, ID7, ID8, ID9, ID10]
#
#
.data
	intArr:		.space 80		# 20 ints, 4 bytes each (80)
	strArr:		.space 410 		# 10 strings, 40 chars max length + null char (410)

	newline: 	.asciiz "\n"
	space: 		.asciiz " "
	colon:		.asciiz ": "

	prefix:		.asciiz "Record "
	inputNames:	.asciiz "Enter in the names for 10 students: "
	inputAgeID:	.asciiz "Enter the age for 10 students: "
	menuPrompt:	.asciiz "Menu: \n1) Swap 2 records \n2) Exit \nChoose one of the above options: \n"
	swapONE:	.asciiz "Enter 1st record number: "
	swapTWO:	.asciiz "Enter 2nd record number: "
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
#	1  2  3  4  5  6  7  8  9  10
#
#	ii, ii, ii, ii, ii, ii, ii, ii, ii, ii
#	1    2   3   4   5   6   7   8   9  10
#
# Registers:
#	
#	filler
#
swap:
		li $v0, 10				# code for termination
		syscall					# terminate program run	

#------------------------------------------------------------------------------------------------------------------------

end:
		li $v0, 10				# code for termination
		syscall					# terminate program run
