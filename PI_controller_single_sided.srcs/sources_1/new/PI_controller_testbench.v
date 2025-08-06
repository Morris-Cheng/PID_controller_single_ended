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
    reg signed [20:0] target_value;
    reg rst;
    wire signed [20:0] output_value;
    
    PI_controller uut(
        .target_value(target_value),
        .clk(clk),
        .rst(rst),
        .output_value(output_value)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end
    
    initial begin
        target_value = 200;
        rst = 1;
        #30;
        rst = 0;
    end

endmodule
