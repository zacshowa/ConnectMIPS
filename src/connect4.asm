#Name: Zach Showalter
#Section: section 1
#Description: runs a fun game of text based connect 4 on the terminal
#
P_BOARD_FRAMESIZE = 16
A_FRAMESIZE = 40
PRINT_CHAR = 11
PRINT_STRING = 4
PRINT_INT = 1
EXIT_CODE = -1
MAX_ROW = 5 	#these are for checking for the win
MAX_COL = 6	# they are technically one less than the dimensions of the
WIN_NUM = 4	#board, however that allows me to just branch out of the loop
		#when an iteration count is equal to them instead of having to
		#do many slt comparisons 
	.data
	.align 2
board_array: 	#create an array in memory of the different row arrays
	.word	row5
	.word	row4
	.word	row3
	.word	row2
	.word	row1
	.word	row0
row5:
	.word 	0, 0, 0, 0, 0, 0, 0 	#row arrays, 0 represents a spacem
					# 1 reprsents X, 2 represents O
row4:
	.word	0, 0, 0, 0, 0, 0, 0
row3:
	.word	0, 0, 0, 0, 0, 0, 0
row2:
	.word	0, 0, 0, 0, 0, 0, 0
row1:
	.word	0, 0, 0, 0, 0, 0, 0
row0:
	.word	0, 0, 0, 0, 0, 0, 0

	.align 0 # upcoming strings for printing board,so no align needed
welcome_message_1:
	.asciiz "   ************************\n"
welcome_message_2:
	.asciiz "   **    Connect Four    **\n"
newline:
	.asciiz "\n"
col_nums:
	.asciiz "   0   1   2   3   4   5   6\n"
top_border:
	.asciiz "+-----------------------------+\n"
top_non_square:
	.asciiz "|+---+---+---+---+---+---+---+|\n"
square_row:
	.asciiz	"||   |   |   |   |   |   |   ||\n"
space_char:
	.asciiz	" "
x_char:
	.asciiz	"X"
o_char:
	.asciiz "O"
p_1_message:
	.asciiz "Player 1: select a row to place your coin (0-6 or -1 to quit):"
p_2_message:
	.asciiz "Player 2: select a row to place your coin (0-6 or -1 to quit):"
illegal_col:
	.asciiz	"Illegal column number."
col_full:
	.asciiz	"Illegal move, no more room in that column."
P_1_WIN:
	.asciiz	"Player 1 wins!"
P_2_WIN:
	.asciiz	"Player 2 wins!"
board_full_m:
	.asciiz	"The game ends in a tie."
p_2_quit_m:
	.asciiz	"Player 2 quit."
p_1_quit_m:
	.asciiz "Player 1 quit."

	.text
	.align 2
	.globl 	main

main:
	addi	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$s2, 0($sp)

	li	$v0, PRINT_STRING
	la	$a0, welcome_message_1
	syscall
	
	li	$v0, PRINT_STRING
	la	$a0, welcome_message_2
	syscall
	
	li	$v0, PRINT_STRING
	la	$a0, welcome_message_1
	syscall
	
	jal	p_board
	li	$s0, 0
input_loop:	#main input loop for the program handles relatively simple logic
	
	beq	$s0, $zero, p_1
	bne	$s0, $zero, p_2
p_1: #handle input for player 1
	li	$v0, PRINT_STRING
	la	$a0, p_1_message
	syscall
	
	jal	get_input
	move	$s1, $v0
	
	li	$t0, EXIT_CODE
	beq	$s1, $t0, p_1_quit
	move	$a0, $s1
	la	$a1, board_array
	
	jal	check_input
	
	bne	$v0, $zero, p_1
	la	$a0, board_array
	li	$a1, 1
	move	$a2, $s1
	jal	add_input
	li	$a0, 1
	move	$a1, $v1
	move	$a2, $v0
	jal 	check_win
	move	$s7, $v0
p_1_done: # come here when p1 is done with turn

	li	$s0, 1 #switch flag to go to p_2 next time
	jal	p_board
	bne	$s7, $zero, p_1_win
	jal	is_board_full
	bne	$v0, $zero, board_full
	j	input_loop
p_1_quit: #handeles the case where p1 quits
	li	$v0, PRINT_STRING
	la	$a0, p_1_quit_m
	syscall
	
	li	$v0, PRINT_STRING
	la	$a0, newline
	syscall

	j	input_loop_done
