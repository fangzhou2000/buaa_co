`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:50:40 12/17/2020 
// Design Name: 
// Module Name:    BEEXT 
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
module BEEXT(
    input wire [31:0] instr,
	 input wire [31:0] aluout,
	 output wire [3:0] be
    );
	 
	 wire [5:0]func,op;
	 wire [4:0]rs,rt,rd;
	 assign func=instr[5:0];
	 assign rd=instr[15:11];
	 assign rt=instr[20:16];
	 assign rs=instr[25:21];
	 assign op=instr[31:26];
	 
	 wire sw,sb,sh;
	 
    assign sw = (op == `sw) ? 1 : 0;
	 assign sb = (op == `sb) ? 1 : 0;
	 assign sh = (op == `sh) ? 1 : 0;
	 

	 
	 assign be = (sw) ? 4'b1111:
	             (sb && aluout[1:0] == 2'b00 ) ? 4'b0001:
					 (sb && aluout[1:0] == 2'b01 ) ? 4'b0010:
					 (sb && aluout[1:0] == 2'b10 ) ? 4'b0100:
					 (sb && aluout[1:0] == 2'b11 ) ? 4'b1000:
					 (sh && aluout[1] == 1'b0) ? 4'b0011:
					 (sh && aluout[1] == 1'b1) ? 4'b1100:
	             0;
endmodule
