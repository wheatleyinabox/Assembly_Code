# 2D Array Manipulation PART 2
# CS 2640
#
# Description: A program that will create a 2D array (10x3) for [string, int, int] to hold a record.
# Each will be read in by the user and then printed out in an organized matter. A menu will allow for swap information between records or to exit.
#
.data
	newline: 	.asciiz "\n"
	space: 		.asciiz " "
	colon:		.asciiz ": "

	prefix:		.asciiz "Record "
	inputNames:	.asciiz "Enter in the names for 10 students: "
	inputAge:	.asciiz "Enter the age for 10 students: "
	inputID:	.asciiz "Enter the ID for 10 students: "
	menuPrompt:	.asciiz "Menu: \n1) Swap 2 records \n2) Exit \nChoose one of the above options: \n"
	swapONE:	.asciiz "Enter 1st record number: "
	swapTWO:	.asciiz "Enter 2nd record number: "

	.align 2
	ageArr:		.space 40		# 10 ints, 4 bytes each (40)
	IDArr:		.space 40		# 10 ints, 4 bytes each (40)
	strArr:		.space 410 		# 10 strings, 40 chars max length + null char (410)
#
# Registers:
#	$t0 <- general loop counter / str counter
#	$t1 <- age counter
#	$t2 <- ID counter
#	$t3 <- record counter
#
.text
main:	# call methods
		li $t0, 0				# load $t0 <- 0

		jal store				# call store subroutine
		sll $0, $0, 0				# no-op

		li $v0, 4				# code for print_str
		la $a0, newline				# $a0 <- newline
		syscall					# print str
	
		li $t0, 0				# load $t0 <- 0
		li $t1, 0				# load $t1 <- 0
		li $t2, 0				# load $t2 <- 0
		li $t3, 1				# load $t3 <- 1

		jal print				# call print subroutine
		sll $0, $0, 0				# no-op
		
		# reset all values
		li $t0, 0				# load $t0 <- 0
		li $t1, 0				# load $t1 <- 0
		li $t2, 0				# load $t2 <- 0
		li $t3, 1				# load $t3 <- 1

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
			beq $t0, 410, printAgePrompt	# if count = strings.length, go to 'printIntPrompt'

			li $v0, 8			# code for read_str
			la $a0, strArr($t0)		# store str in strings($t0)
			la $a1, 41			# numberOfChars + 1
			syscall				# store str
		
			addi $t0, $t0, 41		# increment count (str)

			j readStrs			# loop

		printAgePrompt:
			li $v0, 4			# code for print_str
			la $a0, newline			# $a0 <- newline
			syscall				# print str

 			li $v0, 4			# code for print_str
			la $a0, inputAge		# $a0 <- inputAge
			syscall				# print str

			li $v0, 4			# code for print_str
			la $a0, newline			# $a0 <- newline
			syscall				# print str

			j resetCountFirst			# go to 'resetCountFirst'			

		resetCountFirst:
			li $t0, 0			# set $t0 = 0
			j readAge			# go to 'readAge'

		readAge:
			beq $t0, 40, printIDPrompt   # if count = integers.length, go to 'printIDPrompt'

			li $v0, 5			# code for read_int
			syscall				# store int

			sw $v0, ageArr($t0)		# move int in integers($t0)
			add $t0, $t0, 4			# increment count (int)

			j readAge			# loop

		printIDPrompt:
			li $v0, 4			# code for print_str
			la $a0, newline			# $a0 <- newline
			syscall				# print str

 			li $v0, 4			# code for print_str
			la $a0, inputID		# $a0 <- inputID
			syscall				# print str

			li $v0, 4			# code for print_str
			la $a0, newline			# $a0 <- newline
			syscall				# print str

			j resetCountSecond			# go to 'resetCountFirst'

		resetCountSecond:
			li $t0, 0			# set $t0 = 0
			j readID			# go to 'readID'

		readID:
			beq $t0, 40, return   # if count = integers.length, return to main

			li $v0, 5			# code for read_int
			syscall				# store int

			sw $v0, IDArr($t0)		# move int in integers($t0)
			add $t0, $t0, 4			# increment count (int)

			j readID			# loop	

