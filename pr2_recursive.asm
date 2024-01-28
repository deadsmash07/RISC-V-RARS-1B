.data
n: .word 0
acc: .word 0
result: .word 0

.text
.globl main
main:
    # Take input for n
    li a7, 5
    ecall
    la t0, n
    sw a0, 0(t0)

    # Take input for acc
    li a7, 5
    ecall
    la t0, acc
    sw a0, 0(t0)

    # Load n and acc
    lw a0, n
    lw a1, acc
    jal ra, sum

    # Print the result
    mv a1, a0
    li a7, 1
    ecall

    # Exit the program
    li a7, 10
    ecall

sum:
    blez a0, sum_exit # go to sum_exit if n <= 0
    add a1, a1, a0 # add n to acc
    addi a0, a0, -1 # subtract 1 from n

    # Save return address to stack before recursive call
    addi sp, sp, -4
    sw ra, 0(sp)

    jal ra, sum # jump to sum

    # Restore return address from stack after recursive call
    lw ra, 0(sp)
    addi sp, sp, 4

sum_exit:
    mv a0, a1 # return value acc
    ret
