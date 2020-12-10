#####################################################################
#
# CSC258H5S Fall 2020 Assembly Final Project
# University of Toronto, St. George
#
# Student: Yosi Hatekar, 1004714909
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# - Milestone 2?
#####################################################################
##### MACROS START HERE #####
.macro pushStack
addi $sp, $sp, -4
sw $ra, 0($sp)
.end_macro

.macro popStack
lw $ra, 0($sp)
addi $sp, $sp, 4
.end_macro

.macro sleep (%time)
li $v0, 32
li $a0, %time
syscall
.end_macro	

.macro print (%value)
li $v0, 1
move $a0, %value
syscall
.end_macro
####################################################################
.data
	displayAddress: .word 0x10008000
	#Colours:
	sky: .word 0x00FFFFFF
	doodleBot: .word 0x00FFDD3C
	platform: .word 0x0092DFF3
	#Inputs:
	left: .word 0x6A
	right: .word 0x6B
	start: .word 0x73
	#Positions:
	doodleX: .space 4
	doodleY: .space 4
	platformPosition: .space 4
	#Physics:
	maxJump: .word 0x4
	collision: .word 0x0
.text
main:
#### PROGRAM RUNS HERE ####
startScreen:
jal drawBackground
jal generateRandom
jal drawPlatform
addi $t0, $zero, 2
addi $t1, $zero, 28
sw $t0, doodleX
sw $t1, doodleY
jal drawDoodle
sleep (1000)
j checkInput

checkInput: #checks for any keyboard input and acts accordingly.
jal jump
lw $t8, 0xffff0000 #checks for any input
beq $t8, 1, checkKey #if there is input, moves to check which key
j checkInput
checkKey:
lw $t2, 0xffff0004
lw $t3, start
lw $t4, left
lw $t5, right 
beq $t2, $t3, startScreen
beq $t2, $t4, moveLeft
beq $t2, $t5, moveRight
j checkInput

moveLeft:
jal moveLeftFunc
j checkInput

moveRight:
jal moveRightFunc
j checkInput

li $v0, 10 #terminate the program gracefully
syscall
##### FUNCTIONS START HERE #####
moveLeftFunc:
lw $t0, doodleX
subi $t0, $t0, 1
sw $t0, doodleX
jr $ra

moveRightFunc:
lw $t0, doodleX
addi $t0, $t0, 1
sw $t0, doodleX
jr $ra

jump:
addi $sp, $sp, -8
sw $ra, 0($sp)

lw $a1, doodleY
lw $t0, maxJump
lw $t1, collision
addi $t2, $zero, 1
print ($t0)
beq $a1, $t0, fallCode
beq $t1, $t0, climbCode
lw $ra, 0($sp)
addi $sp, $sp, 8
jr $ra

climbCode:
jal climb

fallCode:
jal fall

climb:
sleep (300)
addi $sp, $sp, -4
sw $ra, -4($sp)

lw $a0, doodleX
lw $a1, doodleY
subi $a1, $a1, 1
sw $a1, doodleY
jal drawBackground
jal drawPlatform
jal drawDoodle

lw $ra, -4($sp)
addi $sp, $sp, 4
jr $ra

fall:
sleep (300)
addi $sp, $sp, -4
sw $ra, -4($sp)

lw $a0, doodleX
lw $a1, doodleY
addi $a1, $a1, 1
sw $a1, doodleY
jal drawBackground
jal drawPlatform
jal drawDoodle

lw $ra, -4($sp)
addi $sp, $sp, 4
jr $ra



drawBackground: #colours the whole screen with colour sky. No arguments. No returns.
lw $t0, displayAddress #$t0 stores the base address for display
lw $t1, sky #stores the sky colour code in $t1
add $t2, $zero, $zero #store 0 in $t2/ i=0
addi $t3, $zero, 1024 #store 1024 in $t3, which is the total units on display
add $t4, $zero, $t0 #store displayAddress in $t4 to edit
drawLoop:
	beq $t2, $t3, drawExit #stop loop when $t2==$t3/ while i!=1024:
	sw $t1, ($t4) #store sky colour in the new memoryAddress
	addi $t2, $t2, 1 #increment $t2 by 1/ i+=1
	sll $t4, $t2, 2 #$t4 = 4*$t2/ 4*i
	add $t4, $t4, $t0 #$t4 = i + displayAddress = new memoryAddress of each unit
	j drawLoop #loops back to branch statement
drawExit:
jr $ra #goes back to the location of function call


drawPlatform: #draws a single platform 8 units long. 1 argument of starting coordinate in $a0. No returns.
lw $t0, displayAddress # $t0 stores the base address for display
lw $t9, platformPosition
add $t0, $t0, $t9 #change the value of memory to new co-ordinate (instead of base), stored in $a0
lw $t1, platform #stores the platform colour code in $t1
add $t2, $zero, $zero #store 0 in $t2/i=0
addi $t3, $zero, 8 #store 10 in #$t3, which is the platform length
add $t4, $zero, $t0 #store displayAddress in $t4 to edit
platLoop:
	beq $t2, $t3, platExit #stop loop when $t2==$t3/ while i!=8
	sw $t1, ($t4) #store platform colour in the new memoryAddress
	addi $t2, $t2, 1 #increment $t2 by 1/ i+=1
	sll $t4, $t2, 2 #$t4 = 4*$t2/ 4*i
	add $t4, $t4, $t0 #$t4 = i + displayAddress = new memoryAddress of each unit
	j platLoop
platExit:
jr $ra #goes back to the location of function call


generateRandom: #generates a random position for the platform to spawn. No arguments. 1 return of position in $a0.
li $v0, 42 #load service 42 into system for random number generation with range
li $a0, 0 #type of number generation (don't change!)
li $a1, 25 #store max number such that x < 25
syscall
sll $t0, $a0, 2 #store the random number = 4x
li $v0, 42 #load service 42 into system for random number generation with range
li $a0, 0 #type of number generation (don't change!)
li $a1, 32 #store max number such that y < 32
syscall
sll $t1, $a0, 7 #store the random number = 128y
add $a0, $t0, $t1 #store 4x+128y in $a0 as argument for drawPlatform
sw $a0, platformPosition
jr $ra #goes back to the location of function call


drawDoodle:#draw doodleBot at the specified position = (4*x)+(128*y), where 1<=x<=29 and 0<=y<=28. x,y stored in $a0, $a1. No returns
lw $t0, displayAddress #$t0 stores the base address for display
lw $t1, doodleBot #stores the doodleBot colour code in $t1
lw $t5, doodleX #retrieves x-value
lw $t6, doodleY #retrieves y-value
sll $t2, $t5, 2 #stores 4*x in $t2
sll $t3, $t6, 7 #stores 128*y in $t3
add $t2, $t2, $t3 #stores (4*x)+(128*y) = position offset in $t2
add $t0, $t0, $t2 #change the value of memory to new position (instead of base) calculated in $t2
#head
sw $t1, ($t0)
sw $t1, 4($t0)
#torso
sw $t1, 124($t0)
sw $t1, 128($t0)
sw $t1, 132($t0)
sw $t1, 136($t0)
#abdomen
sw $t1, 252($t0)
sw $t1, 256($t0)
sw $t1, 260($t0)
sw $t1, 264($t0)
#legs
sw $t1, 380($t0)
sw $t1, 392($t0)
jr $ra #goes back to the location of function call








