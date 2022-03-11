`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:12:03 11/28/2020 
// Design Name: 
// Module Name:    ID_EX 
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
module ID_EX(
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
	 input wire [31:0] imm32_in,
	 output reg [31:0] imm32_out = 0,
	 input wire [31:0] grf_rs_in,
	 output reg [31:0] grf_rs_out = 0,
	 input wire [31:0] grf_rt_in,
	 output reg [31:0] grf_rt_out = 0,
	 input wire [6:2] exccode_in,
	 output reg [6:2] exccode_out = 0
    );
	 
	 always@(posedge clk)begin
	     if(reset == 1 || stall == 1 || IRQ == 1)begin//�������Ǽ���������nop,pcҲΪ0
				bd_out<=0;
				pc_out<=0;
		      instr_out<=0;
		      imm32_out<=0;
				grf_rs_out<=0;
				grf_rt_out<=0;
				exccode_out<=0;
		  end
		  else begin
		      if(exccode_in == `exccode_ri)begin//����ȡָ�쳣��ָ���Ϊnop����pc����
				    instr_out <= 0;
				end
				else begin
				    instr_out <= instr_in;
				end
				bd_out<=bd_in;
				pc_out<=pc_in;
		      
		      imm32_out<=imm32_in;
				grf_rs_out<=grf_rs_in;
				grf_rt_out<=grf_rt_in;//��Щ����ȡָ�쳣ʱ��������Ҫ������Ϊָ���Ѿ�Ϊ0���������κβ���
				exccode_out<=exccode_in;
		  end
	 end


endmodule
