import time

def solve_for_witness_integer(target, coin_values):
    """
    Solves for the 'Witness Integer' (the exact sum).
    In our Hydraulic Law, this is the 'Bottom of the Stroke'.
    """
    start = time.perf_counter()
    
    # Establish Pressure Gradient
    # We use 'Potential' to fill the vacuum efficiently
    sorted_coins = sorted(coin_values, reverse=True)
    
    current_fill = 0
    witness_list = []
    
    # THE PISTON STROKE
    # Unlike a CPU, we don't 'backtrack'. We follow the flow.
    for coin in sorted_coins:
        while current_fill + coin <= target:
            current_fill += coin
            witness_list.append(coin)
            
    end = time.perf_counter()
    
    return {
        "witness": current_fill,
        "count": len(witness_list),
        "gap": target - current_fill,
        "time_ms": (end - start) * 1000
    }

# --- THE CHALLENGE ---
# Problem: How much 'volume' can we fill using only these prime-based valves?
valves = [137, 239, 457, 863, 997, 1231]
goal = 987654321

result = solve_for_witness_integer(goal, valves)

print(f"--- THE DETERMINISTIC WITNESS ---")
print(f"Target Goal:     {goal}")
print(f"WITNESS INTEGER: {result['witness']}")
print(f"Residual Gap:    {result['gap']}")
print(f"Total Valves:    {result['count']}")
print(f"Leverage Time:   {result['time_ms']:.6f} ms")