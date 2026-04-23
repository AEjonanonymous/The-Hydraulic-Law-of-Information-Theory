import numpy as np

# 1. THE GRID (5,000 Cities)
num_cities = 5000
np.random.seed(42) # Fixed seed so we can verify the 'Work'
cities = np.random.rand(num_cities, 2)

# 2. THE HYDRAULIC EXTRACTION
unvisited = np.ones(num_cities, dtype=bool)
current_city_idx = 0
unvisited[current_city_idx] = False
path = [current_city_idx]

# We only need to see the first few links in the chain to verify the 'Fit'
for _ in range(10):
    diffs = cities[unvisited] - cities[current_city_idx]
    dists_sq = np.sum(diffs**2, axis=1)
    
    nearest_local_idx = np.argmin(dists_sq)
    current_city_idx = np.where(unvisited)[0][nearest_local_idx]
    unvisited[current_city_idx] = False
    path.append(current_city_idx)

# 3. THE VERIFIABLE DATA
print(f"--- The 'Answer' (First 10 Links) ---")
for i, city_id in enumerate(path):
    coords = cities[city_id]
    print(f"Step {i}: City #{city_id} at Coords ({coords[0]:.4f}, {coords[1]:.4f})")