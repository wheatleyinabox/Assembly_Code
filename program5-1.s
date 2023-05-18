    .data

greeting: .asciiz "Hello, give 10 records \n"
menu: .asciiz "\nMenu:\n1) Swap two records.\n2) Exit\nPlease choose one of the above options: "

num1ToSwap: .asciiz "\n Please enter the first record to swap(pick from 1-10): " 
num2ToSwap: .asciiz "\n Please enter the second record to swap(pick from 1-10): "

space: .asciiz " "
newline: .asciiz "\n"

arraySize: .word 10
.align 2
ageArray: .space 40
idArray: .space 40
nameArray: .space 410
    .text

main:
    li, $v0, 4
    la $a0, greeting
    syscall

    li $s0, 0 #set counter to 0
    la $s1, nameArray #pointer for array address  of nameArray
   
    la $s2, ageArray #pointer for array address of ageArray
    la $s3, idArray #pointer for array address of idArray
    li $s4, 10 #setting loop counter to max of 10
   

# Method 1
#only need to insert noop statements in this now
#read and store an array of 10 records representinng students.
#each record consists of name of type string of upto 40 chars,
#age of int and id of int

readNextRecord:
    bge $s0, $s4, method2
    j readString
    
readString:
    li $v0, 8  #instruction to read a string
    # FIXED
    la $a0, ($s1) # When you read string from uer, this is the syntax .
    syscall 

    # sw $v0, ($s1) #move value of string to register $s1 ie to the array at that index    
    addi $s1, $s1, 40 #incremeant address here for next record by 40 for next string
    j readAge

readAge:
    
    li $v0, 5  #instruction to read an int
    syscall 
    # sw $v0, ($s2) #move value of age to register $s2 ie to the array at that index 
    
    # FIXIED
    # You cannot store user input directly.
    # it is required to store value to a register tempraly, than  store it to your desired place. 
    # This case $t7 temporary register to store value. 
    add $t7, $v0, $0            # Store user input age to $t7   
    sw $t7, ($s2) #move value of age to register $s2 ie to the array at that index 
    
    addi $s2, $s2, 4 #incremeant address here for next record by 4 for next int
    j readId

readId:
    
    li $v0, 5  #instruction to read an int
    syscall 
    # sw $v0, ($s3) #move value of id to register $s3 ie to the array at that index 

    # FIXIED
    # You cannot store user input directly
    # it is required to store value to a register temporary, then store it to your desired place. 
    # This case $t7 temporary register to store value. 
    add $t7, $v0, $0            # Store user input age to $t7   
    sw $t7, ($s3)
    
    addi $s3, $s3, 4 #incremeant address here for next record by 4 for next int
    j storeNextRecord

storeNextRecord:
    addi $s0, $s0, 1 #incremeant counter $s0 here 
    j readNextRecord


# Method 2 
#prints array created by method1 in readable format
#single line of each student
#make it readable
#maybe need to shift the addresses s1,s2 and s3 back

method2:
    li $s0, 0 #reset counter to 0

    # FIXIED
    # This causes frequently isseus, forgetting initialize pointer address like forgetting initialize counter.
    # Make sure you initialize pointer, loading the fist address before doing each method.
    # Otherwise, the pointer keeps reading after your last index address.
    la $s1, nameArray #pointer for array address  of nameArray
    la $s2, ageArray #pointer for array address of ageArray
    la $s3, idArray #pointer for array address of idArray

    j printNextRecord
printNextRecord:

    bge $s0, $s4, printMenu

    li $v0, 4  #instruction to print string
    la $a0, newline 
    syscall 

    #print one record here
    
    #print name 
    li $v0, 4
    la $a0, ($s1) #print value of nameArray at the given index
    syscall
    li $v0, 4  #instruction to print string
    la $a0, space  # load the space string
    syscall 

    #print age
    li $v0, 1

    # FIXIED
    # You cannot store user input directly.
    # it is required to store value to a register tempraly, than  store it to your desired place. 
    # This case $t7 temporary register to store value. 
    lw $t7, ($s2)
    add $a0, $t7, $0            # Store Age to a0    
    
    # la $a0, ($s2) #print value of ageArray at the given index
    syscall
    li $v0, 4  #instruction to print string
    la $a0, space  # load the space string
    syscall 

    #print id
    li $v0, 1
    # la $a0, ($s3) #print value of idArray at the given index

    # FIXED
    # You cannot store user input directly.
    # it is required to store value to a register tempraly, than  store it to your desired place. 
    # This case $t7 temporary register to store value. 
    lw $t7, ($s3)
    add $a0, $t7, $0            # Store ID to a0    
    syscall
    
    li $v0, 4  #instruction to print string
    la $a0, space  # load the space string
    syscall 

    addi $s0, $s0, 1 #incremeant counter $s0 here 

    #INCREMEANTING ADDRESS COUNTER FOR ALL ARRAYS
    addi $s1, $s1, 40 #incremeant address here for next record by 40 for next string
    addi $s2, $s2, 4 #incremeant address here for next record by 4 for next int
    addi $s3, $s3, 4 #incremeant address here for next record by 4 for next int
    
    j printNextRecord



# Method 3
#print menu
printMenu:
    li $v0, 4  #instruction to print string
    la $a0, menu  #load string 
    syscall 

    li $v0, 5  #instruction to read an int
    syscall 

    bne $v0, 1, choice1 #check to confirm that choice is not 1
    sll $0, $0, 0
    jal swap
    sll $0,$0, 0
choice1:
    sll $0, $0, 0 
    li $v0, 10  # load 10 into $v0 to call exit 
    syscall

swap:
#print prompts and
#read in 2 ints and store THEM
#do math to load the addresses of the recordsToSwap

    #read in the first record to swap
    li $v0, 4  #instruction to print string
    la $a0, num1ToSwap  #load string 
    syscall 

    li $v0, 5  #instruction to read an int
    syscall 
    move $t1, $v0 #move int to t1
    sub $t1, $v0, 1 # subtract 1 from the returned value and save it to the register $t0
    
    li $s5, 40 #load 40 into $s5 which is size of string
    li $s6, 4 #load 4 into $s5 which is size of int

    mult $t1, $s5 # multiply index by the size of a string 
    mflo $t2 #store string index address in $t2
    mult $t1, $s6 # multiply index by the size of a int 
    mflo $t3 #store int index addresses in $t3
    
    
    #read in the second record to swap
    li $v0, 4  #instruction to print string
    la $a0, num2ToSwap  #load string 
    syscall 

    li $v0, 5  #instruction to read an int
    syscall 
    move $4, $v0 #move int to t1
    sub $t4, $v0, 1 # subtract 1 from the returned value and save it to the register $t0
    
    mult $t4, $s5 # multiply index by the size of a string 
    mflo $t5 #store string index address in $t5
    mult $t4, $s6 # multiply index by the size of a int 
    mflo $t6 #store int index addresses in $t6
    mult $t4, $s6 # multiply index by the size of a int 
    mflo $t6 #store int index addresses in $t6

    li $s0, 0
    li $s4, 40

    j swapRecords


swapRecords:

    #load address of first record in $t7 
    #load address of second record in first record
    #load address of first record from $t4 into address of second record
    #lines 99-101 and 93-97
   
    la $t7, nameArray #load array address of name array in t7
    add $t2, $t2, $t7 #add array address to the index
    add $t5, $t5, $t7 #add array address to the index
swapName:
    #swap name at those two indexes
    bge $s0, $s4, swapAge
    lb $t8, ($t2) #load byte from first student
    lb $t9, ($t5) #load byte from the second student
    
    sb $t9, ($t2) #save byte from first student in seconds location
    sb $t8, ($t5) #save byte from the second student in firsts location
    sll $0, $0, 0

    addi $s0, $s0, 1
    addi $t2, $t2, 1
    addi $t5, $t5, 1
    sll $0, $0, 0

    j swapName
swapAge:
#swap age at those two indexes
    la $t7, ageArray #load array address of name array in t7
    add $t3, $t3, $t7 #add array address to the index
    add $t6, $t6, $t7 #add array address to the index

    lb $t8, ($t3) #load byte from first student
    lb $t9, ($t6) #load byte from the second student

    sb $t9, ($t3) #save byte from first student in seconds location
    sb $t8, ($t6) #save byte from the second student in firsts location

    sll $0, $0, 0
    j swapId

swapId:
#swap Id at those two indexes
    mult $t1, $s6 # multiply index by the size of a int 
    mflo $t3 #store int index addresses in $t3
    mult $t4, $s6 # multiply index by the size of a int 
    mflo $t6 #store int index addresses in $t6

    la $t7, idArray #load array address of name array in t7
    add $t3, $t3, $t7 #add array address to the index
    add $t6, $t6, $t7 #add array address to the index

    lw $t8, ($t3) #load byte from first student
    lw $t9, ($t6) #load byte from the second student
    
    sw $t9, ($t3) #save byte from first student in seconds location
    sw $t8, ($t6) #save byte from the second student in firsts location

    sll $0, $0, 0
    j goToMenu  

goToMenu :
    li $s0, 0
    li $s4, 10
    j method2
    #if option 1 swap else exit
    
#main method where program starts
#use the above methods here to create array of records, print records for users to see
#then provide menu for them to swap record or exit 
#continue to shoe user the menu until they chose to exit from the program.


#CAN I MAKE 3 ARRAYS TO STORE THOSE 3 THINGS 
#AND JUST PRINT THEM ONE BY ONE WHILE PRINTING AT SIMILAR index
#SO LIKE HASHMAPS BUT LINK TEHE 3 PARTS OF 
#THE ARRAY TOGETHER KINDOF LIKE a DICTIONARY WITH KEYS