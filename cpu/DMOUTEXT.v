`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:17:10 12/17/2020 
// Design Name: 
// Module Name:    DMOUTEXT 
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
module DMOUT_EXT(
    input wire [31:0] instr,
	 input wire [31:0] dmout,
	 input wire [31:0] aluout,
	 output wire [31:0] dmout_ext
    );
	 
	 wire [5:0]func,op;
	 wire [4:0]rs,rt,rd;
	 assign func=instr[5:0];
	 assign rd=instr[15:11];
	 assign rt=instr[20:16];
	 assign rs=instr[25:21];
	 assign op=instr[31:26];
	 
	 wire lw,lb,lbu,lh,lhu;
	 
    assign lw = (op == `lw)	? 1 : 0;
	 assign lb = (op == `lb) ? 1 : 0;
	 assign lbu = (op == `lbu) ? 1 : 0;
	 assign lh = (op == `lh) ? 1 : 0;
	 assign lhu = (op == `lhu) ? 1 : 0;
	 
	 
	 assign dmout_ext = (lb && aluout[1:0] == 2'b00)?{{24{dmout[7]}},dmout[7:0]}:
	                    (lb && aluout[1:0] == 2'b01)?{{24{dmout[15]}},dmout[15:8]}:
							  (lb && aluout[1:0] == 2'b10)?{{24{dmout[23]}},dmout[23:16]}:
							  (lb && aluout[1:0] == 2'b11)?{{24{dmout[31]}},dmout[31:24]}:
							  (lbu && aluout[1:0] == 2'b00)?{{24{1'b0}},dmout[7:0]}:
							  (lbu && aluout[1:0] == 2'b01)?{{24{1'b0}},dmout[15:8]}:
							  (lbu && aluout[1:0] == 2'b10)?{{24{1'b0}},dmout[23:16]}:
							  (lbu && aluout[1:0] == 2'b11)?{{24{1'b0}},dmout[31:24]}:
							  (lh && aluout[1] == 1'b0)?{{16{dmout[15]}},dmout[15:0]}:
							  (lh && aluout[1] == 1'b1)?{{16{dmout[31]}},dmout[31:16]}:
							  (lhu && aluout[1] == 1'b0)?{{16{1'b0}},dmout[15:0]}:
							  (lhu && aluout[1] == 1'b1)?{{16{1'b0}},dmout[31:16]}:
							  0;
	 

endmodule
