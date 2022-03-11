`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:34:27 11/29/2020 
// Design Name: 
// Module Name:    ME_WB 
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
module ME_WB(
    input wire clk,
	 input wire reset,
	 input wire IRQ,
	 input wire [31:0] PrRD,
	 
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
	 input wire [31:0] dmout_in,
	 output reg [31:0] dmout_out = 0,
	 input wire [31:0] mulout_in,
	 output reg [31:0] mulout_out = 0,
	 input wire [31:0] CP0out_in,
	 output reg [31:0] CP0out_out = 0
    );
	 
	 always@(posedge clk)begin
	     if(reset == 1 || IRQ == 1)begin
		      pc_out<=0;
		      instr_out<=0;
				grf_rs_out<=0;
				grf_rt_out<=0;
				aluout_out<=0;
		      dmout_out<=0;
				mulout_out<=0;
				CP0out_out<=0;
		  end
		  else begin
		      pc_out<=pc_in;
		      instr_out<=instr_in;
				grf_rs_out<=grf_rs_in;
				grf_rt_out<=grf_rt_in;
				aluout_out<=aluout_in;
				if(aluout_in>=32'h00007f00)begin
				    dmout_out<=PrRD;
				end
				else begin
		          dmout_out<=dmout_in;
				end
				mulout_out<=mulout_in;
				CP0out_out<=CP0out_in;
		  end
	 end


endmodule
