.data
input: .asciz  "add -12345 893\n"  # The input string
str: .space 32  # Space for the first string
str2: .space 32  # Space for the second string
operation: .byte 4 # Declare operation as a byte.text
.globl main
main:
    la a0, input  # Load the address of the input string
    jal ra, parse_input  # Call the function to parse the input
    
    la a0, str  # Load the address of the first string
    jal ra, atoi_converter  # Call the function to convert string to integer
    mv s0, a0  # Save the result

    la a0, str2  # Load the address of the second string
    jal ra, atoi_converter  # Call the function to convert string to integer
    mv s1, a0  # Save the result

    # Perform the operation
    la a1, operation  # Load the address of the operation
    lbu a0, 0(a1)  # Load the operation
    li a1, 'a'  # Load ASCII value of 'a'
    beq a0, a1, add  # If operation is 'add', jump to add
    li a1, 's'  # Load ASCII value of 's'
    beq a0, a1, sub  # If operation is 'sub', jump to sub
    li a1, 'm'  # Load ASCII value of 'm'
    beq a0, a1, mul  # If operation is 'mul', jump to mul
    li a1, 'd'  # Load ASCII value of 'd'
    beq a0, a1, div  # If operation is 'div', jump to div

add:
    add a0, s0, s1
    j end

sub:
    sub a0, s0, s1
    j end

mul:
    mul a0, s0, s1
    j end

div:
    div a0, s0, s1
    j end

end:
    # Print the result
    li a7, 1
    ecall

    # Exit the program
    li a7, 10
    ecall

parse_input:
    # Load the address of the input string
    la a1, input

    # Extract the operation
    lbu a2, 0(a1)  # Load the first character

    la a1, operation  # Load the address of operation into a1
    sb a2, 0(a1)  # Store the value of a2 in operation

    # Skip the space
    addi a1, a1, 2

    # Extract the first number
    la a2, str
extract_first_number:
    lbu a3, 0(a1)  # Load the next character
    li a4, 32  # Load ASCII value of ' '
    beq a3, a4, end_extract_first_number  # If the character is a space, end the extraction
    sb a3, 0(a2)  # Store the character
    addi a1, a1, 1  # Move to the next character
    addi a2, a2, 1  # Move to the next position in the string
    j extract_first_number
end_extract_first_number:
    sb zero, 0(a2)  # Null-terminate the string

    # Skip the space
    addi a1, a1, 1

    # Extract the second number
    la a2, str2
extract_second_number:
    lbu a3, 0(a1)  # Load the next character
    beq a3, zero, end_extract_second_number  # If the character is a null character, end the extraction
    sb a3, 0(a2)  # Store the character
    addi a1, a1, 1  # Move to the next character
    addi a2, a2, 1  # Move to the next position in the string
    j extract_second_number

end_extract_second_number:
    sb zero, 0(a2)  # Null-terminate the string

    # Return
    jalr zero, 0(ra)

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
