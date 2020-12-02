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
# - Milestone 1
#####################################################################
.data
	displayAddress: .word 0x10008000
	sky: .word 0x00FFDD3C
	doodleBot: .word 0x0008183A
	platform: .word 0x00392033
	
.text
main:
#### PROGRAM RUNS HERE ####
jal drawBackground

#draw THREE platforms at the specified position = (4*x)+(128*y), where 0<=x<=24 and 0<=y<=31
addi $a0, $zero, 1980 #x=15, y=15
jal drawPlatform

addi $a0, $zero, 3800 #x=22, y=29
jal drawPlatform

addi $a0, $zero, 256 #x=0, y=2
jal drawPlatform


li $v0, 10 #terminate the program gracefully
syscall
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


drawPlatform: #draws a single platform 8 units long. 1 argument of starting coordinate (stored in $a0). No returns.
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













