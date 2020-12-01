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
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

.data
	displayAddress: .word 0x10008000
	skyTop: .word 0x00FFDD3C
	doodleMan: .word 0x0008183A
	platforms: .word 0x00392033
	
.text
lw $t0, displayAddress # $t0 stores the base address for display
lw $t1, skyTop # $t1 stores the sky colour code

add $t2, $zero, $zero #store 0 in $t2
addi $t3, $zero, 1024 #store 256 in $t3

add $t4, $zero, $t0 #store value of $t0 in $t4
TopLoop:
	beq $t2, $t3, TopExit #stop loop when $t2==$t3
	sw $t1, ($t4) #store sky in the new memoryAddress
	addi $t2, $t2, 1 #increment $t2 by 1
	sll $t4, $t2, 2 #$t4 = 4*$t2
	add $t4, $t4, $t0 #$t4 = iterator + displayAddress = new memoryAddress of each unit
	j TopLoop
TopExit:

add $t0, $t0, 512 #change the value of memory to new Y-axis co-ordinate (instead of base)
lw $t1, platforms #$t1 stores the platform colour code
addi $t3, $zero, 10 #store 10 in #$t3, which is the platform length
add $t2, $zero, $zero #reset the value of $t2 to 0
PlatTopLoop:
	beq $t2, $t3, PlatTopExit #stop loop when $t2==$t3
	sw $t1, ($t4) #store sky in the new memoryAddress
	addi $t2, $t2, 1 #increment $t2 by 1
	sll $t4, $t2, 2 #$t4 = 4*$t2
	add $t4, $t4, $t0 #$t4 = iterator + displayAddress = new memoryAddress of each unit
	j PlatTopLoop
PlatTopExit:


add $t0, $t0, 1300 #change the value of memory to new Y-axis co-ordinate (instead of base)
addi $t3, $zero, 10 #store 10 in #$t3, which is the platform length
add $t2, $zero, $zero #reset the value of $t2 to 0
PlatMidLoop:
	beq $t2, $t3, PlatMidExit #stop loop when $t2==$t3
	sw $t1, ($t4) #store sky in the new memoryAddress
	addi $t2, $t2, 1 #increment $t2 by 1
	sll $t4, $t2, 2 #$t4 = 4*$t2
	add $t4, $t4, $t0 #$t4 = iterator + displayAddress = new memoryAddress of each unit
	j PlatMidLoop
PlatMidExit:


add $t0, $t0, 2224 #change the value of memory to new Y-axis co-ordinate (instead of base)
addi $t3, $zero, 10 #store 10 in #$t3, which is the platform length
add $t2, $zero, $zero #reset the value of $t2 to 0
PlatBotLoop:
	beq $t2, $t3, PlatBotExit #stop loop when $t2==$t3
	sw $t1, ($t4) #store sky in the new memoryAddress
	addi $t2, $t2, 1 #increment $t2 by 1
	sll $t4, $t2, 2 #$t4 = 4*$t2
	add $t4, $t4, $t0 #$t4 = iterator + displayAddress = new memoryAddress of each unit
	j PlatBotLoop
PlatBotExit:


li $v0, 10 # terminate the program gracefully
syscall
