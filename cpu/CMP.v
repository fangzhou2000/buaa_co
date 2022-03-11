`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:51:26 11/29/2020 
// Design Name: 
// Module Name:    CMP 
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
module CMP(
    input wire [31:0] grf_rs,
	 input wire [31:0] grf_rt,
	 output wire eq,
	 output wire neq,
	 output wire lez,
	 output wire ltz,
	 output wire gez,
	 output wire gtz
    );
	 
	 assign eq = (grf_rs == grf_rt)?1:0;
	 assign neq = (grf_rs != grf_rt)?1:0;
	 assign lez = ($signed(grf_rs) <= $signed(0))?1:0;
	 assign ltz = ($signed(grf_rs) < $signed(0))?1:0;
	 assign gez = ($signed(grf_rs) >= $signed(0))?1:0;
	 assign gtz = ($signed(grf_rs) > $signed(0))?1:0;
	 assign gtz = ($signed(grf_rs) > $signed(0))?1:0;

endmodule
