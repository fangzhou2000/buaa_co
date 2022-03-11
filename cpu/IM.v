`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:45:36 11/28/2020 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input wire [31:0] pc,
	 output wire [31:0] instr
    );
    
	 reg [31:0]im[0:4095];
	 integer i;
	 
	 wire [31:0] pc_p6;
	 assign pc_p6 = pc - 32'h00003000;//¸ÄµØÖ·£¿
	 
	 initial begin
	     for(i=0;i<4096;i=i+1)begin
		      im[i]=0;
		  end
	     $readmemh("code.txt",im);
		  $readmemh("code_handler.txt", im, 1120, 2047);
	 end
	 
	 assign instr = im[pc_p6[13:2]];
	 
endmodule
