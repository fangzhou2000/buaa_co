`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:40:55 11/28/2020 
// Design Name: 
// Module Name:    EX_ME 
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
module EX_ME(
    input wire clk,
	 input wire reset,
	 input wire IRQ,
	 
	 input wire bd_in,
	 output reg bd_out = 0,
	 input wire [31:0] pc_in,
	 output reg [31:0] pc_out = 0,
	 input wire [31:0] instr_in,
	 output reg [31:0] instr_out = 0,
	 input wire [31:0] grf_rs_in,
	 output reg [31:0] grf_rs_out = 0,
	 input wire [31:0] grf_rt_in,
	 output reg [31:0] grf_rt_out = 0,
	 input wire [31:0] aluout_in,
	 output reg [31:0] aluout_out = 0,
	 input wire [31:0] mulout_in,
	 output reg [31:0] mulout_out = 0,
	 input wire E_overflow,
	 output reg M_overflow = 0,
	 input wire [6:2] exccode_in,
	 output reg [6:2] exccode_out = 0
    );
	 
	 always@(posedge clk)begin
	     if(reset == 1 || IRQ == 1)begin
		      bd_out<=0;
				pc_out<=0;
		      instr_out<=0;
				grf_rs_out<=0;
				grf_rt_out<=0;
		      aluout_out<=0;
				mulout_out<=0;
				exccode_out<=0;
				M_overflow<=0;
		  end
		  else begin
		      bd_out<=bd_in;
				pc_out<=pc_in;
		      instr_out<=instr_in;
				grf_rs_out<=grf_rs_in;
				grf_rt_out<=grf_rt_in;
		      aluout_out<=aluout_in;
				mulout_out<=mulout_in;
				exccode_out<=exccode_in;
				M_overflow<=E_overflow;
		  end
	 end


endmodule
