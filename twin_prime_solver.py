import numpy as np
import time

# 1. THE COMPRESSED GRID (Targeting 10 Million Numbers)
# We use a smaller range to stay under your 'Burst Pressure'.
n = 10_000_000
start_search = 1_000_000_000

# 2. THE PRESSURE SIEVE (Mechanical Filtering)
start_time = time.time()

# We create a 'Mesh' (Boolean array is 1 byte per element)
# This represents the 'Material' we are squeezing.
is_prime = np.ones(n, dtype=bool)

# The 'Piston' (Sifting out the non-primes)
# We only need to press with primes up to the square root of the end range.
limit = int((start_search + n)**0.5) + 1
for i in range(2, limit):
    # Calculate the first multiple of i in our range
    first_mult = (start_search // i) * i
    if first_mult < start_search:
        first_mult += i
        
    # DISPLACEMENT: Every multiple of i is 'Crushed' (not prime)
    start_idx = max(first_mult - start_search, i*i - start_search)
    if start_idx < n:
        is_prime[start_idx::i] = False

# 3. THE SEARCH FOR THE TWIN (The Answer)
# We look for two 'Survivors' of the press that are 2 units apart.
primes = np.where(is_prime)[0] + start_search
twins = []
for i in range(len(primes) - 1):
    if primes[i+1] - primes[i] == 2:
        twins.append((primes[i], primes[i+1]))
        if len(twins) >= 1: # We only need the FIRST real answer
            break

end_time = time.time()

# 4. THE DEFINITIVE RESULT
print(f"--- Deep-Range Twin Prime Report ---")
print(f"Range Scanned: {start_search:,} to {start_search + n:,}")
if twins:
    print(f"UNSOLVED ANSWER FOUND: The Twin Primes are {twins[0][0]} and {twins[0][1]}")
else:
    print("No twins in this pressure range.")
print(f"Execution Time: {end_time - start_time:.4f} seconds")