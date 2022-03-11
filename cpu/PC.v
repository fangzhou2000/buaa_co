`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:52:43 11/28/2020 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input wire clk,
	 input wire reset,
	 input wire stall,
	 input wire IRQ,
	 input wire [31:0] npc,
	 output reg[31:0] pc
    );
	 
	 initial begin
	 
	     pc = 32'h00003000; 
	 end
	 
	 always@(posedge clk)begin
	     if(reset == 1)begin
		      pc <= 32'h00003000; 
		  end
		  else if(IRQ == 1 | !stall) begin//��ͣ��ʱ��������쳣Ӧ������ִ���쳣��������ͣ�������npc��ֵ�������ı�
		      pc <= npc;
		  end
	 end

endmodule
