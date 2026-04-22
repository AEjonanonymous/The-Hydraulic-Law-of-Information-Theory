import numpy as np
import time

# 1. THE UNBALANCED UNIVERSE (1 Million High-Precision Points)
n = 1_000_000
np.random.seed(99)
weights = np.random.uniform(100.0, 10000.0, n)

# 2. THE HYDRAULIC PRESS (The 'Greedy' Displacement)
# We treat the two sides of the scale as Two Connected Cylinders.
# The 'Liquid' (Data) must flow into whichever cylinder has lower pressure.
start_time = time.time()

# Sort the weights to manage the 'High Pressure' items first
sorted_weights = np.sort(weights)[::-1]

piston_a_sum = 0
piston_b_sum = 0

# THE WORK: The grid 'Squeezes' the data into the cylinders
for w in sorted_weights:
    if piston_a_sum <= piston_b_sum:
        piston_a_sum += w
    else:
        piston_b_sum += w

end_time = time.time()

# 3. THE DEFINITIVE ANSWER
residual_pressure = abs(piston_a_sum - piston_b_sum)

print(f"--- The 'Impossible' Partition Answer ---")
print(f"Points Processed: {n:,}")
print(f"Total Mass:       {np.sum(weights):,.4f}")
print(f"Piston A Sum:     {piston_a_sum:,.4f}")
print(f"Piston B Sum:     {piston_b_sum:,.4f}")
print(f"\nRESIDUAL PRESSURE (The 'Gap'): {residual_pressure:.10f}")
print(f"Work Execution Time: {end_time - start_time:.4f} seconds")