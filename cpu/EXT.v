`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:29:42 11/28/2020 
// Design Name: 
// Module Name:    EXT 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`default_nettype none
module EXT(
    input wire [15:0] in,
    input wire [3:0]ext_op,
    output reg [31:0] out
    );
	 
	 wire [4:0] shamt;
	 assign shamt = in[10:6];
	 
	 always@(*)begin
	     case(ext_op)
		  `ext_zero:
		      out = {{16{1'b0}},in};
		  `ext_sign:
		      out = {{16{in[15]}},in};
		  `ext_2:
		      out = {{14{in[15]}},in,2'b00};
		  `ext_tohigh:
		      out = {in,{16{1'b0}}};
		  `ext_shamt:
         	out = {{27{1'b0}},shamt};
		  endcase
	 end


endmodule
