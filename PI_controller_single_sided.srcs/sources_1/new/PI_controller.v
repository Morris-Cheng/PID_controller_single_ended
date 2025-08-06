`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/05 06:39:38
// Design Name: 
// Module Name: PI_controller
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


module PI_controller(
    input signed [20:0] target_value,
    input clk,
    input rst,
    output reg signed [20:0] output_value
    );
    
    reg signed [20:0] P_constant; //constant for proportional gain
    reg signed [20:0] I_constant; //consatnt for integral gain
    reg signed [20:0] D_constant; //constant for derivative gain
    
    reg signed [20:0] P_gain; //computed value for the p gain
    reg signed [20:0] I_gain; //computed value for the i gain
    reg signed [20:0] D_gain; //computed value for the d gain
    
    reg signed [20:0] current_error; //current error value
    reg signed [20:0] previous_error; //previous error value
    reg signed [20:0] current_value; //current value
    
    reg signed [20:0] integral; //evaluated integral at given time
    reg signed [20:0] derivative; //evaluated derivative at given time
    
    reg signed [20:0] next_error;
    reg signed [20:0] next_integral;
    reg signed [20:0] next_derivative;
    
    reg signed [20:0] next_P_gain, next_I_gain, next_D_gain;
    reg signed [20:0] next_current_value;
    reg signed [20:0] control_signal;
    
    always @(posedge clk) begin
        if (rst) begin
            // Init all values
            P_constant <= 1500;
            I_constant <= 0;
            D_constant <= 0;
            
            current_error <= 0;
            previous_error <= 0;
            current_value <= 0;
            
            integral <= 0;
            derivative <= 0;
    
            P_gain <= 0;
            I_gain <= 0;
            D_gain <= 0;
            
            output_value <= 0;
            
            control_signal <= 0;
        end else begin
            // Compute intermediate values based on current state
            next_error = target_value - current_value;
            next_integral = integral + next_error;
            next_derivative = next_error - previous_error;
            
            next_P_gain = (P_constant * next_error) / 1000;
            
            next_I_gain = I_constant * next_integral;
            next_D_gain = D_constant * next_derivative;
            
            control_signal = next_P_gain + next_I_gain + next_D_gain;
            
            
            next_current_value = current_value + control_signal;
    
            // Update state
            current_error <= next_error;
            integral <= next_integral;
            derivative <= next_derivative;
    
            P_gain <= next_P_gain;
            I_gain <= next_I_gain;
            D_gain <= next_D_gain;
    
            current_value <= next_current_value;
            output_value <= next_current_value;
            
            previous_error <= next_error;
            $display("Current value: %d", current_value);
            $display("Next error: %d", next_error);
            $display("P gain: %d", next_P_gain);
            $display("Control signal: %d", control_signal >>> 10);
        end
    end
    
endmodule