# delay subroutine
# Arguments: $a0 - ms (milliseconds)
# Returns: None

delay:
    # Save registers
    addi $sp, $sp, -12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)

    # Initialize loop counter
    li $s0, 4711  # The constant 4711 (adjust as needed)

    # Outer loop: decrement ms
    outer_loop:
        bnez $a0, inner_loop  # if ms is not zero, go to inner loop
        j end_delay  # if ms is zero, exit the delay

    inner_loop:
        # Inner loop: decrement inner loop counter
        bnez $s0, inner_loop  # if counter is not zero, continue inner loop
        addi $a0, $a0, -1  # decrement ms
        li $s0, 4711  # reset inner loop counter
        j outer_loop  # go to outer loop

    # Restore registers and return
    end_delay:
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        addi $sp, $sp, 12
        jr $ra