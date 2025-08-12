`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/05 07:15:22
// Design Name: 
// Module Name: PI_controller_testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PI_controller_testbench();

    reg clk;
    reg signed [20:0] measured_height;
    reg signed [20:0] reference_value;
    reg rst;
    wire signed [20:0] control_signal;
    wire signed [20:0] filtered_signal;
    wire signed [20:0] output_value;
    reg filter;

    integer file;

    PI_controller uut(
        .input_value(measured_height),
        .reference_value(reference_value),
        .clk(clk),
        .rst(rst),
        .filter_enable(filter),
        .output_control_signal(control_signal),
        .filtered_signal(filtered_signal),
        .output_value(output_value)
    );

    // Clock generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    always @(control_signal) begin
        measured_height <= measured_height + control_signal;
    end

    // Stimulus
    initial begin
        reference_value = 20;
        measured_height = 20;
        rst = 1;
        filter = 0;
        #30;
        rst = 0;
        #100;
//        measured_height = 200;
//        #100;
//        measured_height = 50;
//        #100;
//        measured_height = 100;        
    end

    // File I/O
    initial begin
        // Open the file (change name/path as needed)
        file = $fopen("output_values.csv", "w");

        // Write CSV header
        $fwrite(file, "measured_height, control_signal, filtered_value\n");

        // Write values every 10ns (on rising edge)
        @(negedge rst);  // wait for reset deassertion
        repeat (1000) begin
            @(posedge clk);
            $fwrite(file, "%0d,%0d,0%d\n", measured_height, control_signal, filtered_signal);
        end

        // Close the file
        $fclose(file);
        $finish;
    end

endmodule
