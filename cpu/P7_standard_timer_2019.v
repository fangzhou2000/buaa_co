`timescale 1ns / 1ps
`define IDLE 2'b00
`define LOAD 2'b01
`define CNT  2'b10
`define INT  2'b11

`define ctrl   mem[0]
`define preset mem[1]
`define count  mem[2]
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:43:39 12/28/2017 
// Design Name: 
// Module Name:    TC 
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
module TC(
    input wire clk,
    input wire reset,
    input wire [31:2] Addr,
    input wire WE,
    input wire [31:0] Din,
    output wire [31:0] Dout,
    output wire IRQ
    );

	reg [1:0] state;
	reg [31:0] mem [2:0];
	
	reg _IRQ;
	assign IRQ = `ctrl[3] & _IRQ;//是否中断
	
	assign Dout = mem[Addr[3:2]];//要读哪个寄存器
	
	wire [31:0] load = Addr[3:2] == 0 ? {28'h0, Din[3:0]} : Din;//要写控制寄存器还是初值寄存器
	
	integer i;
	always @(posedge clk) begin
		if(reset) begin
			state <= 0; 
			for(i = 0; i < 3; i = i+1) mem[i] <= 0;
			_IRQ <= 0;
		end
		else if(WE) begin
			 //$display("%d@: *%h <= %h", $time, {Addr, 2'b00}, load);
			mem[Addr[3:2]] <= load;//写
		end
		else begin
			case(state)
				`IDLE : if(`ctrl[0]) begin//允许计数
					state <= `LOAD;//进入装载状态
					_IRQ <= 1'b0;
				end
				`LOAD : begin
					`count <= `preset;//赋初值
					state <= `CNT;//进入计数状态
				end
				`CNT  : 
					if(`ctrl[0]) begin//允许计数
						if(`count > 1) `count <= `count-1;
						else begin
							`count <= 0;
							state <= `INT;//进入中断状态
							_IRQ <= 1'b1;
						end
					end
					else state <= `IDLE;
				default : begin
					if(`ctrl[2:1] == 2'b00) `ctrl[0] <= 1'b0;//模式0
					else _IRQ <= 1'b0;//模式1
					state <= `IDLE;
				end
			endcase
		end
	end

endmodule
