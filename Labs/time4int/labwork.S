  # labwork.S
  # Written 2015-2017 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1.
  # The macros PUSH and POP are in the public domain.
  # Please add your own code at the end of the file.

  #
  # Please keep the two macros PUSH and POP unchanged
  #
  
  .global time2string, delay

  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH, reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP, reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop
time2string:
    # Extract minutes and seconds
   
    PUSH $s0
    PUSH $s1
    PUSH $ra

    move $s0, $a0
 
    move $s1, $a1

    # x0:00
    andi $a0, $s1, 0xF000
    srl $a0, $a0, 12
    jal hexasc

    sb $v0, 0($s0)

    # 0x:00
    andi $a0, $s1, 0xF00
    srl $a0, $a0, 8

    jal hexasc

    sb $v0, 1($s0)

    # colon
    li $a0, 0x3A
    sb $a0, 2($s0)

    # 00:X0
    andi $a0, $s1, 0xF0
    srl $a0, $a0, 4

    jal hexasc

    sb $v0, 3($s0)

    # 00:0X
    andi $a0, $s1, 0xF

    jal hexasc

    sb $v0, 4($s0)

    # null-byte
    li $a0, 0x00
    sb $a0, 5($s0)

    # Restore original s1, s2, and s0 values
    
    POP $ra
    POP $s1
    POP $s0
    

    jr $ra
    nop
    
    
    
  # you can write your code for subroutine "hexasc" below this line
 hexasc:
    andi $v0, $a0, 0x0F   # Mask out all but the 4 least significant bits (bitwise & på 17 och 15)
    li   $t0, 10           # 10 stores in memory as temporary value, in t0. Compare with 9 to determine if it's a digit or a letter

    blt  $v0, $t0, is_digit   # Branch if less than 9 (it's a digit)
    addi $v0, $v0, 7         # Adjust for letters (A starts at ASCII 65)

is_digit:
    addi $v0, $v0, 48        # Adjust for ASCII digits (0 starts at ASCII 48)
    jr   $ra                # Return


delay: 			       # was 3 line delay code
    addi $sp, $sp, -8          # Allocate space on the stack to save $ra and $s0
    sw $ra, 4($sp)             # Save $ra on the stack
    sw $s0, 0($sp)             # Save $s0 on the stack

    move $t0, $a0              # Move ms (argument) into $t0

loop_ms:                        # Outer loop label
    blez $t0, end_delay        # If ms <= 0, jump to end_delay
    addi $t0, $t0, -1          # Decrement ms

    li $s0, 8865               # Load the constant 4711 into $s0 for the inner loop
loop_inner:                     # Inner loop label
    addi $s0, $s0, -1          # Decrement the inner loop counter
    bgtz $s0, loop_inner       # If $s0 > 0, continue the inner loop

    j loop_ms                  # Jump back to the beginning of the outer loop

end_delay:
    lw $ra, 4($sp)             # Restore $ra from the stack
    lw $s0, 0($sp)             # Restore $s0 from the stack
    addi $sp, $sp, 8           # Deallocate stack space
    jr $ra                     # Return from the subroutine