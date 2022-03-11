`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:07:39 11/29/2020 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input wire clk,
	 input wire reset,
	 input wire interrupt,//外部中断信号
	 output wire [31:0] addr //宏观PC 
    );
	 
    assign addr = PrPC;
	 
	 wire [31:0] PrRD,PrWD;
	 wire [7:2] HWInt;
	 wire [31:2] PrAddr;
	 wire [3:0] PrBE;
	 wire PrWE;
	 wire [31:0] PrPC;
	 
	 wire [31:2] DEV0_Addr,DEV1_Addr;
	 wire [31:0] DEV0_WD,DEV1_WD;
	 wire DEV0_WE,DEV1_WE;
	 wire [31:0] DEV0_RD,DEV1_RD;
	 wire DEV0_IRQ,DEV1_IRQ;


CPU cpu(
    .clk(clk), //input
    .reset(reset), //input
    .PrRD(PrRD), //input
    .HWInt(HWInt), //input	
    	 
    .PrAddr(PrAddr),
    .PrWD(PrWD),	 
    .PrBE(PrBE),  
    .PrWE(PrWE),
    .PrPC(PrPC)	 
    );
	 
Bridge bridge(
    //cpu->timer
    .PrAddr(PrAddr), //input
    .PrWD(PrWD), //input
    .PrWE(PrWE), //input
    .PrBE(PrBE), //input
    .DEV0_Addr(DEV0_Addr), 
    .DEV1_Addr(DEV1_Addr), 
    .DEV0_WD(DEV0_WD), 
    .DEV1_WD(DEV1_WD), 
    .DEV0_WE(DEV0_WE), 
    .DEV1_WE(DEV1_WE), 
	 
	 //timer->cpu	 
    .DEV0_RD(DEV0_RD), //input
    .DEV1_RD(DEV1_RD), //input
    .DEV0_IRQ(DEV0_IRQ), //input
    .DEV1_IRQ(DEV1_IRQ), //input
    .interrupt(interrupt), //input
    .PrRD(PrRD), 
    .HWInt(HWInt)
    );
	 
TC timer0(
    .clk(clk), //input
    .reset(reset), 
    .Addr(DEV0_Addr), 
    .WE(DEV0_WE), 
    .Din(DEV0_WD), 
	 
    .Dout(DEV0_RD), //output
    .IRQ(DEV0_IRQ)
    );
	 
TC timer1(
    .clk(clk), //input
    .reset(reset), 
    .Addr(DEV1_Addr), 
    .WE(DEV1_WE), 
    .Din(DEV1_WD), 
	 
    .Dout(DEV1_RD), //output
    .IRQ(DEV1_IRQ)
    );
	 
endmodule
	 
