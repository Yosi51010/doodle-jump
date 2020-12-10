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
# - Milestone 2
#####################################################################
.data
	displayAddress: .word 0x10008000
	#Colours:
	sky: .word 0x00FFFFFF
	doodleBot: .word 0x00FFDD3C
	platform: .word 0x0092DFF3
.text
main:
#### PROGRAM RUNS HERE ####
jal drawBackground

#draw THREE platforms RANDOMLY where 0<=x<=24 and 0<=y<=31
jal generateRandom
jal drawPlatform

jal generateRandom
jal drawPlatform

jal generateRandom
jal drawPlatform


#draw doodleBot where 1<=x<=29 and 0<=y<=28
addi $a0, $zero, 2 #x=2
addi $a1, $zero, 3 #y=3
jal drawDoodle

jump: #animate doodleBot to move across across screen
addi $t5, $zero, 29 # i=29. This is starting at the bottom of the screen.
addi $t6, $zero, 0# iterate upto j. This is the top of the screen.
animateLoop:
	beq $t5, $t6, animateExit #stop loop when $t5==$t6/ while i!=j
	addi $a0, $t5, 0 #x=i
	addi $a1,$t5, -1 #y=3
	jal drawBackground
	jal drawDoodle
	addi $t5, $t5, -1 #/i-=1
	li $v0, 32
	li $a0, 100
	syscall
	j animateLoop #loops back to branch statement
animateExit:


li $v0, 10 #terminate the program gracefully
syscall
##### MACROS START HERE #####
.macro pushStack
addi $sp, $sp, -4

sw $ra, 0($sp)
.end_macro

.macro popStack
lw $ra, 0($sp)
addi $sp, $sp, 4
.end_macro	

##### FUNCTIONS START HERE #####

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
add $t0, $t0, $a0 #change the value of memory to new co-ordinate (instead of base), stored in $a0
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
jr $ra #goes back to the location of function call


drawDoodle:#draw doodleBot at the specified position = (4*x)+(128*y), where 1<=x<=29 and 0<=y<=28. x,y stored in $a0, $a1. No returns
lw $t0, displayAddress #$t0 stores the base address for display
lw $t1, doodleBot #stores the doodleBot colour code in $t1
sll $t2, $a0, 2 #stores 4*x in $t2
sll $t3, $a1, 7 #stores 128*y in $t3
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









