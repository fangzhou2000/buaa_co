`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:19:44 11/28/2020 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input wire clk,
	 input wire reset,
	 input wire we,
	 input wire [4:0] a1,
	 input wire [4:0] a2,
	 input wire [4:0] wa,
	 input wire [31:0] wd,
	 input wire [31:0] pc,
	 output wire [31:0] r1,
	 output wire [31:0] r2
    );
	 
	 reg [31:0] register[31:0];
	 integer i;
	 initial begin
	     for(i = 0; i < 32; i=i+1 )begin
		      register[i]=0;
		  end
	 end
	 
	 always@(posedge clk)begin
	     if(reset == 1)begin
		      for(i = 0; i < 32; i = i+1 )begin
		          register[i] <= 0;
		      end
		  end
		  else begin
		      if(we && wa!= 5'b00000)begin
				    register[wa] <= wd;
					 $display("%d@%h: $%d <= %h", $time, pc, wa,wd); 
				end
		  end
	 end

    assign r1 = (a1 == wa && wa!=5'b00000 && we == 1)?wd:register[a1];
	 assign r2 = (a2 == wa && wa!=5'b00000 && we == 1)?wd:register[a2];

endmodule
