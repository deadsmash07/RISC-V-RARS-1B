import matplotlib.pyplot as plt

# Assuming you have these arrays
n_values = [5, 10, 15, 20, 25, 30]  # replace with your actual values
hex_cycles1 = ['0x2a', '0x3e', '0x52', '0x66', '0x7a', '0x8e']  # replace with your actual values
hex_cycles2 = ['0x48', '0x7a', '0xac', '0xde', '0x110','0x142']  # replace with your actual values
hex_cycles3 = ['0x25', '0x34', '0x43', '0x52', '0x61' ,'0x70']  # replace with your actual values

# Convert hexadecimal values to integers
cycles1 = [int(x, 16) for x in hex_cycles1]
cycles2 = [int(x, 16) for x in hex_cycles2]
cycles3 = [int(x, 16) for x in hex_cycles3]

# Plotting
plt.plot(n_values, cycles1, label=' tail_recusion')
plt.plot(n_values, cycles2, label='normal_recursion ')
plt.plot(n_values, cycles3, label='interative ')

plt.xlabel('n values')
plt.ylabel('Number of cycles')
plt.title('n vs Number of cycles')
plt.legend()

# Save the plot to a file
plt.savefig('graph.png')

plt.show()