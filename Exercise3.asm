# Exercise 3
# A source register is read during the instruction's execution, while a destination register is written during the instruction's execution. 
# Define which of the following MIPS instructions are source registers and destination registers.
# smtono

.text

loop1:
	# Source: $t2, $t3
	# Destination: $t1
	add $t1, $t2, $t3
	
	# Source: $t1
	# Destination: $t1
	add $t1, $t1, $t1
	
	# Source: $zero
	# Destination: $t3
	addi $t3, $zero, 1000
	
	# Source: $gp 
	# Destination: $t2
	lw $t2, 16($gp) 
	
	# Source: $t2
	# Destination: $s5
	sw $t2, 4($s5) 
	
	# Source: $s1, $s2
	# Destination: loop1
	bne $s1, $s2, loop1
