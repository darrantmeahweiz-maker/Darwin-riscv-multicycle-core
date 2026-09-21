`timescale 1ns / 1ps

// ==============================================================================
//  MODULE     : testbench (System-Level Testbench)
//  DESCRIPTION: Rigorous verification environment for the Multicycle RISC-V Core
// ==============================================================================
module testbench;

    // -----------------------------------------------------------------
    // 1. Signal Definitions
    // -----------------------------------------------------------------
    reg clk_i;
    reg rst_i;
    wire [31:0] debug_pc_o;
    wire [31:0] debug_alu_o;

    // Auxiliary register to track multi-cycle instruction transitions
    reg [31:0] prev_pc;

    // -----------------------------------------------------------------
    // 2. Top-Level Module Instantiation (UUT)
    // -----------------------------------------------------------------
    top uut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .debug_pc_o(debug_pc_o),
        .debug_alu_o(debug_alu_o)
    );

    // -----------------------------------------------------------------
    // 3. Clock Generation (100MHz -> 10ns period)
    // -----------------------------------------------------------------
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

    initial begin 
        $display("=================================================");
        $display(" RISC-V Multicycle Core Simulation Started");
        $display("=================================================");
        
        // System Reset Sequence
        rst_i = 1;
        prev_pc = 32'hFFFF_FFFF;
        #20; // Hold reset for 2 clock cycles
        
        rst_i = 0;
        
        // Note: Increased hard timeout to prevent premature termination during long executions
        #20000000; 
        $display("[TIMEOUT] Simulation stopped due to 20,000,000ns timeout.");
        $finish;
    end 

    always @(posedge clk_i) begin
        if (!rst_i) begin
            // Print log when PC changes (filters out internal multi-cycle execution states)
            if (debug_pc_o != prev_pc) begin
                $display("Time: %0t ns | PC: %h | ALU_Out: %h", $time, debug_pc_o, debug_alu_o);
                prev_pc = debug_pc_o;
            end

            // Termination Condition: Reached the final Halt/Loop address in IMEM2 (0x004003EC)
            if (debug_pc_o == 32'h004003EC) begin
                $display("=================================================");
                $display("[SUCCESS] Program reached the final Halt/Loop address (0x004003EC).");
                $display("Simulation Finished Cleanly.");
                
                // ---------------------------------------------------------
                // Cross-hierarchy read of r_Registers array inside Register_file to verify x4
                // uut: top-level instance | blk4114_15: Register_file instance
                // ---------------------------------------------------------
                $display("=================================================");
                $display("[REGISTER CHECK] Reading final value of x4...");
                
                if (uut.blk4114_15.r_Registers[4] == 32'h00000000) begin
                    $display("[PASS] x4 exactly matches expected value: %h", uut.blk4114_15.r_Registers[4]);
                end else begin
                    $display("[FAIL] x4 is %h, which is NOT 00000000", uut.blk4114_15.r_Registers[4]);
                end
                $display("=================================================");

                #20; // Run a few extra cycles to capture final waveforms completely
                $finish;
            end
        end
    end

    initial begin 
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
    end 

endmodule