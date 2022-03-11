`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:22:35 12/26/2020 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
    //cpu->timer
    input wire [31:2] PrAddr,
	 input wire [31:0] PrWD,
	 input wire PrWE,	
	 input wire [3:0] PrBE,
	 output wire [31:2] DEV0_Addr,
	 output wire [31:2] DEV1_Addr,
	 output wire [31:0] DEV0_WD,
	 output wire [31:0] DEV1_WD,
	 output wire DEV0_WE,
	 output wire DEV1_WE,
    
    //timer->cpu	 
	 input wire [31:0] DEV0_RD,
	 input wire [31:0] DEV1_RD,
	 input wire DEV0_IRQ,
	 input wire DEV1_IRQ,
	 input wire interrupt,
	 output wire [31:0] PrRD,
	 output wire [7:2] HWInt
    );
	 
	 assign DEV0_Addr = PrAddr;
	 assign DEV1_Addr = PrAddr;
	 assign DEV0_WD = PrWD;
	 assign DEV1_WD = PrWD;
	 
	 //DEV0 00007F00-00007F0B 
	 //DEV1 00007F10-00007F1B 
	 wire timer0_work; 
	 assign timer0_work = (({PrAddr,2'b00}>=32'h00007f00)&&({PrAddr,2'b00}<=32'h00007f0b)) ? 1:0;
	 wire timer1_work;
	 assign timer1_work = (({PrAddr,2'b00}>=32'h00007f10)&&({PrAddr,2'b00}<=32'h00007f1b)) ? 1:0;
	 
	 assign DEV0_WE = PrWE&&timer0_work;
	 assign DEV1_WE = PrWE&&timer1_work;
	 
	 assign PrRD = (timer0_work)?DEV0_RD:
	               (timer1_work)?DEV1_RD:
						0;
	 assign HWInt = {3'b0,interrupt,DEV0_IRQ,DEV1_IRQ};


endmodule
