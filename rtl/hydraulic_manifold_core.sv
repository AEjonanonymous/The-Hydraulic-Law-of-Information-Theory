/**
 * HYDRAULIC MANIFOLD: VERILOG CORE MODULE
 * Copyright (c) 2026 Jonathan Alan Reed
 * LICENSE: GNU Affero General Public License v3.0 (AGPL-3.0)
 */

`timescale 1ns / 1ps

module hydraulic_manifold_core #(
    parameter DATA_WIDTH = 32,
    parameter NUM_APERTURES = 4
)(
    input  logic                     clk,
    input  logic                     rst_n,
    
    // Universal Manifold Inputs
    input  logic [DATA_WIDTH-1:0]    current_time,
    input  logic [DATA_WIDTH-1:0]    target_volume,
    input  logic [DATA_WIDTH-1:0]    a_open  [NUM_APERTURES],
    input  logic [DATA_WIDTH-1:0]    a_close [NUM_APERTURES],
    input  logic [DATA_WIDTH-1:0]    a_rate  [NUM_APERTURES],

    // Outputs
    output logic [DATA_WIDTH-1:0]    total_flux_o,
    output logic                     ensured_o
);

    logic [DATA_WIDTH-1:0] stage_flux [NUM_APERTURES];
    logic [DATA_WIDTH-1:0] start_v; // Declared outside the loop for Icarus support

    // Parallel Aperture Integration (The Piston Stroke)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < NUM_APERTURES; i++) stage_flux[i] <= 0;
            ensured_o <= 0;
        end else begin
            for (int i = 0; i < NUM_APERTURES; i++) begin
                if (a_close[i] > current_time) begin
                    start_v = (a_open[i] > current_time) ? a_open[i] : current_time;
                    stage_flux[i] <= (a_close[i] - start_v) * a_rate[i];
                end else begin
                    stage_flux[i] <= 0;
                end
            end
            // Ensurance logic: Does Flux satisfy the Vacuum (Target Volume)?
            ensured_o <= (total_flux_o >= target_volume);
        end
    end

    // Combinational Summation
    always_comb begin
        total_flux_o = 0;
        for (int i = 0; i < NUM_APERTURES; i++) begin
            total_flux_o = total_flux_o + stage_flux[i];
        end
    end

endmodule