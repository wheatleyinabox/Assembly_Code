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
	arr: 		.word 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
	space: 		.asciiz " "
	newline: 	.asciiz "\n"
	sum:		.asciiz "Sum: "
	menu:		.asciiz "\nPick one of the following options: \n1) replace values \n2) calculate sum \n3) print 2d array \n4) exit"
	rowInput:	.asciiz "Enter row number [1-5]: "
	columnInput: 	.asciiz "Enter column number [1-3]: "
	replaceInput:	.asciiz "Enter a value: "

	# $s0 = general loop counter #1
	# $s1 = pointer to arr
	# $s2 = max value for iteration (printArr)
	# $s3 = num of columns

	# $s7 <- row counter (printArr)
	# $s6 <- baseAddress

	# $t5 = general loop counter #2

	# $t7 = element value variable (summation)
	# $t8 = sum variable (summation) 

.text
main:		
		la $s0, 0			# general loop counter
		la $s1, arr			# pointer to arr
		li $s2, 14			# max value for iteration
		li $s3, 3			# numOfColumns
		jal printArr			# go to printArr

printArr:
		li $s7, 0			# $s7 <- row counter
		la $s6, arr			# $s6 <- baseAddress
printArrLoop:
		li $v0, 1			# code for print_int
		lw $a0, ($s6)			# store int (arr[add]) into print register
		syscall				# print element

		li $v0, 4			# code for print_str
		la $a0, space			# store str into print register
		syscall				# print space

		addi $s7, $s7, 1		# row counter++
		addi $s6, $s6, 4		# increment loop counter by 4 (bytes)
		
		bgt $s7, $s2, finish		# if $s7 == 14($s2)
		sll $0, $0, 0			# no-op
		
		div $s7, $s3			# row counter % 3(numOfColumns)
		mfhi $t2			# $t2 <- arbitrary storage register
			
		li $v0, 4			# code for print_str*
		beq $t2, 0, enter		# if $t2 == 0, enter
		sll $0, $0, 0			# no-op

		j printArrLoop			# loop around town~
enter:
		la $a0, newline			# store str into print register
		syscall				# print newline

		j printArrLoop			# return to loop
		sll $0, $0, 0			# no-op
finish:
		j menuIO			# return to menu
		sll $0, $0, 0			# no-op
		
printSum: 	
		li $v0, 4			# code for print_str
		la $a0, sum			# str store in print register
		syscall				# print sum (str)
		li $v0, 1			# code for print_int
		move $a0, $t8			# str store in print register
		syscall				# print sum (int)

		move $t7, $zero			# empty $t7 (summation var)
		move $t8, $zero			# empty $t8 (summation var)

		li $v0, 4			# code for print_str
		la $a0, newline			# str store in print register
		syscall				# print newline
				
		j menuIO			# return to menu
summation:
		beq $t5, 60, printSum		# if count == arr length, printSum

		lw $t7, arr($t5)		# load num from arr
		add $t8, $t8, $t7 		# summation
		
		addi $t5, $t5, 4		# increment count (int: 4)
		j summation			# continue loop

replaceValue:		
		li $v0, 4			# code for print_str
		la $a0, rowInput		# str store in print register
		syscall				# print rowInput
		li $v0, 5			# code for read_int
		syscall				# read rowIndex int
		sub $t7, $v0, 1			# load row index into $t7 after subtracting 1

		li $v0, 4			# code for read_int
		la $a0, columnInput		# str store in print register
		syscall				# print columnInput
		li $v0, 5			# code for read_int
		syscall				# read columnIndex int
		sub $t8, $v0 1			# load row index into $t8 after subtracting 1

		mult $t7, $s3			# $t7 * numOfColumns
		mflo $t7			# save into itself
		
		add $t7, $t7, $t8		# index <- rowIndex + columnIndex

		li $t2, 4			# $t2 <- 4
		mult $t7, $t2			# $t7(index) * 4
		mflo $t7			# save into itself
		
		li $v0, 4			# code for print_str
		la $a0, replaceInput		# store str into print register
		syscall				# print replaceInput
		li $v0, 5			# code for read_int
		syscall				# read replacementValue

		la $s4, arr			# $s4 <- baseAddress
		add $s4, $s4, $t7		# $s4 <- baseAddress + index
		sw $v0, 0($s4)			# save replacementVal into arr($s4)
		
		j menuIO			# return to loop

menuIO:	
		move $t5, $zero			# reset $t5

		li $v0, 4			# code for print_str
		la $a0, newline			# str str in print register
		syscall				# print newline
		
		li $v0, 4			# code for print_str
		la $a0, menu			# str store in print register
		syscall				# print menu
		li $v0, 4			# code for print_str
		la $a0, newline			# str store in print register
		syscall				# print newline

		li $v0, 5			# code for read_int
		syscall				# read inputNum
		beq $v0, 1, replaceValue	# if inputNum == 1, replaceValue
		beq $v0, 2, summation		# if inputNum == 2, add em up
		beq $v0, 3, printArr		# if inputNum == 3, replaceValue
		beq $v0, 4, end			# if inputNum == 4, end

end:
		li $v0, 10		# code for termination
		syscall			# terminate program run