.data
str: .asciz  "-12345"  # The string to convert
str2: .asciz "893" # second string
.text
.globl main
main:
    la a0, str  # Load the address of the first string
    jal ra, atoi_converter  # Call the function to convert string to integer
    
    # Now a0 contains the converted integer of the first string
    # Print it
    mv s0, a0
    li a7, 1
    ecall

    # Print a newline
    li a0, 10
    li a7, 11
    ecall

    la a0, str2  # Load the address of the second string
    jal ra, atoi_converter  # Call the function to convert string to integer
    
    # Now a0 contains the converted integer of the second string
    # Print it
    mv s1, a0
    li a7, 1
    ecall

    # Print a newline
    li a0, 10
    li a7, 11
    ecall
    
    #Arithmetic
    
   add a0, s0,s1
    li a7, 1
    ecall

    # Print a newline
    li a0, 10
    li a7, 11
    ecall

    sub a0, s0,s1
    li a7, 1
    ecall

    # Print a newline
    li a0, 10
    li a7, 11
    ecall

    mul a0, s0,s1
    li a7, 1
    ecall

     # Print a newline
    li a0, 10
    li a7, 11
    ecall

    div a0, s0,s1
    li a7, 1
    ecall

    # Exit the program
    li a7, 10
    ecall

atoi_converter:
    addi t4, zero, 10 # Just stores the constant 10
    addi t5, zero, 0 # Stores the running total
    addi t1, zero, 1 # Tracks whether input is positive or negative

    # Test for initial ‘+’ or ‘-’
    lbu t2, 0(a0) # Load the first character
    addi t3, zero, 45 # ASCII ‘-’
    bne t2, t3, non_negative
    addi t1, zero, -1 # Set that input was negative
    addi a0, a0, 1 # str++
    jal zero, String_to_int_loop

non_negative:
    addi t3, zero, 43 # ASCII ‘+’
    bne t2, t3, String_to_int_loop
    addi a0, a0, 1 # str++
String_to_int_loop:
    lbu t2, 0(a0) # Load the next digit
    beq t2, zero, done # Make sure next char is a digit, or fail
    addi t3, zero, 48 # ASCII ‘0’
    sub t2, t2, t3
    blt t2, zero, fail # *str < ‘0’
    addi t3, zero, 10 # 10 digits in decimal system
    blt t2, t3, continue # *str < ‘10’
    j fail # *str >= ‘10’

continue:
    # Next char is a digit, so accumulate it into t5
    mul t5, t5, t4 # t5 *= 10
    add t5, t5, t2 # t5 += *str - ‘0’
    addi a0, a0, 1 # str++
    jal zero, String_to_int_loop

done:
    addi a0, t5, 0 # Use t5 as output value
    mul a0, a0, t1 # Multiply by sign
    jalr zero, 0(ra) # Return result

fail:
    addi a0, zero, -1
    jalr zero, 0(ra)