#------------------------------------------------------------------------------------------------------------------------
#
# Registers:
#	$t0 <- general loop counter / str counter
#	$t1 <- age counter
#	$t2 <- ID counter
#	$t3 <- record counter
#
print:	
		beq $t0, 410, return			# if $t0 = strings.length, return to main
		beq $t1, 40, return			# if $t1 = integers.length, return to main
		beq $t2, 40, return			# if $t1 = integers.length, return to main
	
		li $v0, 4				# code for print_str
		la $a0, prefix				# $a0 <- prefix
		syscall					# print str

		li $v0, 1				# code for print_int
		move $a0, $t3				# $a0 <- count
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
		lw $a0, ageArr($t1)			# $a0 <- integers($t1)
		syscall					# print int

		addi $t1, $t1, 4			# increment count (age)

		li $v0, 4				# code for print_str
		la $a0, space				# $a0 <- space
		syscall					# print space

		li $v0, 1				# code for print_int
		lw $a0, IDArr($t2)			# $a0 <- integers($t1)
		syscall					# print int

		li $v0, 4				# code for print_str
		la $a0, newline				# $a0 <- newline
		syscall					# print newline

		addi $t3, $t3, 1			# increment count (record)
		addi $t2, $t2, 4			# increment count (ID)		
		addi $t0, $t0, 41			# increment count (str)

		j print					# loop
		
#------------------------------------------------------------------------------------------------------------------------
#
# Visualization:
#	s, s, s, s, s, s, s, s, s, s
#	0  1  2  3  4  5  6  7  8  9
#
#	a, a, a, a, a, a, a, a, a, a
#	0  1  2  3  4  5  6  7  8  9

#	i, i, i, i, i, i, i, i, i ,i
#	0  1  2  3  4  5  6  7  8  9
#
# Registers:
#	$s0 <- record num 1 
#	$s1 <- record num 2
# 	$s2 <- 1
#   $s3 <- 4
#	$s4 <- 40

# 	$s6 <- strArr / ageArr / IDArr address
#	$s7 - $ra
#
#	$t4 <- index int
#	$t5 <- index int
#	$t6 <- index str
#	$t7 <- index str
#	$t8 <- temp $ to swap
#	$t9 <- temp $ to swap
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

#======================================================================================

		li $s4, 40				# $s4 <- 40
		mult $s0, $s4		    		# $t5 <- index str
		mflo $t6
		mult $s1, $s4				# $t6 <- index str
		mflo $t7

		la $s6, strArr				# $s6 <- strArr address
		add $t6, $t6, $s6			# address + index str
		add $t7, $t7, $s6			# address + index str

		lw $t8, 0($t6)				# $t7 <- value @ strArr[0]
		lw $t9, 0($t7)				# $t8 <- value @ strArr[1]
		sw $t8, 0($t7)				# strArr[1] <- $t7
		sw $t9, 0($t6)				# strArr[0] <- $t8

#======================================================================================

		li $s3, 4				# $s3 <- 4
		mult $s0, $s3 			# $t0 <- index int
		mflo $t4
		mult $s1, $s3				# $t1 <- index int
		mflo $t5

		la $s6, ageArr				# $s6 <- ageArr address
		add $t4, $t4, $s6			# address + index int
		add $t5, $t5, $s6			# address + index int

		lw $t8, 0($t4)				# $t7 <- value @ ageArr[0]
		lw $t9, 0($t5)				# $t8 <- value @ ageArr[1]
		sw $t8, 0($t5)				# ageArr[1] <- $t7
		sw $t9, 0($t4)				# ageArr[0] <- $t8

		li $s0, 0					# clear registers $s0,
		li $s1, 0					# $s1,
		li $s6, 0					# $s6,
		li $t4, 0					# $t4,
		li $t5, 0					# $t5,
		li $t8, 0					# #$t7,	
		li $t9, 0					# $t8 for reuse

#======================================================================================

		mult $s0, $s3 			# $t0 <- index int
		mflo $t3
		mult $s1, $s3				# $t1 <- index int
		mflo $t4

		la $s6, IDArr				# $s5 <- IDArr address
		add $t4, $t4, $s6			# address + index int
		add $t5, $t5, $s6			# address + index int

		lw $t8, 0($t4)				# $t7 <- value @ IDArr[0]
		lw $t9, 0($t5)				# $t8 <- value @ IDArr[1]
		sw $t8, 0($t5)				# IDArr[1] <- $t7
		sw $t9, 0($t4)				# IDArr[0] <- $t8

#======================================================================================

		li $t3, 1				# load $t3 <- 1
		jal print				# go to 'print'
		li $ra, 0				# clear $ra

		add $ra, $zero, $s7			# load with proper $ra

		jr $ra					# return to main

#------------------------------------------------------------------------------------------------------------------------

end:
		li $v0, 10				# code for termination
		syscall					# terminate program run
