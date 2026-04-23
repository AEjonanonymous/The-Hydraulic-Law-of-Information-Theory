# The Hydraulic Law of Information Theory
**Deterministic Data Movement & NP-Hard Solver IP Package**

Copyright (c) 2026 Jonathan Alan Reed  
[cite_start]**License:** GNU Affero General Public License v3.0 (AGPL-3.0) [cite: 371]

## 1. Executive Summary: The Hydraulic Law
[cite_start]This repository implements the **Hydraulic Law of Information Theory**, a framework that collapses the $N \times T$ complexity of spatiotemporal search problems[cite: 7, 8]. [cite_start]By treating data as an **incompressible fluid**, we replace stochastic pathfinding with **volumetric flow verification**[cite: 9, 317].

Standard NASA/CGR algorithms scale exponentially with time ($T$). [cite_start]This IP package collapses that complexity back to the physical number of nodes ($N$) by projecting time-expanded graphs into a hydraulic manifold[cite: 7, 8].

## 2. Core Methodology: Aperture-Integral Calculus
[cite_start]The fundamental engine of this repository is the **Aperture-Integral Function**[cite: 81]. [cite_start]Instead of checking every discrete second of a contact window, we integrate the area under the curve of the temporal "pipe"[cite: 82, 265]:

$$V_{total} = \sum \int_{start}^{end} (Rate - Overhead) dt$$

[cite_start]If the integrated volume ($V_{total}$) satisfies the data volume, the pipe is mathematically open, ensuring a "geometric necessity" of delivery[cite: 105, 136].

## 3. Formal Verification (Lean 4)
[cite_start]The reliability of this system is backed by a formal proof of soundness written in **Lean 4**[cite: 291, 292]. [cite_start]We prove that if the manifold integrity check returns `Ensured`, the data must arrive provided the physical constraints are met[cite: 293, 298].

* [cite_start]**Theorem `lunar_delivery_ensurance`**: Proves that for any file size, if the integrated capacity of windows is $\ge$ the volume and buffer safety is maintained, delivery is guaranteed[cite: 298, 302].
* [cite_start]**Inductive Path Proof**: The theorem `path_delivery_induction` proves that if a recursive check passes for a multi-hop path, the physical requirements hold for every individual hop[cite: 298, 305].

## 4. IP Package Implementation
The logic is deployed across high-performance software and hardware modules:

### Software (C++)
[cite_start]Located in the main directory, the C++ engine provides the `calculate_flux` and `solve_equilibrium` functions to resolve manifold pressure and NP-hard search problems[cite: 370].

### Hardware (SystemVerilog)
[cite_start]The `hydraulic_manifold_core.sv` module enables parallel aperture integration on FPGA/ASIC hardware[cite: 314, 371].
* [cite_start]**Piston Stroke logic**: Parallel calculation of flow across multiple apertures[cite: 374].
* [cite_start]**Ensurance Logic**: Real-time output signals (`ensured_o`) indicating if the vacuum (target volume) is satisfied[cite: 372, 379].

## 5. Repository Structure
* [cite_start]**`/sw`**: Software testbenches and Python-based NP-hard solvers (Vertex Cover, Partition Problem, Twin Primes, and Busy Beaver)[cite: 326, 331, 339, 342].
* [cite_start]**`/rtl`**: Hardware testbenches for the SystemVerilog manifold core[cite: 371].
* [cite_start]**`Deterministic_Law_of_Data_Movement.lean`**: The formal Lean 4 proof[cite: 299].
* [cite_start]**`hydraulic_manifold.hpp`**: The core C++ hydraulic engine[cite: 370].
* **`hydraulic_manifold_core.sv`**: The synthesizable RTL core[cite: 371].
* [cite_start]**`The Hydraulic Law of Information Theory.pdf`**: The foundational theoretical manuscript[cite: 1].

## 6. Key Equations & Logic
### Manifold Integrity (Python/C++ Pseudo)
```python
# Collapses T into a single Boolean: Can the volume pass?
def check_aperture_integrity(file_size, windows, t_now, overhead):
    integrated_volume = sum((w_end - max(t_now, w_start)) * rate - overhead)
    return integrated_volume >= file_size
