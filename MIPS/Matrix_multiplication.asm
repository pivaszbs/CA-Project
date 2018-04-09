.data
	size: .word 3
	A: .word 9, 8, 7, 6, 5, 4, 3, 2, 1
	B: .word 1, 0, 0, 0, 1, 0, 0, 0, 1
	C: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
.text
main:
	la $s0, A		# Loads address of array A
	la $s1, B		# Loads address of array B
	la $s2, C		# Loads address of array C
	lw $s3, size

	li $t4, 0
	j first_loop
	
	return_point:
		
	j exit
	
# Takes in $t0 and $t1 as two indexes of two-dimensional array
# Returns $t2 as index in one-dimensional array
get_index:
	mult $t0, $s3
	mflo $t2
	add $t2, $t2, $t1

	jr $ra
	
# Takes in $t0 and $t1 as two indexes of two-dimensional array
# Returns $t2 as value with given indicies in array A
get_A_value_by_index:
	addi $sp, -4
	sw $ra, 0($sp)
	
	jal get_index	
	
	add $t2, $t2, $t2		# multiplies $t2 by 4
	add $t2, $t2, $t2	
	add $t2, $t2, $s0	
	lw $t2, 0($t2)	
	
	lw $ra, 0($sp)
	addi $sp, 4
	jr $ra
	
# Takes in $t0 and $t1 as two indexes of two-dimensional array
# Returns $t2 as value with given indixes in array B
get_B_value_by_index:
	addi $sp, -4
	sw $ra, 0($sp)
	
	jal get_index
		
	add $t2, $t2, $t2		# multiplies $t2 by 4
	add $t2, $t2, $t2	
	add $t2, $t2, $s1	
	lw $t2, 0($t2)	
	
	lw $ra, 0($sp)
	addi $sp, 4
	jr $ra
	
# Takes in $t0 and $t1 as two indexes of two-dimensional array
# Sets value $t3 in the element of array C with given indexes
set_C_value_by_index:
	addi $sp, -4
	sw $ra, 0($sp)
	
	jal get_index
	
	add $t2, $t2, $t2		# multiplies $t2 by 4
	add $t2, $t2, $t2	
	add $t2, $t2, $s2
	sw $t3, 0($t2)
	
	lw $ra, 0($sp)
	addi $sp, 4
	jr $ra

# Keep current i counter in $t4
first_loop:
	beq $t4, $s3, return_point
	
			
exit:
	li $v0, 10
	syscall