`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:20:55 11/28/2020 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input wire [31:0] instr,
    input wire [31:0] A,
	 input wire [31:0] B,
	 input wire [4:0] alu_op,
	 output wire [31:0] out,
	 output wire overflow
    );
	 assign out = (alu_op == `alu_and) ? A&B:
	              (alu_op == `alu_or) ? A|B:
					  (alu_op == `alu_add) ? A+B:
					  (alu_op == `alu_sub) ? A-B:
					  (alu_op == `alu_xor) ? A^B:
					  (alu_op == `alu_nor) ? ~(A|B):
					  (alu_op == `alu_sll) ? A<<B:
					  (alu_op == `alu_srl) ? A>>B:
					  (alu_op == `alu_sra) ? $signed($signed(A)>>>$signed({1'b0,B})):
					  (alu_op == `alu_sllv) ? A<<{{27{1'b0}},B[4:0]}:
					  (alu_op == `alu_srlv) ? A>>{{27{1'b0}},B[4:0]}:
					  (alu_op == `alu_srav) ? $signed($signed(A)>>>$signed({{27{1'b0}},B[4:0]})):
					  (alu_op == `alu_slt && $signed(A)<$signed(B)) ? {{31{1'b0}},1'b1}:
                 (alu_op == `alu_slt && $signed(A)>=$signed(B)) ? 0:	
                 (alu_op == `alu_sltu && A<B) ? {{31{1'b0}},1'b1}:
                 (alu_op == `alu_sltu && A>=B) ? 0:					  
					   0;
	 
	 
	 wire [32:0] temp;
	 assign temp = (alu_op == `alu_add) ? {A[31],A}+{B[31],B}:
                  (alu_op == `alu_sub) ? {A[31],A}-{B[31],B}:
						0;	 
	 assign overflow = (temp[32] != temp[31]) ? 1:0;
								
								
endmodule