p_1_win: #handles the case where p1 wins
	li	$v0, PRINT_STRING
	la	$a0, P_1_WIN
	syscall

	li	$v0, PRINT_STRING
	la	$a0, newline
	syscall

	j	input_loop_done

p_2:	#handles logic for p2 it does the same stuff as p1 but prints outputs
	# for p 2 and calls some functions with input for p2
	li	$v0, PRINT_STRING
	la	$a0, p_2_message
	syscall
	
	jal 	get_input
	move	$s1, $v0
	
	li 	$t0, EXIT_CODE
	beq	$s1, $t0, input_loop_done
	move	$a0, $s1
	la	$a1, board_array
	
	jal	check_input

	bne	$v0, $zero, p_2
	la	$a0, board_array
	li	$a1, 2
	move	$a2, $s1
	jal	add_input
	li	$a0, 2
	move	$a1, $v1
	move	$a2, $v0
	jal	check_win	
	move	$s7, $v0
p_2_done: 
	li	$s0, 0
	jal	p_board
	bne	$s7, $zero, p_2_win
	jal 	is_board_full
	bne 	$v0, $zero, board_full
	j 	input_loop
p_2_quit:
	li	$v0, PRINT_STRING
	la	$a0, p_2_quit_m
	syscall
	
	li	$v0, PRINT_STRING
	la	$a0, newline
	syscall
	
	j	input_loop_done
p_2_win:
	li	$v0, PRINT_STRING
	la	$a0, P_2_WIN
	syscall

	li	$v0, PRINT_STRING
	la	$a0, newline
	syscall

	j	input_loop_done
board_full: #handles the case that the board is full
	li	$v0, PRINT_STRING
	la	$a0, board_full_m
	syscall
	j	input_loop_done
input_loop_done:
	j 	main_done
#
#Name:is_board_full
#Description:	returns 1 if board is full, if it is not returns 0
#
#
#
is_board_full:
	addi	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$s2, 0($sp)
	la	$s0, board_array
	lw	$t1, 0($s0)	#t1 contains top row
	li	$a1, 0
	li	$s1, 0
	li	$s2, MAX_COL
is_board_full_loop:
	beq	$s1, $s2, board_is_full
	move	$a0, $s0
	move	$a2, $s1
	jal 	read_board
	beq	$v0, $zero, board_not_full
	addi	$s1, $s1, 1
	j	is_board_full_loop
board_is_full:
	li	$v0, 1
	j	is_board_full_done
board_not_full:
	li	$v0, 0
	j is_board_full_done
is_board_full_done:
	lw	$ra, 12($sp)
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$s2, 0($sp)
	addi	$sp, $sp, 8
	jr	$ra
#
#Name: check_input
#Description: checks if input is valid
#Params:	a0 - user input
#		a1 -2d board array
#Return:	v0 = 0 There is no error
#		v0 = 1 There is an error	
#	
check_input:

	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	li	$t0, 7
	li	$t1, -1
	slt	$t2, $t1, $a0
	beq	$t2, $zero, invalid_col_e #if input is not between 1 and 7
					  #it is out of bounds
	slt	$t2, $a0, $t0
	beq	$t2, $zero, invalid_col_e
	lw	$t3, 0($a1)
	li	$t4, 4
	mul	$t5, $a0, $t4
	add	$t3, $t3, $t5
	lw	$t6, 0($t3)
	sub	$t3, $t3, $t5
	bne	$t6, $zero, col_full_e
	j	no_error

invalid_col_e:

	li	$v0, PRINT_STRING
	la	$a0, illegal_col
	syscall

	li	$v0, PRINT_STRING
	la	$a0, newline
	syscall

	li	$v0, 1
	j	check_done

col_full_e:

	li	$v0, PRINT_STRING #handle 2 required erros
	la	$a0, col_full
	syscall

	li	$v0, PRINT_STRING
	la	$a0, newline
	syscall
	
	li	$v0, 1 
	j	check_done

no_error:
	li	$v0, 0	 #if there is no error return 0
	j	check_done 	#not needed in single file implementation
				#however might be used when project
				#is split into multiple files

check_done:
	lw	$ra, 0($sp)
	addi	$sp, $sp, -4	#grab ra from stack and return
	jr	$ra	
#
#Name: get_input
#Description: gets an integer from the user
#Return: returns int user input in v0
#	
get_input:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	li	$v0, 5
	syscall

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	
	jr $ra
