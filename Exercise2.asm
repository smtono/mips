# Exercise 2
# Store the following values in the memory using directives. 
# Then locate them in the memory as hexadecimal values, and share a picture of them. 
# Finally, output the values as characters using the ASCII table.  
#
#     x=5
#
#     y=16
#
#     w=23
#
# Author: smtono

.data
	x: .word 5
	y: .word 16
	w: .word 23

.text
	la $a0, x # Load the address of the label
	li $v0, 4 # Call print string
	syscall
	
	la $a0, y
	li $v0, 4
	syscall
	
	la $a0, w
	li $v0, 4
	syscall
	
	# x -> 0, NULL
	# y -> 4, EOT
	# w -> 8, Backspace
