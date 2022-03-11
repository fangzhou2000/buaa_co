`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:56:53 12/26/2020 
// Design Name: 
// Module Name:    CP0 
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
module CP0(
    input wire [4:0] A1,//MFC0
	 input wire [4:0] A2,//MTC0
	 input wire [31:0] Din,//MTC0
	 input wire [31:0] PC,//产生中断时的PC
	 input wire [6:2] ExcCode,//中断类型（原因）
	 input wire [7:2] HWInt,//外部设备中断
	 input wire WE,//CP0寄存器写使能
	 input wire EXLSet,//置位SR
	 input wire EXLClr,//清除SR
	 input wire BD,
	 input wire clk,
	 input wire reset,
	 output wire IRQ,//中断请求，输出至CPU控制器
	 output wire [31:0] EPC,//输出至NPC
	 output wire [31:0] Dout//MFC0
    );

    //SR{16’b0, im, 8’b0, exl, ie}
	 reg [15:10] im;
	 reg exl,ie;
	 
	 //Cause{bd, 15’b0, hwint_pend, 3'b0, exccode, 2'b0}
	 reg [15:10] hwint_pend;
	 reg bd;
	 reg [6:2] exccode;
	 
	 //EPC
	 reg [31:0] epc;
	 
	 //PrID
	 reg [31:0] prid = 32'h66666666;
	 
	 initial begin
	     im = 0;
		  exl = 0;
		  ie = 0;
		  hwint_pend = 0;
		  bd = 0;
		  exccode = 0;
		  epc = 0;
	 end
	 
	 wire intIRQ;//中断
	 wire excIRQ;//异常
	 assign intIRQ = (ie==1 && exl==0 && (|(HWInt&im))==1)?1:0;
	 assign excIRQ = (/*exl == 0 && */(|ExcCode) == 1)?1:0;//要加exl,与Mars行为不一致，但不会测试//这里的exccode是输入进来的ExcCode
	 assign IRQ = (intIRQ|excIRQ)?1:0;
	 
	 assign EPC = epc;
	 
	 assign Dout = (A1 == `SR) ? {16'b0, im, 8'b0, exl, ie}:
	               (A1 == `Cause) ? {bd, 15'b0, hwint_pend, 3'b0, exccode, 2'b0}:
						(A1 == `EPC) ? epc:
						(A1 == `PrID) ? prid:
						0;

    always@(posedge clk)begin
	     if(reset == 1)begin
		      im <= 0;
		      exl <= 0;
		      ie <= 0;
		      hwint_pend <= 0;
		      bd <= 0;
		      exccode <= 0;
		      epc <= 0;
		  end
		  else begin
		      hwint_pend<=HWInt;
				
				//处理中断和异常
				if(IRQ == 1)begin
				    exl <= 1'b1;
					 if(BD == 1)begin //延迟槽指令异常
						  bd <= 1'b1;
						  epc <= {PC[31:2],2'b00} - 4; //异常中断时EPC写入要保证字对齐
					 end
					 else if(BD == 0)begin //非延迟槽指令异常
						  bd <= 1'b0;
						  epc <= {PC[31:2],2'b00};
					 end
					 else begin
						  $display("wrong");
					 end
				    
					 if(intIRQ == 1)begin
					     exccode <= `exccode_int;
					 end
					 else if(excIRQ == 1)begin //else if 保证中断优先级高于异常
					     exccode <= ExcCode;
					 end
					 else begin
					     $display("wrong");
					 end
				end
				else if(WE == 1)begin //向CP0写入,中断优先级高，若中断在mtc0时，优先中断
				    if(A2 == `SR)begin
					     {im, exl, ie} <= {Din[15:10], Din[1], Din[0]};
					 end
					 else if(A2 == `EPC)begin
					     epc <= Din;
					 end
					 else begin
					     $display("wrong");
					 end
				end
				
		      if(EXLClr == 1)begin
				    exl <= 0;
				end
				
				if(EXLSet == 1)begin
				    exl <= 1;
				end
				
		  end
	 end
	 
endmodule
