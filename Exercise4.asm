# Exercise 4
#
# Implement the game Rock paper scissors. 
# Each game will have 3 rounds. 
# Every round ask each user to provide as an input through the keyboard their choice. 
# Then compare choices and define the winner of the round. 
# After the completion of 3 rounds display the final results.
#
# smtono

.data
ask_input: .asciiz "Enter a number by choosing from the following:\n1) Rock\n2) Paper\n3) Scissors\n"

say_winner: .asciiz "\nThe winner is:\n"
is_tie: .asciiz "\nTie!\n\n"

player: .asciiz "Player: "
user: .asciiz "User!\n\n"
comp: .asciiz "Computer!\n\n"

.text
addi $s0, $s0, 0  # Initialize $s0 = 0, this will serve as a loop counter
addi $s1, $s1, 3 #Initialize $s1 = 3, the number of rounds to take place

game:
	addi $s0, $s0, 1 # Increment the round counter
	ble $s0, $s1, read_input
	j end_program # If the above statement did not jump we must end the program.

# Reads the input of the user and stores it into register t0
read_input:
	la $a0, ask_input # Load the ask_input string into a0 for a syscall
	li $v0, 4 # Load the "print string" code into v0 for a syscall
	syscall
	
	li $v0, 5 # Load the "read integer" code into v0 for a syscall
	syscall
	move $t1, $v0 # Moving the user input into register $t1 to use
	
	# Branch to different labels depending on the round
	beq $s0, 1, compare_round_one
	beq $s0, 2, compare_round_two
	beq $s0, 3, compare_round_three
	
# Compare the user input vs. the computer input to determine the winner
compare_round_one:
	li $t2, 1 # Computer chooses rock
	beq $t1, $t2, tie
	bgt $t1, $t2, greater
	j lesser

compare_round_two:
	li $t2, 2 # Computer chooses paper
	beq $t1, $t2, tie
	bgt $t1, $t2, greater
	j lesser

compare_round_three:
	li $t2, 3 # Computer chooses scissors
	beq $t1, $t2, tie
	bgt $t1, $t2, greater
	j lesser

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
	li $t0, 1
	j get_winner

is_comp:
	li $t0, 2
	j get_winner
	
# If the two values are equal, there is a tie
tie:
	la $a0, is_tie
	li $v0, 4
	syscall
	
	j game # Go back to the start of the game
		
# Print out who the winner is, player user or player computer
get_winner:
	la $a0, say_winner
	li $v0, 4
	syscall
	
	la $a0, player
	li $v0, 4
	syscall
	
	beq $t0, 1, user_won # Branch if the user won ($t0 is set to 1)
	beq $t0, 2, computer_won

user_won:
	la $a0, user # We store the winner in t0
	li $v0, 4
	syscall
	
	j game # Go back to the start of the game

computer_won:
	la $a0, comp # We store the winner in t0
	li $v0, 4
	syscall
	
	j game # Go back to the start of the game

end_program: