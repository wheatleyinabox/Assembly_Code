# Array Manipulation
# CS 2640
#
# Description: A program to work with arrays, allowing the user to remove or edit values and see the
# result. When exiting, the program computes the sum and product of the remaining values.
#
.data
	# VARIABLES GO HERE
	numbers: .space 40

	message: .asciiz "Please enter 10 integer values: "
	next: .asciiz "Value: "

	printArrSTRING: .asciiz "Your values are: "

	confirmTWO: .asciiz "You selected Option 2!"
	confirmTHREE: .asciiz "You selected Option 3!"
	confirmFOUR: .asciiz "You selected Option 4!"

	replaceElementPOSITION: .asciiz "What position from the array do you wish to replace? "
	replaceElementVALUE: .asciiz "What value do you want to change it to? "

	computeValuesSUM: .asciiz "The summation of all values in the array is: "
	computeValuesPRODUCT: .asciiz "the product of all values in the array is: "

	newline: .asciiz "\n"
	space: .asciiz " "
	divider: .asciiz ", "

	menu: .asciiz "Menu (enter an int as your choice): "
	option1: .asciiz "1) Replace a element at a certain position "
	option2: .asciiz "2) Remove the max element "
	option3: .asciiz "3) Remove the min element "
	option4: .asciiz "4) Compute values and exit "
	question: .asciiz "What would you like to do? "

	.globl main
.text
main:
	# MAIN METHOD CODE GO HERE
	li $v0, 4							# code for print_str
	la, $a0, message					# str store in print register
	syscall 							# print message

	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline

	la $t0 0							# Create count variable
	jal readArrayLoop					# read values (loop)

	xor $t0, $t0, $t0
	and $t0, $t0, $0					# Reset count var $t0 to 0

	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline

	li $v0, 4							# code for print_str
	la, $a0, printArrSTRING				# str store in print register
	syscall 							# print printArrSTRING

	jal printArrayLoop					# loop through and print

	xor $t0, $t0, $t0
	and $t0, $t0, $0					# Reset count var $t0 to 0

	menuIO:
	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline
	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline
	li $v0, 4							# code for print_str
	la, $a0, menu						# str store in print register
	syscall 							# print menu
	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline
	li $v0, 4							# code for print_str
	la, $a0, option1					# str store in print register
	syscall 							# print option1
	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline
	li $v0, 4							# code for print_str
	la, $a0, option2					# str store in print register
	syscall 							# print option2
	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline
	li $v0, 4							# code for print_str
	la, $a0, option3					# str store in print register
	syscall 							# print option3
	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline
	li $v0, 4							# code for print_str
	la, $a0, option4					# str store in print register
	syscall 							# print option4
	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline
	li $v0, 4							# code for print_str
	la, $a0, question					# str store in print register
	syscall 							# print question
	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline

	j menuLoop							# enter menu

	done:
	li $v0, 10							# code for termination
	syscall								# terminate program

# LOOPS, METHODS AND EXIT

menuLoop:
	bne $v0, 4, o4						# while int != 4, if int = 4, o4

	li $v0, 5							# code for read int
	syscall								# stores int
	beq $v0, 1, o1						# if int = 1, go to o1
	beq $v0, 2, o2						# if int = 2, go to o2
	beq $v0, 3, o3						# if int = 3, go to o3
	j menuLoop

o1:	
	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline

	li $v0, 4							# code for print_str
	la, $a0, replaceElementPOSITION		# str store in print register
	syscall								# print replaceElementPOSITION

	li $v0, 5							# code for read int
	syscall								# stores int
	move $t1, $v0						# move int to $t1 register
	sub $t1, $t1, 1						# assuming input not at 0 (-1)

	la $t2, 4							# load $t2 with int 4
	mult $t1, $t2						# Multiply $t1 by 4, store in $t1
	mflo $t1							# Take product store in $t1

	li $v0, 4							# code for print_str
	la, $a0, replaceElementVALUE		# str store in print register
	syscall								# print replaceElementVALUE

	li $v0, 5							# code for read int
	syscall								# reads int
	move $t3, $v0							# store int in $t3

	la $t2, numbers						# load array address into $t2
	add $s0, $0, $t3					# load value into $s0 register
	sw $s0, numbers($t1)						# Use value to replace numbers[i]

	li $v0, 4							# code for print_str
	la, $a0, printArrSTRING				# str store in print register
	syscall 							# print printArrSTRING

	jal printArrayLoop					# loop through and print
	xor $t0, $t0, $t0
	and $t0, $t0, $0					# Reset count var $t0 to 0
	
	j menuIO							# return to menu options
o2:
	lw $t1, numbers($zero)						# $t1 (max) = number[0]
	la $s2, 0							# make index var i = 0
	jal findMaxLoop						# go to loop
	xor $t0, $t0, $t0
	and $t0, $t0, $0					# Reset count var $t0 to 0

	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline

	la $t5, 40					# load $t5 with arr length
	jal printMaxLoop					# print all but max from arr
	xor $t0, $t0, $t0
	and $t0, $t0, $zero					# Reset count var $t0 to 0
	xor $t5, $t5, $t5
	and $t5, $t5, $zero					# Reset count var $t5 to 0

	xor $t1, $t1, $t1
	and $t1, $t1, $zero					# Reset count var $t1 to 0
	xor $t2, $s2, $s2
	and $s2, $s2, $zero					# Reset count var $s2 to 0

	j menuIO		 					# return to menu options
