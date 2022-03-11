`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:24:24 11/29/2020 
// Design Name: 
// Module Name:    FM 
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
module DM(
    input wire clk,
	 input wire reset,
	 input wire IRQ,
	 
    input wire [31:0]a,
	 input wire [31:0]wd,
	 input wire [31:0]pc,
	 input wire [3:0]be,
	 input wire we,
	 input wire re,
	 output wire [31:0]rd
    );
	 
	 reg [31:0] mem[0:4095];//DM大小
	 wire [31:0] din;
	 integer i;
	 initial begin
	     for(i=0;i<4096;i=i+1)begin//DM大小
		      mem[i]=0;
		  end
	 end
	 
	 
	 assign rd = re ? mem[a[13:2]] : 0;//DM大小
	 
	 
	 assign din = (be == 4'b1111)?wd:
	              (be == 4'b0001)?{rd[31:8],wd[7:0]}:
                 (be == 4'b0010)?{rd[31:16],wd[7:0],rd[7:0]}:
                 (be == 4'b0100)?{rd[31:24],wd[7:0],rd[15:0]}:
                 (be == 4'b1000)?{wd[7:0],rd[23:0]}:
					  (be == 4'b0011)?{rd[31:16],wd[15:0]}:
					  (be == 4'b1100)?{wd[15:0],rd[15:0]}:
                 wd;					  
	 
	 always@(posedge clk)begin
	     if(reset == 1)begin
		      for(i=0;i<4096;i=i+1)begin
		      mem[i]<=0;
		      end
		  end
		  else begin
		      if(we && IRQ==0 && a>=32'h00000000 && a<=32'h00002fff) begin
					 mem[a[13:2]] <= din;//DM大小
					 $display("%d@%h: *%h <= %h", $time, pc, {a[31:2],2'b00},din);					 
				end
		  end
	 end
	 
endmodule
