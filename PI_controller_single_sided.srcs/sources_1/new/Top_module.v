`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/06 06:34:36
// Design Name: 
// Module Name: Top_module
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


module Top_module(
        input rst,
        input clk,
        output wire [7:0] seg,
        output wire [3:0] an
    );
    
//    reg signed [20:0] target_value;
    wire signed [20:0] output_value;
    
    PI_controller pi_controller_inst(
        .clk(clk),
        .rst(rst),
        .output_value(output_value)
    );
    
    Segment_display segment_display_inst(
        .clk(clk),
        .value(output_value),
        .rst(rst),
        .seg(seg),
        .an(an)
    );
    
//    always @(posedge clk) begin
//        if(~rst == 1) begin
//            target_value <= 200;
//        end
//    end
    
endmodule
