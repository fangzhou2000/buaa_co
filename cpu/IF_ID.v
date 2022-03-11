`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:07:30 11/28/2020 
// Design Name: 
// Module Name:    IF_ID 
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
module IF_ID(
    input wire clk,
	 input wire reset,
	 input wire stall,
	 input wire IRQ,
	 
	 input wire bd_in,
	 output reg bd_out = 0,
    input wire [31:0] pc_in,
	 output reg [31:0] pc_out = 0,
    input wire [31:0] instr_in,
	 output reg [31:0] instr_out = 0,
	 
	 input wire D_EXLClr,
	 input wire E_EXLClr,
	 input wire M_EXLClr,
	 input wire [6:2] exccode_in,
	 output reg [6:2] exccode_out = 0
    );
	 
	 always@(posedge clk)begin
	     if(reset == 1 || IRQ == 1)begin
		      bd_out<=0;
		      pc_out<=0;
				instr_out<=0;
				exccode_out<=0; 
		  end
		  else if(!stall) begin
				if(D_EXLClr == 1||E_EXLClr == 1||M_EXLClr == 1)begin//eret后指令不被执行，也变为nop,真正的nop pc也是0
				    instr_out <= 0;
					 pc_out <= 0;
					 bd_out <= 0;
					 exccode_out <= 0;
				end
				else if(exccode_in == `exccode_adel)begin//发生取指异常后指令变为nop，但pc不变
				    instr_out <= 0;
					 pc_out<=pc_in;
					 bd_out <= bd_in;
					 exccode_out <= exccode_in;	
				end
				else begin
				    instr_out <= instr_in;
					 pc_out <= pc_in;
					 bd_out <= bd_in;
					 exccode_out <= exccode_in;
				end
							
		  end
	 end


endmodule