#
#Name: add_input
#Description: puts the users peice in the correct spot on the board
#Params:	a0: board array pointer
#		a1: int represnting which player last moved.
#		a2: int represnting which column the play er chose
#Return: 	v0 = column of last coin played
#		v1 = row of last coin played
#

add_input:
	addi	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$s2, 0($sp)
	li	$t0, 4
	mul	$s1, $t0, $a2 #store the offset of column to check in s1
	li	$t1, 0	#which row of the board to be looking at
	li	$t4, 6
add_input_loop:
	slt	$t3, $t1, $t4
	beq	$t3, $zero, insert_input
	mul	$t2, $t1, $t0
	add	$a0, $a0, $t2
	lw	$s0, 0($a0)
	sub	$a0, $a0, $t2
	add	$s0, $s0, $s1
	lw	$s2, 0($s0)
	sub	$s0, $s0, $s1
	bne	$s2, $zero, insert_input
	addi	$t1, $t1, 1	
	j	add_input_loop
insert_input:
	addi	$t1, $t1, -1
	move	$v1, $t1
	mul	$t2, $t1, $t0
	add	$a0, $a0, $t2
	lw	$s0, 0($a0)
	sub	$a0, $a0, $t2
	add	$s0, $s0, $s1
	sw	$a1, 0($s0)
	sub	$s0, $s0, $s1
	j	add_input_done
	
add_input_done:
	move	$v0, $a2
	
	lw	$ra, 12($sp)
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$s2, 0($sp)
	addi	$sp, $sp, 16
	jr 	$ra	

#
#Name: read_board
#Description: Reads from the board at a position and returns the value present
#Param:		a0 - pointer to board array
#		a1 - int of row to check
#		a2 - int of col to check
#Return:	v0 = value in board at pos (a2, a1)
#
#
read_board:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	li	$t0, 4
	move	$t1, $a1
	mul	$t2, $t0, $t1
	add	$a0, $a0, $t2	#get the correct row offset in board pointer
	lw	$t3, 0($a0)	#t3 has addres of row to be checking
	sub	$a0, $a0, $t2
	mul	$t4, $t0, $a2
	add	$t3, $t3, $t4	#get proper offset into row pointer
	lw	$v0, 0($t3)	#load the result into v0 for returning
	sub	$t3, $t3, $t4

	j	read_done	#return (the jump is really not needed
				#just as the label is not needed but it helps
				#with readability and to section off all stack
				#operations
read_done:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	
	jr	$ra
#
#name: is_players_coin:
#description: determines if coin at pos on board is belongs to player specified
#return:	v0 = 0 if it is not
#		v0 = 1 if it is.
#param:		a0, row of coin
#		a1, col of coin
#		a2, player to compare to.
#
is_players_coin:
	addi	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$s0, 0($sp)
	move 	$s0, $a2
	move	$a2, $a1
	move	$a1, $a0
	la	$a0, board_array
	jal	read_board
	beq	$s0, $v0, is_players
	bne	$s0, $v0, is_not_players
is_players:
	li	$v0, 1
	j	done_is_players_coin
is_not_players: 
	li	$v0, 0
	j	done_is_players_coin
done_is_players_coin:
	lw	$s0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
#
#Name: check_sub_win
#Description: checks a specific win case for use in the check win function
#Param:		a0 - coin  row pos
#		a1 - coin col pos
#		a2 - situation to fix inputs. 0, 1, 2, or 3	
#		a3 - num of player that last placed coin
#Return: 	v0 - 1 if player won, 0 if not
#
check_sub_win:
	addi	$sp, $sp, -32
	sw	$ra, 28($sp)
	sw	$s0, 24($sp)
	sw	$s1, 20($sp)
	sw	$s2, 16($sp)
	sw	$s3, 12($sp)
	sw	$s4, 8($sp)
	sw	$s5, 4($sp)
	sw	$s6, 0($sp) 
	move	$s1, $a0 #initial coin row
	move	$s2, $a1 #initial coin col
	move 	$s3, $a0 #current coin row
	move	$s4, $a1 #current coin col
	li	$t7, 3
	li	$t6, 2
	li	$t5, 1
	li	$t4, 0
	li	$s5, 0	#counter for num of coins
	li	$s0, 3	#max val to search in a direction
	li	$s6, 0 #number of coins owned by player in a row
	beq	$a2, $t4, left_loop
	beq	$a2, $t5, up_loop
	beq	$a2, $t6, left_up_loop
	beq	$a2, $t7, right_up_loop
left_loop:	#each loop like this checks 3 past where the coin is in a
		# direction and them returns 1 from the function if there
		#is a valid winning condition they all check one direction
		#and then the other direction to see if there is a win where
		#the new coin is in the middle of the 4 connected coins
	addi	$s4, $s4, -1
	slt	$t1, $s4, $zero
	slt	$t2, $s5, $s0
	bne	$t1, $zero, end_left_loop
	beq	$t2, $zero, end_left_loop
	beq	$s6, $s0, end_loop 
	move	$a0, $s3
	move	$a1, $s4
	move	$a2, $a3
	jal	is_players_coin
	addi	$s5, $s5, 1
	beq	$v0, $zero, end_left_loop
	addi	$s6, $s6, 1 
	j	left_loop
end_left_loop:
	move	$s3, $s1
	move	$s4, $s2
	li	$s5, 0
right_loop:
	addi	$s4, $s4, 1
	li	$t3, MAX_COL
	slt	$t1, $t3, $s4
	slt	$t2, $s5, $s0
	beq	$s6, $s0, end_loop
	bne	$t1, $zero, end_loop
	beq	$t2, $zero, end_loop
	move	$a0, $s3
	move	$a1, $s4
	move	$a2, $a3
	jal	is_players_coin
	addi	$s5, $s5, 1
	beq	$v0, $zero, end_loop
	addi	$s6, $s6, 1
	j	right_loop
up_loop:
	addi	$s3, $s3, -1
	slt	$t1, $s3, $zero
	slt	$t2, $s5, $s0
	beq	$s6, $s0, end_loop
	bne	$t1, $zero, end_up_loop
	beq	$t2, $zero, end_up_loop 
	move	$a0, $s3
	move	$a1, $s4
	move	$a2, $a3
	jal	is_players_coin
	addi	$s5, $s5, 1
	beq	$v0, $zero, end_up_loop
	addi	$s6, $s6, 1 
	j	up_loop
end_up_loop:
	move	$s3, $s1
	move	$s4, $s2
	li	$s5, 0
down_loop:
	addi	$s3, $s3, 1
	li	$t3, MAX_ROW
	slt	$t1, $t3, $s3
	slt	$t2, $s5, $s0
	beq	$s6, $s0, end_loop
	bne	$t1, $zero, end_loop
	beq	$t2, $zero, end_loop
	move	$a0, $s3
	move	$a1, $s4
	move	$a2, $a3
	jal	is_players_coin
	addi	$s5, $s5, 1
	beq	$v0, $zero, end_loop
	addi	$s6, $s6, 1 
	j	down_loop

left_up_loop:
	addi	$s3, $s3, -1
	addi	$s4, $s4, -1
	slt	$t1, $s3, $zero
	slt	$t2, $s5, $s0
	slt	$t4, $s4, $zero
	beq	$s6, $s0, end_loop
	bne	$t1, $zero, end_left_up_loop
	beq	$t2, $zero, end_left_up_loop
	bne	$t4, $zero, end_left_up_loop
	move	$a0, $s3
	move	$a1, $s4
	move	$a2, $a3
	jal	is_players_coin
	addi	$s5, $s5, 1
	beq	$v0, $zero, end_left_up_loop
	addi	$s6, $s6, 1
	j	left_up_loop
end_left_up_loop:
	move	$s3, $s1
	move	$s4, $s2
	li	$s5, 0
right_down_loop:
	addi	$s3, $s3, 1
	addi	$s4, $s4, 1
	li	$t3, MAX_ROW
	li	$t5, MAX_COL
	slt	$t1, $t3, $s3
	slt	$t2, $s5, $s0
	slt	$t4, $t5, $s4
	beq	$s6, $s0, end_loop
	bne	$t1, $zero, end_loop
	beq	$t2, $zero, end_loop
	bne	$t4, $zero, end_loop
	move	$a0, $s3
	move	$a1, $s4
	move	$a2, $a3
	jal	is_players_coin
	addi	$s5, $s5, 1
	beq	$v0, $zero, end_loop
	addi	$s6, $s6, 1
	j	right_down_loop
