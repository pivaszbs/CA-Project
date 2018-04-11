.data
	space: .asciiz " "
	size: .word 10
	A: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99
	B: .word 100, 99, 98, 97, 96, 95, 94, 93, 92, 91, 90, 89, 88, 87, 86, 85, 84, 83, 82, 81, 80, 79, 78, 77, 76, 75, 74, 73, 72, 71, 70, 69, 68, 67, 66, 65, 64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
	C: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
.text
main:
	la $s0, A		# Loads address of array A
	la $s1, B		# Loads address of array B
	la $s2, C		# Loads address of array C
	lw $s3, size

	li $t4, -1
	j first_loop
	
	return_point:
	mult $s3, $s3
	mflo $t2
	li $t0, 0	
	j print_C
	
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
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal get_index	
	
	add $t2, $t2, $t2		# multiplies $t2 by 4
	add $t2, $t2, $t2	
	add $t2, $t2, $s0	
	lw $t2, 0($t2)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
# Takes in $t0 and $t1 as two indexes of two-dimensional array
# Returns $t2 as value with given indixes in array B
get_B_value_by_index:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal get_index
		
	add $t2, $t2, $t2		# multiplies $t2 by 4
	add $t2, $t2, $t2	
	add $t2, $t2, $s1	
	lw $t2, 0($t2)	
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
# Takes in $t0 and $t1 as two indexes of two-dimensional array
# Sets value $t3 in the element of array C with given indexes
set_C_value_by_index:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal get_index
	
	add $t2, $t2, $t2		# multiplies $t2 by 4
	add $t2, $t2, $t2	
	add $t2, $t2, $s2
	sw $t3, 0($t2)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# Keep current i counter in $t4
first_loop:
	addi $t4, $t4, 1
	beq $t4, $s3, return_point
	li $t5, -1	
		
	j second_loop	

# Keep current j counter in $t5
second_loop:
	addi $t5, $t5, 1
	beq $t5, $s3, first_loop
	li $t6, -1
	li $t3, 0	
	
	j third_loop
	
	return_to_second_loop:	
	move $t0, $t4
	move $t1, $t5
	jal set_C_value_by_index
	
	j second_loop

# Keep current k counter in $t6
third_loop:
	addi $t6, $t6, 1
	beq $t6, $s3, return_to_second_loop	

	move $t0, $t4
	move $t1, $t6
	jal get_A_value_by_index
	li $t7, 0
	add $t7, $t7, $t2
	
	move $t0, $t6
	move $t1, $t5
	jal get_B_value_by_index
	mult $t7, $t2
	mflo $t7
	add $t3, $t3, $t7
	
	j third_loop

print_C:	
	beq $t0, $t2, exit
	
	move $t1, $t0	
	add $t1, $t1, $t1
	add $t1, $t1, $t1
	add $t1, $t1, $s2
	
	lw $a0, 0($t1)
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $t0, $t0, 1
	j print_C
			
exit:
	li $v0, 10
	syscall
