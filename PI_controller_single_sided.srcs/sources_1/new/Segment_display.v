`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/04 08:46:02
// Design Name: 
// Module Name: Segment_display
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


module Segment_display(
    input clk,
    input signed [20:0] value,
    input rst,
    output reg [7:0] seg,
    output reg [3:0] an
    );
    
    reg [18:0] digit_counter;
    reg [1:0] assign_digit;
    reg [3:0] display_digits [3:0];
    
    always @(posedge clk) begin // setting up a slower clock for updating the digits
        if(~rst == 1) begin
            digit_counter = 0;
            assign_digit = 0;
            display_digits[0] = 4'b0000;
            display_digits[1] = 4'b0000;
            display_digits[2] = 4'b0000;
            display_digits[3] = 4'b0000;
        end
        else begin   
            if (digit_counter >= 450450) begin //refreshes the counter every 450450 cycles 
                                           //(around 1 ms)
                assign_digit <= assign_digit + 1; //adds one to assign_digit
                digit_counter <= 0; //clears the counter
            end
            else begin
                digit_counter <= digit_counter + 1; //adds one to the counter
            end
        end
    end
    
    always @(*) begin // takes the assigned digit value and assign the digit value to an
        case (assign_digit)
            2'b00 : an = 4'b1110; //when assign_digit is zero
            2'b01 : an = 4'b1101; //when assign_digit is one
            2'b10 : an = 4'b1011; //when assign_digit is two
            2'b11 : an = 4'b0111; //when assign_digit is three
        endcase
    end
    
    integer temp;
    
    always @(*) begin
        temp = value;
        display_digits[0] = temp % 10;
        temp = temp / 10;
        display_digits[1] = temp % 10;
        temp = temp / 10;
        display_digits[2] = temp % 10;
        temp = temp / 10;
        display_digits[3] = temp % 10;
    end
    
    always @(*) begin
        case(display_digits[assign_digit])
            4'd0: seg = ~8'b00111111;
            4'd1: seg = ~8'b00000110;
            4'd2: seg = ~8'b01011011;
            4'd3: seg = ~8'b01001111;
            4'd4: seg = ~8'b01100110;
            4'd5: seg = ~8'b01101101;
            4'd6: seg = ~8'b01111101;
            4'd7: seg = ~8'b00000111;
            4'd8: seg = ~8'b01111111;
            4'd9: seg = ~8'b01101111;
        endcase
    end
    
endmodule