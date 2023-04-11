# My First Assembly Program
# CS 2640
#
.data
	test: .asciiz "Hello world\n" 		# Creates multiple strings to store
	name: .asciiz "Valen DeLeon\n"		# for each parameter of the assignment
	game: .asciiz "Portal 2\n"
	film: .asciiz "Wall-E\n"
	song: .asciiz "Juliet by Cavetown\n"
.text
main:	li $v0, 4	# Code for print_str
	la $a0, test	# Stores created string into $a0 register
	syscall		# Prints string
	li $v0, 4	# Code for print_str
	la $a0, name	# Stores created string into $a0 register
	syscall		# Prints string
	li $v0, 4	# Code for print_str
	la $a0, game	# Stores created string into $a0 register
	syscall		# Prints string
	li $v0, 4	# Code for print_str
	la $a0, film	# Stores created string into $a0 register
	syscall		# Prints string
	li $v0, 4	# Code for print_str
	la $a0, song	# Stores created string into $a0 register
	syscall		# Prints string
	li $v0, 10	# Code for termination
	syscall		# Terminate program run
.end