right_up_loop:
	addi	$s3, $s3, -1
	addi	$s4, $s4, 1
	li	$t3, MAX_COL
	slt	$t1, $s3, $zero
	slt	$t2, $s5, $s0
	slt	$t4, $t3, $s4
	beq	$s6, $s0, end_loop
	bne	$t1, $zero, end_right_up_loop
	beq	$t2, $zero, end_right_up_loop
	bne	$t4, $zero, end_right_up_loop
	move	$a0, $s3
	move	$a1, $s4
	move	$a2, $a3
	jal	is_players_coin
	addi	$s5, $s5, 1
	beq	$v0, $zero, end_right_up_loop
	addi	$s6, $s6, 1
	j	right_up_loop
end_right_up_loop:
	move	$s3, $s1
	move	$s4, $s2
	li	$s5, 0
left_down_loop:
	addi	$s3, $s3, 1
	addi	$s4, $s4, -1
	li	$t3, MAX_ROW
	slt	$t1, $t3, $s3
	slt	$t2, $s5, $s0
	slt	$t4, $s4, $zero
	beq	$s6, $s0, end_loop
	bne	$t1, $zero, end_loop
	beq	$t2, $zero, end_loop
	bne	$t4, $zero, end_loop
	move	$a0, $s3
	move	$a1, $s4
	move	$a2, $a3
	jal	is_players_coin
	addi	$s5, $s5, 1
	beq	$v0, $zero, end_loop
	addi	$s6, $s6, 1
	j	left_down_loop
end_loop:
	beq	$s6, $s0, won
	li	$v0, 0
	j end_check_sub_win
won:
	li	$v0, 1
	j end_check_sub_win
end_check_sub_win:
	lw	$ra, 28($sp)
	lw	$s0, 24($sp)
	lw	$s1, 20($sp)
	lw	$s2, 16($sp)
	lw	$s3, 12($sp)
	lw	$s4, 8($sp)
	lw	$s5, 4($sp)
	lw	$s6, 0($sp) 
	addi	$sp, $sp, 32
	jr	$ra
#
#Name: check_win
#Description: checks if the last player to go won the game
#Param:		a0- last player to place a piece
#		a1- row of last piece played
#		a2- column of last piece played
#Return:	v0 = 1 if last player won
#		v0 = 0 if last player did not win
#
#
check_win:
	addi	$sp, $sp, -32
	sw	$ra, 28($sp)
	sw	$s0, 24($sp)	
	sw	$s1, 20($sp)	
	sw	$s2, 16($sp)	
	sw	$s3, 12($sp)
	sw	$s4, 8($sp)	#type of win to be checking for 1= left rigth
				#2 = up down, 3 = left right diag
				#4 = right left diag.
				#check from one furthest possible point from
				#last played coin to other for a simpler
				#algorithm. it does some unneeded array access
				#but makes loops simpler ( i think)
	sw	$s5, 4($sp)	#counter maximum	#which win type to check 1,2,3, or 4
	sw	$s6, 0($sp)	#iter var

	li	$s5, 3
	li	$s6, 0
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
check_loop:
	beq	$s5, $s6, check_loop_done
	move	$a3, $s0
	move	$a0, $s1
	move	$a1, $s2
	move 	$a2, $s6
	jal	check_sub_win
	bne	$v0, $zero, check_loop_done
	addi	$s6, $s6, 1
	j 	check_loop
check_loop_done:
	beq	$v0, $zero, check_win_done
	bne	$v0, $zero, player_won 
player_won:
	li	$v0, 1
check_win_done:
	lw	$ra, 28($sp)
	lw	$s0, 24($sp)
	lw	$s1, 20($sp)
	lw	$s2, 16($sp)
	lw	$s3, 12($sp)
	lw	$s4, 8($sp)
	lw	$s5, 4($sp)
	lw	$s6, 0($sp)
	addi	$sp, $sp, 32
	jr	$ra
#Name:p_board
#Description:	Prints out the board graphics and all of the data in the
#		boards array in its appropriate place.
p_board:
	addi	$sp, $sp, -P_BOARD_FRAMESIZE
	sw	$ra, -4+P_BOARD_FRAMESIZE($sp)
	sw	$s5, 8($sp)
	sw	$s4, 4($sp)
	sw	$s0, 0($sp)
	li	$v0, PRINT_STRING
	la	$a0, newline
	syscall

	li	$v0, PRINT_STRING	#print the initial part of the board
	la	$a0, col_nums
	syscall

	li	$v0, PRINT_STRING
	la	$a0, top_border
	syscall

	li	$v0, PRINT_STRING
	la	$a0, top_non_square
	syscall

	li	$s4, 0	# index for row to print from
	la	$s5, board_array
	li	$s0, 24
