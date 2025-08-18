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
    input signed [20:0] measured_height, //measured height (input)
    input signed [20:0] reference_height, //reference signal (target)
    input clk, //clock
    input rst, //reset signal
    output reg signed [20:0] control_signal_output //control signal output
    );
    
    reg signed [20:0] P_constant; //constant for proportional gain
    reg signed [20:0] I_constant; //consatnt for integral gain
    reg signed [20:0] D_constant; //constant for derivative gain
    
    reg signed [20:0] P_gain; //computed value for the p gain
    reg signed [20:0] I_gain; //computed value for the i gain
    reg signed [20:0] D_gain; //computed value for the d gain
    
    reg signed [20:0] current_error; //current error value
    reg signed [20:0] previous_error; //previous error value
    
    reg signed [20:0] integral; //evaluated integral at given time
    reg signed [20:0] derivative; //evaluated derivative at given time
    
    reg signed [20:0] control_signal; //control signal computed from the three gains
    
    always @(posedge clk) begin
        if (rst) begin
            // Init all values
            P_constant <= 2500;
            I_constant <= 2;
            D_constant <= 0;
            
            P_gain <= 0;
            I_gain <= 0;
            D_gain <= 0;
            
            current_error <= 0;
            previous_error <= 0;
            
            integral <= 0;
            derivative <= 0;
            
            control_signal <= 0;
            control_signal_output <= 0;
        end
        else begin
            // Compute intermediate values based on current state
            current_error <= reference_height - measured_height; //compute the error between the reference height and the measured height

            integral <= (integral + current_error); //calculate the integral term by adding all previous errors
            derivative <= (current_error - previous_error); //calculate the derivative term by subtracting the current_error with the previous_error
            
            P_gain <= (P_constant * current_error) / 1000; //calculate the p gain
            I_gain <= (I_constant * integral) / 10000; //calculate the i gain
            D_gain <= (D_constant * derivative); //calculate the d gain
            
            control_signal <= (P_gain + I_gain + D_gain) / 2; //computing how much the actuator should change by summing up the three gains
            
            previous_error <= current_error; //upadting the previous error
            control_signal_output <= control_signal; //updating the control signal
        end
    end
    
endmodule