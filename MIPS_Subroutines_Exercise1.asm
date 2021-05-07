# ---------------------------------------------------------------------------
# MIPS Subroutines Exercise 1
#
# Create a subroutine that keeps asking for a number until the user inputs a positive number. Once you have the positive number, the subroutine will return the value
# Create a subroutine to multiply two values and return the result
# Create a subroutine to calculate the x^z
# Write some code that utilizes the subroutines.
#
# smtono
# ---------------------------------------------------------------------------
	.data
pos:	.asciiz "Please enter a positive number.\n"
nl: 	.asciiz "\n"

	.text
# ---------------------------------------------------------------------------
# 			Main Driver
# ---------------------------------------------------------------------------
main:
# Checking a positive number
	jal check_positive		# Call the check_positive subroutine
	
	# New line
	li $v0, 4 	
	la $a0, nl
	syscall
	
# Multiplying 2 * 5 (Get result of 10)
	li $a0, 2			
	li $a1, 5
	
	jal multiply
	move $a0, $v0			# Preparing to print result
	li $v0, 1 			# Load the "print integer" code into v0 for a syscall
	syscall
	
	# New line
	li $v0, 4 	
	la $a0, nl
	syscall
	
# Calculate 2^3 (Get result of 8)
	li $a0, 2
	li $a1, 3
	
	jal exponent
	move $a0, $v0			# Preparing to print result
	li $v0, 1 			# Load the "print integer" code into v0 for a syscall
	syscall
	
	j end_program			# Ends the program
# ---------------------------------------------------------------------------
# 			Subroutines
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Continuously checks for a positive number from the user
# Returns the positive value
# ---------------------------------------------------------------------------
check_positive:
	li $v0, 4 			# Load the "print string" code into v0 for a syscall
	la $a0, pos			# Loads "pos" string into argument
	syscall
	
	li $v0, 5 			# Load the "read integer" code into v0 for a syscall
	syscall
	
	blt $v0, 0, check_positive	# Checks if it is positive, asks again if not (goes back to top)
	jr $ra				# Return
	
# ---------------------------------------------------------------------------
# Multiplies the two numbers in arguments
# Returns the result
# ---------------------------------------------------------------------------
multiply:
	mul $v0, $a0, $a1		# Multiplies the two numbers given as arguments
	jr $ra				# Return

# ---------------------------------------------------------------------------
# Finds the result of the first argument to the power of the second argument
# Returns the result
# ---------------------------------------------------------------------------
exponent:
# a0 (t1): The base
# a1: The exponent (number of times to multiply the base by itself)

	li $t0, 1			# Keep track of current loop, initialize to 1 because we are multiplying 1 time first
	move $v0, $a0			# Moving arguments into register that will be manipulated and returned
calculate_exponent:
	beq $t0, $a1, return 		# If t0 equals the base it is time to end the loop
	mul $v0, $v0, $a0		# Multiply the eventual result with the base
	addi $t0, $t0, 1		# Increment loop
	j calculate_exponent		# Jump back to the start of the loop
return:
	jr $ra
	
# ---------------------------------------------------------------------------
# Ends program
# ---------------------------------------------------------------------------
end_program: