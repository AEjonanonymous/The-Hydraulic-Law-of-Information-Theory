/**
 * HYDRAULIC MANIFOLD: C++ ENGINE
 * Copyright (c) 2026 Jonathan Alan Reed
 * LICENSE: GNU Affero General Public License v3.0 (AGPL-3.0)
 */

#ifndef HYDRAULIC_MANIFOLD_HPP
#define HYDRAULIC_MANIFOLD_HPP

#include <vector>
#include <numeric>
#include <algorithm>
#include <cmath>

// A universal "window" of opportunity (Time, Space, or Logic)
struct Aperture {
    double open;
    double close;
    double flow_rate;
};

class HydraulicEngine {
public:
    /**
     * THE CORE: Aperture-Integral (Collapses N x T -> N)
     * Calculates the total available volume (Flux) within a manifold over time.
     */
    static double calculate_flux(const std::vector<Aperture>& apertures, double current_time) {
        double v_total = 0.0;
        for (const auto& a : apertures) {
            if (a.close > current_time) {
                double start = std::max(a.open, current_time);
                v_total += (a.close - start) * a.flow_rate;
            }
        }
        return v_total;
    }

    /**
     * THE SOLVER: Pressure-Gradient Displacement (For NP-Hard/Search)
     * Resolves equilibrium for a set of inputs against a target volume.
     */
    struct EquilibriumResult {
        double residual_pressure;         // The 'error' or 'remainder'
        std::vector<size_t> solution_indices; // The 'solution set'
        bool is_equilibrated;            // True if solved perfectly
    };

    static EquilibriumResult solve_equilibrium(const std::vector<double>& weights, double target_volume = -1.0) {
        std::vector<size_t> indices(weights.size());
        std::iota(indices.begin(), indices.end(), 0);
        
        // Sorting is the 'Piston' that manages high-pressure items first
        std::sort(indices.begin(), indices.end(), [&](size_t i, size_t j) {
            return weights[i] > weights[j];
        });

        // If target_volume < 0, we perform a 50/50 split (Partition Problem)
        bool is_partition = (target_volume < 0);
        double side_a = 0, side_b = 0;
        std::vector<size_t> set_a;

        for (size_t idx : indices) {
            if (is_partition) {
                if (side_a <= side_b) {
                    side_a += weights[idx];
                    set_a.push_back(idx);
                } else {
                    side_b += weights[idx];
                }
            } else {
                if (side_a + weights[idx] <= target_volume) {
                    side_a += weights[idx];
                    set_a.push_back(idx);
                }
            }
        }

        double diff = is_partition ? std::abs(side_a - side_b) : std::abs(target_volume - side_a);
        return { diff, set_a, diff < 1e-9 }; 
    }
};

#endif