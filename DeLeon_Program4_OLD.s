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
	rowInput:	.asciiz "Enter row number [0-4]: "
	columnInput: 	.asciiz "Enter column number [0-2]: "
	replaceInput:	.asciiz "Enter a value: "

	# $t0 = pointer to current beginning of row
	# $t1 = row counter & index
	# $t2 = column counter & index
	# $t3 = pointer to current address to store data
	# $t4 = value to be stored in each array element

	# $t5 = general loop counter

	# $t6 = row counter (printArr)

	# $t7 = element value variable (summation) / row index (replaceValue)
	# $t8 = sum variable (summation)	   / column index (replaceValue)

.text
main:		la $t0, arr			# initialize pointer to start of array
		move $t1, $zero			# initialize row counter/index
		li $t4, 5			# put value to be loaded in array in $t4

rowLoop:	move $t2, $zero			# initialize column counter/index
		move $t3, $t0			# initialize col. pointer to 1st element of row

columnLoop:	sw $t4, 0($t3)			# store value in current array element
		addi $t2, $t2, 1		# increment column counter/index by 1
		beq $t2, 3, nextRow		# go to next row if column counter = 3
		addi $t3, $t3, 4		# increment the column pointer
		j columnLoop

nextRow:	addi $t1, $t1, 1		# increment row counter/index by 1
		beq $t1, 5, printArr		# leave row loop if row counter = 5

		add $t0, $t0, 12		# increment the beginning-of-row pointer 
						# by 12 (num of byte in row)
		j rowLoop
enter:
		li $v0, 4			# code for print_str
		la $a0, newline			# str store in print register
		syscall				
		move $t6, $zero			# $t6 = 0
		j cont
cont:
		addi $t2, $t2, 1		# increment column counter/index by 1
		beq $t2, 5, printNextRow	# go to next row if column counter = 5
		addi $t3, $t3, 4		# increment the column pointer
		j printColumnLoop
printArr:	
		la $t0, 0x10010000		# initialize pointer to start of array
		move $t1, $zero			# initialize row counter/index
		li $t4, 0			# temp value to be loaded in array in $t4
		move $t6, $zero			# printArr row count = 0

		printRowLoop:	
			move $t2, $zero			# initialize column counter/index
			move $t3, $t0			# initialize col. pointer to 1st element of row

		printColumnLoop:	
			lw $t4, 0($t3)			# store value in current array element

			li $v0, 1			# code for print_int
			move $a0, $t4			# int store in print register
			syscall	

			li $v0, 4			# code for print_str
			la $a0, space			# str store in print register
			syscall	

			addi $t6, $t6, 1		# increment row count by 1
			beq $t6, 3, enter		# if row count == 3, enter
			
			j cont

		printNextRow:	
			addi $t1, $t1, 1		# increment row counter/index by 1
			beq $t1, 3, menuIO		# leave row loop if row counter = 3
			add $t0, $t0, 12		# increment the beginning-of-row pointer 
							# by 20 (num of byte in row)
			j printRowLoop

printSum: 	
		li $v0, 4			# code for print_str
		la $a0, sum			# str store in print register
		syscall
		li $v0, 1			# code for print_int
		move $a0, $t8			# str store in print register
		syscall

		move $t7, $zero			# empty $t7
		move $t8, $zero			# empty $t8

		li $v0, 4			# code for print_str
		la $a0, newline			# str store in print register
		syscall	
		
		j menuIO
summation:
		beq $t5, 60, printSum		# if count == arr length, printSum

		lw $t7, arr($t5)		# load num from arr
		add $t8, $t8, $t7 		# summation
		
		addi $t5, $t5, 4		# increment count (int: 4)
		j summation			# continue loop

replaceValue:
		# $t7 -> row index
		# $t8 -> column index
		# $t9 -> replacementValue

		# $s0 -> row size    
		# $s1 -> column size
		# $s3 -> value address
		# $s4 -> base address
		
		li $v0, 4			# code for print_str
		la $a0, rowInput		# str store in print register
		syscall
		li $v0, 5			# code for read_int
		syscall

		li $v0, 4			# code for print_str
		la $a0, columnInput		# str store in print register
		syscall
		li $v0, 5			# code for read_int
		syscall

		li $s0, 3			# load $s0 <- 3
		mult $s0, $t7			
		mflo $s0			# $s0 -> row val ($t7*3)
		add $s0, $t8, $s0		# 2d index <- column val + row val

		li $s1, 4			# load $s1 <- 4		
		mult $s0, $s1			# 2d index * 4 bytes
		mflo $s0			# save into $s0

		li $v0, 4			# code for read_int
		la $a0, replaceInput		# str store in print register
		syscall

		li $v0, 5			# code for read_int
		syscall
		move $t9, $v0			# load replacementValue into $t9

		la $s4, 0x10010000		# $s4 -> baseAddress of arr[0][0]
						# 0x10010000

		add $s4, $s4, $s0		# baseAddress + 2d index -> $s4

		sw $t9, 0($s3)			# Use $t9 to replace arr[value address]
		
		j menuIO
		sll $0, $0, 0			# no-op
		
menuIO:	
		move $t5, $zero			# reset $t5
		move $t6, $zero 		# reset $t6
		
		li $v0, 4			# code for print_str
		la $a0, menu			# str store in print register
		syscall
		li $v0, 4			# code for print_str
		la $a0, newline			# str store in print register
		syscall	

		li $v0, 5			# code for read_int
		syscall
		beq $v0, 1, replaceValue	# if num == 1, replaceValue
		beq $v0, 2, summation		# if num == 2, add em up
		beq $v0, 3, printArr		# if num == 3, replaceValue
		beq $v0, 4, end			# if num == 4, end

end:
		li $v0, 10		# code for termination
		syscall			# terminate program run