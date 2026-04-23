#include "hydraulic_manifold.hpp"
#include <iostream>
#include <vector>
#include <cassert>

void verify(bool condition, const std::string& test_name) {
    if (condition) {
        std::cout << "[PASS] " << test_name << "\n";
    } else {
        std::cerr << "[FAIL] " << test_name << "\n";
        exit(1);
    }
}

void test_flux_calculations() {
    // Standard Case: (10-5)*1.0 + (30-20)*2.0 = 5 + 20 = 25
    std::vector<Aperture> apertures = {{0, 10, 1.0}, {20, 30, 2.0}};
    verify(HydraulicEngine::calculate_flux(apertures, 5) == 25.0, "Standard Flux Integration");

    // Boundary: Current time past all apertures
    verify(HydraulicEngine::calculate_flux(apertures, 35) == 0.0, "Post-Aperture Null Flux");

    // Boundary: Empty apertures
    verify(HydraulicEngine::calculate_flux({}, 0) == 0.0, "Empty Manifold Flux");
}

void test_equilibrium_solvers() {
    // Case 1: Perfect Partition (0 Residual Pressure)
    std::vector<double> weights = {10.5, 20.0, 30.5, 40.0};
    auto res = HydraulicEngine::solve_equilibrium(weights);
    verify(res.is_equilibrated, "Perfect Partition Equilibrium");

    // Case 2: Target Volume (Subset Sum / Incompressibility)
    double target = 50.5;
    auto res_target = HydraulicEngine::solve_equilibrium(weights, target);
    verify(res_target.is_equilibrated, "Target Volume Displacement");
    
    // Case 3: Mechanical Advantage (Large Scale Pressure)
    std::vector<double> large_set(1000, 1.0);
    auto res_large = HydraulicEngine::solve_equilibrium(large_set, 500.0);
    verify(res_large.solution_indices.size() == 500, "High-Variable Pressure Handling");
}

int main() {
    std::cout << "--- Initializing Iron Clad Hydraulic Verification ---\n";
    test_flux_calculations();
    test_equilibrium_solvers();
    std::cout << "--- ALL UNIVERSAL SYSTEMS ENSURED ---\n";
    return 0;
}