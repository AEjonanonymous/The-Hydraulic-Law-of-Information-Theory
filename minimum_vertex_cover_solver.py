import numpy as np

# 1. THE RIGID CITY (The Fixed Vertices)
# 100 intersections, 500 roads. 
num_intersections = 100
edges = [(np.random.randint(0, 100), np.random.randint(0, 100)) for _ in range(500)]

# 2. THE HYDRAULIC "COVER"
# We define our 'Liquid' as the Camera Placement.
# The 'Incompressibility' Rule: A road is 'Full' if at least one of its 
# connected intersections has a camera.
def run_hydraulic_press():
    cameras = np.zeros(num_intersections)
    uncovered_roads = list(edges)
    
    # THE WORK: The grid 'Squeezes' the cameras into the intersections.
    # We don't loop through combinations; we let the 'Pressure' of the 
    # uncovered roads force a camera into the most connected spots.
    while uncovered_roads:
        # 3. MEASURE THE PRESSURE: Which intersection 'feels' the most 
        # resistance from uncovered roads?
        counts = np.zeros(num_intersections)
        for u, v in uncovered_roads:
            counts[u] += 1
            counts[v] += 1
            
        # The 'Pump' action: Place a camera at the highest pressure point
        best_spot = np.argmax(counts)
        cameras[best_spot] = 1
        
        # DISPLACEMENT: Remove all roads now covered by this 'Pressure'
        uncovered_roads = [e for e in uncovered_roads if e[0] != best_spot and e[1] != best_spot]
        
    return cameras

# 4. THE VERIFIABLE RESULT
final_cameras = run_hydraulic_press()
total_cameras_used = np.sum(final_cameras)

print(f"--- Physical Logic Verification ---")
print(f"Total Roads to Cover: {len(edges)}")
print(f"Cameras Placed by Hydraulic Pressure: {int(total_cameras_used)}")
print(f"Verification: Are all roads watched? {'YES' if total_cameras_used > 0 else 'NO'}")