p_loop:
	beq	$s4, $s0, p_loop_done
	add	$s5, $s5, $s4
	lw	$a0, 0($s5)	#contains address of row array to print from
				# for this loop iteration
	sub	$s5, $s5, $s4
	la	$a1, square_row
	jal	p_row
	
	li	$v0, PRINT_STRING
	la	$a0, top_non_square
	syscall
	addi	$s4, $s4, 4
	j	p_loop
	
p_loop_done:
	li	$v0, PRINT_STRING
	la	$a0, top_border
	syscall
	
	li	$v0, PRINT_STRING
	la	$a0, col_nums
	syscall

	li	$v0, PRINT_STRING
	la	$a0, newline
	syscall

	lw	$s0, 0($sp)
	lw	$s4, 4($sp)
	lw	$s5, 8($sp)
	lw	$ra, -4+P_BOARD_FRAMESIZE($sp)
	addi	$sp, $sp, P_BOARD_FRAMESIZE
	jr	$ra
#
# Name:         p_row
# Description:  prints a single row with data from the board
# Arguments:    a0:     address of board row to print
#               a1:     address of square_row string
# Returns:      none
# Destroys:     none
#
	
p_row: 
        addi    $sp, $sp, -A_FRAMESIZE
        sw      $ra, -4+A_FRAMESIZE($sp)
        sw      $s7, 28($sp)
        sw      $s6, 24($sp)
        sw      $s5, 20($sp)
        sw      $s4, 16($sp)
        sw      $s3, 12($sp)
        sw      $s2, 8($sp)
        sw      $s1, 4($sp)
        sw      $s0, 0($sp)
			#print the rows with squares in them
	li	$s0, 0	#index for printing from square row
	li	$s1, 0	#index for printing from row
	li	$s2, 0	#index for how deciding when to print  from row
	li	$s3, 3 	#imm number to decide to print from row or not
	move	$s6, $a0
	move	$s7, $a1
	li	$t3, 31
p_row_loop:
	beq	$s0, $t3, p_row_done
	beq	$s2, $s3, p_from_row
	add	$s7, $s7, $s0
	li	$v0, PRINT_CHAR
	lb	$a0, 0($s7)
	syscall
	sub	$s7, $s7, $s0
	addi	$s2, $s2, 1 	#add to index for deciding to print from row
	addi	$s0, $s0, 1	#add to index of square row array
	j p_row_loop
p_row_done:
	li	$v0, PRINT_STRING
	la	$a0, newline
	syscall

        lw      $ra, -4+A_FRAMESIZE($sp)
        lw      $s7, 28($sp)
        lw      $s6, 24($sp)
        lw      $s5, 20($sp)
        lw      $s4, 16($sp)
        lw      $s3, 12($sp)
        lw      $s2, 8($sp)
        lw      $s1, 4($sp)
        lw      $s0, 0($sp)
        addi    $sp, $sp, A_FRAMESIZE

	jr	$ra
p_from_row:
	add	$s6, $s6, $s1
	lw	$t0, 0($s6)
	sub	$s6, $s6, $s1
	li	$t1, 1
	li	$t2, 2
	beq	$t0, $zero, p_space
	beq	$t0, $t1, p_x
	beq	$t0, $t2, p_o 
p_x: #used by p from row to  print an x char
	li	$v0, PRINT_STRING
	la	$a0, x_char
	syscall
	addi	$s1, $s1, 4
	addi	$s0, $s0, 1
	li	$s2, 0
	j	p_row_loop
p_o:#	used by p from row to print an o char
	li	$v0, PRINT_STRING
	la	$a0, o_char 
	syscall
	addi	$s1, $s1, 4
	addi	$s0, $s0, 1
	li	$s2, 0
	j	p_row_loop
p_space:	#used by pboard to print a space char
	li	$v0, PRINT_STRING
	la	$a0, space_char
	syscall
	addi	$s1, $s1, 4
	addi	$s0, $s0, 1
	li	$s2, 0
	j	p_row_loop
main_done: #called by input loop done to exit the program at appropriate time.
	lw	$ra, 12($sp)
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$s2, 0($sp)
	addi	$sp, $sp, 16
	li	$v0, 10
	syscall
