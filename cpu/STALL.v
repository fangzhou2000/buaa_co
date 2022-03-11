`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:53:50 12/02/2020 
// Design Name: 
// Module Name:    STALL 
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
module STALL(
    input wire [31:0] instr,
	 input wire start,
	 input wire busy,
    input wire [4:0] D_RSTuse,
	 input wire [4:0] D_RTTuse,
	 input wire [4:0] E_Tnew,
	 input wire [4:0] M_Tnew,
	 input wire [4:0] W_Tnew,
	 input wire [4:0] E_TWA,
	 input wire [4:0] M_TWA,
	 input wire [4:0] D_TRSA,
	 input wire [4:0] D_TRTA,
	 output wire stall
    );
	 wire [5:0]func,op;
	 wire [4:0]rs,rt,rd;
	 assign func=instr[5:0];
	 assign rd=instr[15:11];
	 assign rt=instr[20:16];
	 assign rs=instr[25:21];
	 assign op=instr[31:26];

    wire mult,multu,div,divu,mfhi,mflo,mthi,mtlo;
    
    assign mult = (op == `R&&func == `mult)?1:0;
    assign multu = (op == `R&&func == `multu)?1:0;
    assign div = (op == `R&&func == `div)?1:0;
    assign divu = (op == `R&&func == `divu)?1:0;
    assign mfhi = (op == `R&&func == `mfhi)?1:0;
    assign mflo = (op == `R&&func == `mflo)?1:0;
    assign mthi = (op == `R&&func == `mthi)?1:0;
    assign mtlo = (op == `R&&func == `mtlo)?1:0;

    assign stall = (D_TRSA == E_TWA && D_TRSA!=0 && D_RSTuse<E_Tnew) ? 1:
	                (D_TRTA == E_TWA && D_TRTA!=0 && D_RTTuse<E_Tnew) ? 1:
						 (D_TRSA == M_TWA && D_TRSA!=0 && D_RSTuse<M_Tnew) ? 1:
	                (D_TRTA == M_TWA && D_TRTA!=0 && D_RTTuse<M_Tnew) ? 1:
						 ((start|busy)&&(mult|multu|div|divu|mfhi|mflo|mthi|mtlo)) ? 1:
						                                                  0;

endmodule
