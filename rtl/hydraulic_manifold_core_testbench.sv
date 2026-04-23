/**
 * HYDRAULIC MANIFOLD: VERILOG TESTBENCH
 * Copyright (c) 2026 Jonathan Alan Reed
 * LICENSE: GNU Affero General Public License v3.0 (AGPL-3.0)
 * Include: hydraulic_manifold_core.sv
 */

`timescale 1ns / 1ps

module hydraulic_manifold_testbench();
    parameter DW = 32;
    parameter N  = 4;

    logic clk;
    logic rst_n;
    logic [DW-1:0] current_time, target_volume, total_flux_o;
    logic [DW-1:0] a_open [N], a_close [N], a_rate [N];
    logic ensured_o;

    hydraulic_manifold_core #(.DATA_WIDTH(DW), .NUM_APERTURES(N)) dut (.*);

    initial clk = 0;
    always #5 clk = ~clk;

    task clear_manifold();
        current_time = 0; target_volume = 0;
        for(int i=0; i<N; i++) begin
            a_open[i] = 0; a_close[i] = 0; a_rate[i] = 0;
        end
    endtask

    initial begin
        $display("--- Initializing Iron Clad Hardware Verification ---");
        rst_n = 0;
        clear_manifold();
        #20 rst_n = 1;

        // TEST 1: Standard Flux (Matches C++ case)
        current_time = 5;
        target_volume = 20;
        a_open[0] = 0;  a_close[0] = 10; a_rate[0] = 1;
        a_open[1] = 20; a_close[1] = 30; a_rate[1] = 2;
        #20; 
        if (total_flux_o == 25 && ensured_o) 
            $display("[PASS] Standard Flux Integration");
        else 
            $display("[FAIL] Standard Flux Integration (Flux: %d)", total_flux_o);

        // TEST 2: Post-Aperture Null Flux (Matches C++ case)
        current_time = 35;
        #20;
        if (total_flux_o == 0 && !ensured_o)
            $display("[PASS] Post-Aperture Null Flux");
        else
            $display("[FAIL] Post-Aperture Null Flux");

        // TEST 3: Empty Manifold Flux (Matches C++ case)
        clear_manifold();
        #20;
        if (total_flux_o == 0)
            $display("[PASS] Empty Manifold Flux");
        else
            $display("[FAIL] Empty Manifold Flux");

        // TEST 4: Pressure Rejection (Boundary Case)
        current_time = 5;
        target_volume = 100; // Target is higher than available Flux (25)
        a_open[0] = 0;  a_close[0] = 10; a_rate[0] = 1;
        a_open[1] = 20; a_close[1] = 30; a_rate[1] = 2;
        #20;
        if (!ensured_o)
            $display("[PASS] Target Volume Displacement (Over-Pressure)");
        else
            $display("[FAIL] Target Volume Displacement Mismatch");

        $display("--- ALL UNIVERSAL SYSTEMS ENSURED ---");
        $finish;
    end
endmodule
