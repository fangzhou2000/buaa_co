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
	 input wire [31:0] PC,//�����ж�ʱ��PC
	 input wire [6:2] ExcCode,//�ж����ͣ�ԭ��
	 input wire [7:2] HWInt,//�ⲿ�豸�ж�
	 input wire WE,//CP0�Ĵ���дʹ��
	 input wire EXLSet,//��λSR
	 input wire EXLClr,//���SR
	 input wire BD,
	 input wire clk,
	 input wire reset,
	 output wire IRQ,//�ж����������CPU������
	 output wire [31:0] EPC,//�����NPC
	 output wire [31:0] Dout//MFC0
    );

    //SR{16��b0, im, 8��b0, exl, ie}
	 reg [15:10] im;
	 reg exl,ie;
	 
	 //Cause{bd, 15��b0, hwint_pend, 3'b0, exccode, 2'b0}
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
	 
	 wire intIRQ;//�ж�
	 wire excIRQ;//�쳣
	 assign intIRQ = (ie==1 && exl==0 && (|(HWInt&im))==1)?1:0;
	 assign excIRQ = (/*exl == 0 && */(|ExcCode) == 1)?1:0;//Ҫ��exl,��Mars��Ϊ��һ�£����������//�����exccode�����������ExcCode
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
				
				//�����жϺ��쳣
				if(IRQ == 1)begin
				    exl <= 1'b1;
					 if(BD == 1)begin //�ӳٲ�ָ���쳣
						  bd <= 1'b1;
						  epc <= {PC[31:2],2'b00} - 4; //�쳣�ж�ʱEPCд��Ҫ��֤�ֶ���
					 end
					 else if(BD == 0)begin //���ӳٲ�ָ���쳣
						  bd <= 1'b0;
						  epc <= {PC[31:2],2'b00};
					 end
					 else begin
						  $display("wrong");
					 end
				    
					 if(intIRQ == 1)begin
					     exccode <= `exccode_int;
					 end
					 else if(excIRQ == 1)begin //else if ��֤�ж����ȼ������쳣
					     exccode <= ExcCode;
					 end
					 else begin
					     $display("wrong");
					 end
				end
				else if(WE == 1)begin //��CP0д��,�ж����ȼ��ߣ����ж���mtc0ʱ�������ж�
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
