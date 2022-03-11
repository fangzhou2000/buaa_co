`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:56:21 11/28/2020 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
    input wire IRQ,
	 input wire [31:0] EPC,
    input wire [31:0] pc,
	 input wire [31:0] b_addr,
	 input wire [31:0] j_l_addr,
	 input wire [31:0] j_r_addr,
	 input wire eq,
	 input wire neq,
	 input wire lez,
	 input wire ltz,
	 input wire gez,
	 input wire gtz,
	 input wire [3:0] Branch,
	 input wire Branch_eret,
	 output reg [31:0] npc
    );
	 
	 initial begin
	     npc = 32'h00003000;
	 end
	 
	 always@(*)begin
 	        npc = (IRQ == 1) ? 32'h00004180:
			        (Branch_eret == 1) ? EPC:
			        (Branch == `pc4) ? pc + 4:
			        (Branch == `ifbeq && eq == 1) ? b_addr:
					  (Branch == `ifbne && neq == 1) ? b_addr:
					  (Branch == `ifblez && lez == 1) ? b_addr:
					  (Branch == `ifbltz && ltz == 1) ? b_addr:
					  (Branch == `ifbgez && gez == 1) ? b_addr:
					  (Branch == `ifbgtz && gtz == 1) ? b_addr:
					  (Branch == `ifjal) ? j_l_addr:
					  (Branch == `ifj) ? j_l_addr:
					  (Branch == `ifjr) ? j_r_addr:
					  (Branch == `ifjalr) ? j_r_addr:
					  pc + 4;
	 end

endmodule
