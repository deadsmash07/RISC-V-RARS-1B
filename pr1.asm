.data
n: .word 0
r: .word 0
result: .word 0

.text
.globl main
main:
    # Take input for n
    li a7, 5
    ecall
    la t0 n
    sw a0, 0(t0)

    # Take input for r
    li a7, 5
    ecall
    la t0 r
    sw a0, 0(t0)

    # Load n and r
    lw a1, n
    lw a2, r

    # Calculate n!
    mv a0, a1
    jal ra, factorial
    mv s0, a0    # Store n! in s0
  
    # Calculate r!
    mv a0, a2
    jal ra, factorial
    mv s1, a0    # Store r! in s1

    # Calculate (n-r)!
    sub a0, a1, a2
    jal ra, factorial
    mv s2, a0    # Store (n-r)! in s2

    # Calculate nCr = n! / (r!(n-r)!)
    div a0, s0, s1  # n!/r!, quotient in a3, remainder in a4
    div a0, a0,s2  # (n!/r!) % r! / (n-r)!, quotient in a5, remainder in a6
    mv a6, a3       # Store the final result in a6
    li a7, 1
    ecall

    # Exit the program
    li a7, 93           # System call number for exit
    li a0, 0            # Exit code 0
    ecall

# Function to calculate factorial of a number
factorial:
    li a3, 1
    factorial_loop:
        blez a0, factorial_end
        mul a3, a3, a0
        addi a0, a0, -1
        j factorial_loop
    factorial_end:
        mv a0, a3
        ret
