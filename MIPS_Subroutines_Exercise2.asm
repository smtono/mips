# ---------------------------------------------------------------------------
# MIPS Subroutines Exercise 2
#
# Implement the game Rock paper scissors or utilize your code from the Individual MIPS Assignment. 
# Every round, have each user provide their choice as an input through the keyboard after you notify them with the proper message. 
# Then compare your options to decide the round's winner. 
# Show the final results after three rounds have been completed. 
# In this exercise you have to split your solutions into subroutines an ensure the integrity of the data/registers 
# when you are jumping to a functions utilizing the stack. 
#
# smtono
# ---------------------------------------------------------------------------

		.data
ask_input:	.asciiz "Enter a number by choosing from the following:\n1) Rock\n2) Paper\n3) Scissors\n"

say_winner:	.asciiz "\nThe winner is:\n"
is_tie:		.asciiz "\nTie!\n\n"

player: 	.asciiz "Player: "
neither:	.asciiz "Neither"
user: 		.asciiz "User!\n\n"
comp: 		.asciiz "Computer!\n\n"

		.text
# ---------------------------------------------------------------------------
# 			Main Driver
# ---------------------------------------------------------------------------
main:
	addi $s0, $s0, 0  	# Initialize $s0 = 0, this will serve as a loop counter
	addi $s1, $s1, 3 	# Initialize $s1 = 3, the number of rounds to take place
	addi $s2, $s2, 0	# Initialize winner, (0 tie, 1 user, 2 computer)
	addi $t1, $t1, 0	# Initialize the computer's choice

start_round:
	# Getting choices from user and computer
	jal increment_round	# Start the round by incrementing round count
	jal read_input		# Get user choice of rock, paper, or scissors
	move $t0, $v0		# Store the user's choice into a temp register
	jal get_comp_choice	# Get the computer's choice
	jal compare_choices	# Compare choices of user and computer
	jal get_winner		# Print the winner
	blt $s0, $s1, start_round
	j end_program		# End program
	
# ---------------------------------------------------------------------------
# 			Subroutines
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Adds 1 to the round counter
# ---------------------------------------------------------------------------
increment_round:
	addi $s0, $s0, 1 # Increment the round counter
	jr $ra

# ---------------------------------------------------------------------------
# Reads the input of the user and stores it into register t0
# ---------------------------------------------------------------------------
read_input:
	la $a0, ask_input 	# Load the ask_input string into a0 for a syscall
	li $v0, 4 		# Load the "print string" code into v0 for a syscall
	syscall
	
	li $v0, 5 		# Load the "read integer" code into v0 for a syscall
	syscall
	
	jr $ra			# Return value

# ---------------------------------------------------------------------------
# Returns the computer's choice, which just increments by 1 each round
# ---------------------------------------------------------------------------
get_comp_choice:
	addi $t1, $t1, 1	# Add 1 so next round what the computer chooses is different
	jr $ra			# Return value

# ---------------------------------------------------------------------------
# Compares the computer's choice against the user, returns the winner
# ---------------------------------------------------------------------------
compare_choices:
	beq $t0, $t1, tie	# If the values are equal it is a tie
	bgt $t1, $t0, greater	# If the user chose a higher value jump to greater
	blt $t1, $t0, lesser	# Else, go to lesser
lesser:
	# If the user value is lesser it is likely they lost. Unless rock was chosen and computer chose scissors
	beq $t1, 1, user_chose_rock
	# if the above statement did not branch, the computer won
	j is_comp
greater:
	# If the user value is greater it is likely they won. Unless the computer chose rock and the user chose scissors
	beq $t2, 1, comp_chose_rock
	# If the above statement did not branch, the user won
	j is_user
user_chose_rock:
	# If the user chose rock, we need to check if the computer chose scissors, if it branches, the user wins. (Rock beats scissors)
	beq $t2, 3, is_user
	# If the above statement did not branch, we know that the computer chose paper, so they win.
	j is_comp
comp_chose_rock:
	# If the comp chose rock, we need to check if the user chose scissors, if it branches, the comp wins. (Rock beats scissors)
	beq $t1, 3, is_comp
	# If the above statement did not branch, we know that the computer chose paper, so they win.
	j is_user

# The next two labels load different values into $t0 depending on who won
is_user:
	li $s3, 1		# Load user as winner
	jr $ra			# Return
is_comp:
	li $s3, 2		# Load computer as winner
	jr $ra			# Return
# If the two values are equal, there is a tie
tie:
	li $s3, 0		# Load tie
	jr $ra			# Return
	jr $ra
		
# Print out who the winner is, player user or player computer
get_winner:
	la $a0, say_winner
	li $v0, 4
	syscall
	
	la $a0, player
	li $v0, 4
	syscall
	
	# Load different winners and print depending on the value the compare_choices subroutine returned
	beq $s3, 0, neither_won
	beq $s3, 1, user_won 
	beq $s3, 2, computer_won
neither_won:
	la $a0, neither
	li $v0, 4
	syscall
	jr $ra
user_won:
	la $a0, user
	li $v0, 4
	syscall
	jr $ra
computer_won:
	la $a0, comp
	li $v0, 4
	syscall
	jr $ra

# ---------------------------------------------------------------------------
# End program
# ---------------------------------------------------------------------------
end_program:
