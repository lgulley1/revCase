#Given a string, reverses the capitaliztion of every character
#Name: Luke Gulley
#Date: October 06, 2016

.data
	.align 2 #align the next string on a word boundary
    outpPrompt: .asciiz "Please enter 30 characters (upper/lower case mixed): "
	
    .align 2
    outpStr: .asciiz "You entered the string: "
    
    .align 2
    varStr: .space 32 #will hold the user's input string
    
    .align 2
    outpStrRev: .asciiz "Your string in reverse case is: "
    
    .align 2
    varStrRev: .space 32 #reserve 32 characters for the reverse case string

    errorMessage: .asciiz "error, invalid input. Try again."

.text
.globl main

main:  
#requests user input
la $a0,outpPrompt
li $v0,4
syscall

#stores user input
li $v0,8
la $a0,varStr
li $a1,32
syscall

#prints user's input
la $a0,outpStr
li $v0,4
syscall

la $a0,varStr
li $v0,4
syscall	

la $t0, varStr
la $t3, varStrRev

isLetter: #checks if character is letter, returns error if charcter is not a letter
	lb $t1, ($t0) #assigns char of varStr to $t1
	beqz $t1, end #ends loop
	beq $t1, 10, end
	li $t2, 'a'
	bge $t1, $t2, confirmLower
	li $t2, 'A'
	bge $t1, $t2, confirmUpper
	j error #indicates character is not a letter and is below 'A'

confirmLower: #confirms character is a lowercase letter
	li $t2, 'z'
	ble $t1, $t2, convert
	j error

confirmUpper: #confirms character is an uppercase letter
	li $t2, 'Z'
	ble $t1, $t2, convert
	j error #returns error if charcter is not a letter

convert:
	xor $t1, $t1, 32 #converts character to opposite letter case
	j continue #iterates and stores $t1, $t3

continue: #jumps to next letter in varStr and varStrRev
	sb $t1, ($t3) #stores letter in $t3
	add $t0, $t0, 1
	add $t3, $t3, 1
	j isLetter

error:
	la $a0, errorMessage #prints error message
	li $v0, 4
	syscall
	
	#graceful exit
	la $v0, 10
	syscall

end:
#prints reverse string
la $a0,outpStrRev
li $v0,4
syscall

la $a0,varStrRev
li $v0,4
syscall

#exit gracefully
li $v0, 10 #system call for exit
syscall #close file