o3:
	lw $t1, numbers($zero)				# $t1 (min) = number[0]
	li $s2, 0							# $s2 make index var
	jal findMinLoop						# go to loop
	xor $t0, $t0, $t0
	and $t0, $t0, $0					# Reset count var $t0 to 0

	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline

	li $v0, 4							# code for print_str
	la, $a0, printArrSTRING				# str store in print register
	syscall 							# print printArrSTRING

	la $t5, 40						# load $t5 with 40
	jal printMinLoop					# print arr without max
	xor $t0, $t0, $t0
	and $t0, $t0, $0					# Reset count var $t0 to 0

	xor $t5, $t5, $t5
	and $t5, $t5, $zero					# Reset count var $t5 to 0

	xor $t0, $t0, $t0
	and $t1, $t1, $0					# Reset count var $t1 to 0
	xor $s2, $s2, $s2
	and $s2, $s2, $0					# Reset count var $s2 to 0
	
	j menuIO						# go back to menu

o4:
	li $v0, 4							# code for print_str
	la, $a0, newline					# str store in print register
	syscall								# print newline

	la, $t1, 0							# sum variable
	la, $t2, 1							# product variable
	jal computeValuesLoop				# loopy loop for add/mult

	li $v0, 4							# code for print_str
	la, $a0, computeValuesSUM			# str store in print register
	syscall								# print computeValuesSUM

	li $v0, 1							# code for print_int
	move $a0, $t1						# int store in print register
	syscall								# print sum

	li $v0, 4							# code for print_str
	la, $a0, divider					# str store in print register
	syscall								# print divider
	
	li $v0, 4							# code for print_str
	la, $a0, computeValuesPRODUCT		# str store in print register
	syscall								# print computeValuesPRODUCT

	li $v0, 1							# code for print_int
	move $a0, $t2						# int store in print register
	syscall								# print product

	j done								# return to main and terminate

findMaxLoop:	
	beq $t0, 40, exit					# if count != numbers.length else exit

	lw $t4, numbers($t0)					# $t4 = numbers[i]
	slt $t1, $t4, $t1					# if max < numbers[i]
	beq $t1, $zero, makeMax					# go to makeMax
	makeMax:
		move $t1, $t4						# put number[i] in max
		move $s2, $t0						# put index in index var

	addi $t0, $t0, 4					# Add by 4 to copy index
	j findMaxLoop
printMaxLoop:
	bge $t0, $t5, exit					# if count != numbers.length else exit

	beq $s2, $t0, isMax					# if currentIndex == maxIndex, goto isMax
	
	li $v0, 1							# code for print_int
	lw $a0, numbers($t0)   				# move num in numbers to print register
	syscall								# print num

	li $v0, 4							# code for print_str
	la, $a0, space						# str store in print register
	syscall 							# print space

	addi $t0, $t0, 4					# Add by 4 to skip current index before printing

	j printMaxLoop
isMax:
	addi $t0, $t0, 4	# skip current index (add 4 to index)
	sub $t5, $t5, 4		# decrease array size to exclude an element
	j printMaxLoop

findMinLoop:	
	beq $t0, 40, exit					# if count != numbers.length else exit

	lw $t3, numbers($t0)				# $t3 = numbers[i]
	slt $t1, $t1, $t3					# if numbers[i] < max
	beq $t1, $zero, makeMin 			# go to makeMin
	makeMin:
	move $t1, $t3						# put number[i] in max
	move $t2, $t0						# put index in index var

	add $t0, $t0, 4						# Add by 4 to count var

	j findMinLoop

printMinLoop:
	beq $t0, $t5, exit					# if count != numbers.length else exit

	beq $s2, $t0, isMin					# if index = index of min, skip
	
	li $v0, 1							# code for print_int
	lw $a0, numbers($t0)    			# move num in numbers to print register
	syscall								# print num

	li $v0, 4							# code for print_str
	la, $a0, space						# str store in print register
	syscall 							# print space

	addi $t0, $t0, 4						# Add by 4 to count var

	j printMinLoop
isMin:
	addi $t0, $t0, 4					# [i+1], skip this index and print the next one
	sub $t5, $t5, 4		# decrease array size to exclude an element
	j printMinLoop						# return to loop

computeValuesLoop:
	beq $t0, 40, exit					# if count != numbers.length else exit

	lw $t4, numbers($t0)				# load number from array
	add $t1, $t1, $t4 					# summation
	mult $t2, $t4						# product
	mflo $t2

	add $t0, $t0, 4						# Add by 4 to count var

	j computeValuesLoop

readArrayLoop:
	beq $t0, 40, exit					# if count != numbers.length else exit

	li $v0, 5							# code for read int
	syscall								# stores int

	sw $v0, numbers($t0)				# Move int to array
	add $t0, $t0, 4						# Add by 4 to count var

	j readArrayLoop						# continue loop

printArrayLoop: 
	beq $t0, 40, exit					# if count != numbers.length else exit

	li $v0, 1							# code for print_int
	lw $a0, numbers($t0)    			# move num in numbers to print register
	syscall								# print num

	li $v0, 4							# code for print_str
	la, $a0, space						# str store in print register
	syscall 							# print space

	add $t0, $t0, 4						# Add by 4 to count var
	j printArrayLoop					# Continue loop
exit:
	jr $ra								# Exit loop return to main
.end