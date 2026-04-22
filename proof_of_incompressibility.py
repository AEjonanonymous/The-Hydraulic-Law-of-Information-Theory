import numpy as np

# 1. THE LOAD (The 'Impossible' Data)
# 1,000 random weights. Finding the right sum is NP-Hard.
np.random.seed(42)
weights = np.random.uniform(1, 100, 1000)
target_sum = 50234.57  # Our 'Rigid Lock'

# 2. THE HYDRAULIC GRID
# We define our grid as a container that can ONLY hold the target_sum.
# Any excess volume creates 'Pressure'. Any deficit creates 'Vacuum'.
grid_capacity = target_sum

def apply_hydraulic_pressure(selected_indices):
    # The 'Liquid' we are pouring in
    current_volume = np.sum(weights[selected_indices])
    
    # 3. THE WORK (Incompressibility)
    # Because the grid is fixed at target_sum, the 'Work' is the 
    # displacement required to reach equilibrium.
    pressure_differential = current_volume - grid_capacity
    
    return pressure_differential

# 4. THE CALCULATION (The 'Press')
# We 'Pump' a random selection into the grid.
test_selection = np.random.choice(range(1000), 500, replace=False)
result_pressure = apply_hydraulic_pressure(test_selection)

print(f"--- Hydraulic Calculation Report ---")
print(f"Target Lock (Rigid Grid): {target_sum} units")
print(f"Current Liquid Volume: {np.sum(weights[test_selection]):.2f} units")
print(f"Internal Grid Pressure: {result_pressure:.2f} units")