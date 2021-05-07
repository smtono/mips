# Exercise 1
# Load two values into a a temporary registers. Then create 5 small examples with different branch instructions, and comment the outcomes.
# Author: smtono

# Data section (variables)
.data

is_equal:	.asciiz "The two values are equal"
is_not_equal: .asciiz "The two values are not equal"
first_is_greater: .asciiz "The first value is greater"
second_is_greater: .asciiz "The second value is greater"
is_not_zero: .asciiz "This value is not nonzero"


# Main part of the program
.text

main:
# Loading 2 values into temp registers
li $t0, 0
li $t1, 1

j example_one # Here you can change the example to go over

# Deomonstrates the branch if equal instruction
example_one:
	beq $t0, $t1, equal # Check if the two values are equal
	j end_program # Go to the end of the program if they are not

# Loads the proper string into the argument to perform a system call.
equal:
	la $a0, is_equal # Loading the equal string into the argument to prepare for syscall
	j print # Jump to the print label


example_two:
	bne $t0, $t1, not_equal # Check if the two values are not equal
	j end_program # Go to the end of the program if they are not

not_equal:
	la $a0, is_not_equal
	j print

example_three:
	bgt $t0, $t1, first_greater # Check if the first value is greater than the second, jump if true
	j second_greater # If the above statement did not jump, the second value must be greater

first_greater:
	la $a0, first_is_greater
	j print

second_greater:
	la $a0, second_is_greater
	j print

example_four:
	blt $t0, $t1, second_greater
	j first_greater

example_five:
	bnez $t0, not_zero
	j end_program

not_zero:
	la $a0, is_not_zero
	j print

# Prints out the strings based on the condition
print:
	li $v0, 4	# System call code 4 (print_string).
	syscall		# Print string loaded in $a0.

# Serves as the end of the program
end_program:
