`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:46:23 12/20/2020 
// Design Name: 
// Module Name:    MULT_DIV 
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
module MULT_DIV(
    input wire clk,
	 input wire reset,
	 input wire IRQ,
	 
	 input wire [31:0] instr,
	 input wire [31:0] A,
	 input wire [31:0] B,
	 output wire [31:0] out,
	 output wire start,
	 output wire busy
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

    reg [31:0] HI = 0,LO = 0;
	 reg [31:0] hi = 0,lo = 0;
	 reg [4:0] count = 5'b00000;
	 
	 assign start = (mult|multu|div|divu)?1:0;
	 
	 always@(posedge clk)begin
	     if(reset == 1)begin
		      count <= 0;
				hi <= 0;
				lo <= 0;
		  end
        else if(busy == 0 && IRQ == 0)begin
		      if(start == 1)begin
				    if(mult)begin
					     count <= 5;
						  {hi,lo} <= $signed(A)*$signed(B);
					 end
					 else if(multu)begin
					     count <= 5;
						  {hi,lo} <= A*B;
					 end
					 else if(div)begin
					     count <= 10;
						  hi <= $signed(A)%$signed(B);
					     lo <= $signed(A)/$signed(B);
					 end
					 else if(divu)begin
					     count <= 10;
					     hi <= A%B;
					     lo <= A/B;
					 end
				end
				if(mthi)begin
				    HI <= A;
				end
				if(mtlo)begin
				    LO <= A;
				end
		  end
		  else if(busy == 1 && IRQ == 0)begin
		      count <= count - 1;
				if(count == 1)begin
				    HI <= hi;
					 LO <= lo;
				end
		  end
	 end
	 
	 assign busy = (start == 0 && count > 0)?1:0;
	 
	 assign out = (mfhi)?HI:
	              (mflo)?LO:
					  0;
endmodule
