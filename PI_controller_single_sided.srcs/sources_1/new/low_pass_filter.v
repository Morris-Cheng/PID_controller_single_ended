`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/10 07:53:37
// Design Name: 
// Module Name: low_pass_filter
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


module low_pass_filter(
        input signed [20:0] input_value,
        input clk,
        input rst,
        output reg signed [20:0] filtered_value
    );
    
    reg signed [20:0] previous_value;
    reg signed [20:0] current_value;
    reg signed [20:0] alpha; //closer to one: smoother but slower
                             //closer to zero: sharper but faster
    
    always @(posedge clk) begin
        if(rst == 1) begin
            previous_value <= 0;
            current_value <= 0;
            alpha <= 1;
            filtered_value <= 0;
        end
        else begin
            current_value <= (alpha * previous_value + (10-alpha) * input_value) / 10;
            filtered_value <= current_value;
//            $display("previous_value: %d", current_value);
            previous_value <= current_value;
        end
    end
    
endmodule
