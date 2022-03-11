`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:44 12/26/2020 
// Design Name: 
// Module Name:    CPU 
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
module CPU(
    input wire clk,
	 input wire reset,
	 
	 input wire [31:0] PrRD,
	 input wire [7:2] HWInt,
	 
	 output wire [31:2] PrAddr,
	 output wire [3:0] PrBE,
	 output wire [31:0] PrWD,
	 output wire PrWE,
	 output wire [31:0] PrPC
    );
	 
	 assign PrAddr = M_aluout[31:2];
	 assign PrBE = M_be;
	 assign PrWD = MFRTM;
	 assign PrWE = (M_MemWrite&&IRQ==0)?1:0;//这里地址是不是外设都可以，因为Bridge里也判断了，有中断先中断
	 assign PrPC = (M_pc || M_exccode)?M_pc:
	               (E_pc || E_exccode)?E_pc:
						(D_pc || D_exccode)?D_pc:
						F_pc;
						
	 wire F_bd,D_bd,E_bd,M_bd;
    assign F_bd = (D_Branch != `pc4)?1:0;	 
	 assign CP0_BD = (M_pc || M_exccode)?M_bd:
	                 (E_pc || E_exccode)?E_bd:
						  (D_pc || D_exccode)?D_bd:
						  (F_pc)?F_bd:0;
/***************************************中断与异常***********************************************/
	 wire [6:2] F_exccode,D_exccode_pre,D_exccode,E_exccode_pre,E_exccode,M_exccode_pre,M_exccode;
	 wire RI,E_Ov,M_Ov;

	 assign F_exccode = (F_pc>32'h00004fff || F_pc<32'h00003000 || F_pc[1:0] != 2'b00)?`exccode_adel:
							  `exccode_int;//pc超范围，或没有字对齐
						 
	 assign D_exccode = (RI)?`exccode_ri:D_exccode_pre;//未知指令	

	 assign E_exccode = (E_Ov)?`exccode_ov:E_exccode_pre;//计算类指令计算溢出

    wire [5:0] op;
	 assign op = M_instr[31:26];
	 wire sw,sb,sh,lw,lb,lbu,lh,lhu;;
	 assign sw = (op == `sw) ? 1 : 0;
	 assign sb = (op == `sb) ? 1 : 0;
	 assign sh = (op == `sh) ? 1 : 0;
    assign lw = (op == `lw)	? 1 : 0;
	 assign lb = (op == `lb) ? 1 : 0;
	 assign lbu = (op == `lbu) ? 1 : 0;
	 assign lh = (op == `lh) ? 1 : 0;
	 assign lhu = (op == `lhu) ? 1 : 0;
	 
	 assign M_exccode = (sw && M_aluout[1:0]!=2'b00)?`exccode_ades://未4字节对齐
                       (sh && M_aluout[0]!=1'b0)?`exccode_ades://未2字节对齐
							  
                       //存timer寄存器
							  ((sh|sb) && ((M_aluout>=32'h00007f00 && M_aluout<=32'h00007f0b)||
							  (M_aluout>=32'h00007f10 && M_aluout<=32'h00007f1b)))?`exccode_ades:
							  
							  //store类指令计算地址溢出
                       ((sw|sh|sb) && M_Ov)?`exccode_ades:
							  
                       //向timer的count存值,store类特有异常
							  ((sw|sh|sb) && ((M_aluout>=32'h00007f08 && M_aluout<=32'h00007f0b)||
							  (M_aluout>=32'h00007f18 && M_aluout<=32'h00007f1b)))?`exccode_ades:
							  
                       //地址超范围
                       ((sw|sh|sb) && 
							  !((M_aluout >=0 && M_aluout<=32'h00002fff)||
							  (M_aluout>=32'h00007f00 && M_aluout<=32'h00007f0b)||
							  (M_aluout>=32'h00007f10 && M_aluout<=32'h00007f1b)))?`exccode_ades:
							  
							  
							  
							  (lw && M_aluout[1:0]!=2'b00)?`exccode_adel://未4字节对齐
							  ((lh|lhu) && M_aluout[0]!=1'b0)?`exccode_adel://未2字节对齐
							  
							  //存timer寄存器
							  ((lh|lhu|lb|lbu) && ((M_aluout>=32'h00007f00 && M_aluout<=32'h00007f0b)||
							  (M_aluout>=32'h00007f10 && M_aluout<=32'h00007f1b)))?`exccode_adel:
							  
							  //load类指令计算地址溢出
                       ((lw|lh|lhu|lb|lbu) && M_Ov)?`exccode_adel:
							  
                       //地址超范围
                       ((lw|lh|lhu|lb|lbu) && 
							  !((M_aluout >=0 && M_aluout<=32'h00002fff)||
							  (M_aluout>=32'h00007f00 && M_aluout<=32'h00007f0b)||
							  (M_aluout>=32'h00007f10 && M_aluout<=32'h00007f1b)))?`exccode_adel:
                       
							  M_exccode_pre;							  

/************************************************F********************************************/
wire [31:0] F_pc,F_npc,F_instr;
wire stall;	 
PC pc(
    .clk(clk), 
    .reset(reset), 
	 .stall(stall),
	 .IRQ(IRQ),
	 
    .npc(F_npc), 
    .pc(F_pc)
    );
	 
wire [31:0] b_addr,j_l_addr,j_r_addr;
wire [3:0] D_Branch;
wire D_eq,D_neq,D_lez,D_ltz,D_gez,D_gtz;
wire Branch_eret;
NPC npc(
    .IRQ(IRQ),
	 .EPC(EPC),
    .pc(F_pc), 
    .b_addr(b_addr), 
    .j_l_addr(j_l_addr), 
    .j_r_addr(j_r_addr), 
    .eq(D_eq), 
	 .neq(D_neq),
	 .lez(D_lez),
	 .ltz(D_ltz),
	 .gez(D_gez),
	 .gtz(D_gtz),
    .Branch(D_Branch),
    .Branch_eret(Branch_eret),	 
    .npc(F_npc)
    );

IM im(
    .pc(F_pc), 
    .instr(F_instr)
    );
	 
/******************************************IF/ID******************************************/
wire [31:0] D_pc,D_instr;

IF_ID if_id(
    .clk(clk), 
    .reset(reset), 
	 .stall(stall),
	 .IRQ(IRQ),
	 
	 .bd_in(F_bd),
	 .bd_out(D_bd),
    .pc_in(F_pc), 
    .pc_out(D_pc), 
    .instr_in(F_instr), 
    .instr_out(D_instr),
	 
	 .D_EXLClr(D_EXLClr),
	 .E_EXLClr(E_EXLClr),
	 .M_EXLClr(M_EXLClr),
	 .exccode_in(F_exccode),
	 .exccode_out(D_exccode_pre)
    );
/*********************************************D****************************************/
wire [3:0] D_ExtOp;
wire [4:0] D_RSA,D_RTA;
wire [4:0] D_TRSA,D_TRTA;
wire [4:0] D_RSTuse,D_RTTuse;
wire D_EXLClr;

CU d_cu(
    .instr(D_instr), 
	 .ExtOp(D_ExtOp),
	 .Branch(D_Branch),
	 .D_RSA(D_RSA),
	 .D_RTA(D_RTA),
	 .D_RSTuse(D_RSTuse),
	 .D_RTTuse(D_RTTuse),
	 .D_TRSA(D_TRSA),
	 .D_TRTA(D_TRTA),
	 .RI(RI),
	 .D_EXLClr(D_EXLClr)
	 
    );
	 
wire [4:0] D_rs=D_instr[25:21];
wire [4:0] D_rt=D_instr[20:16];
wire [4:0] D_rd=D_instr[15:11];

wire [3:0] W_RegDst;
wire W_RegWrite;
wire [4:0] W_grf_wa;
wire [31:0] W_grf_wd;
wire [31:0] W_pc;
//RegDstMUX
assign W_grf_wa = (W_RegDst == `RegDst_rd)?W_rd:
                  (W_RegDst == `RegDst_rt)?W_rt:
						(W_RegDst == `RegDst_31)?5'b11111:
						                             0;
wire [31:0] D_grf_rs,D_grf_rt;
GRF grf(
    .clk(clk), 
    .reset(reset), 
    .we(W_RegWrite), 
    .a1(D_rs), 
    .a2(D_rt), 
    .wa(W_grf_wa), 
    .wd(W_grf_wd), 
    .pc(W_pc), 
    .r1(D_grf_rs), 
    .r2(D_grf_rt)
    );
	 
wire [15:0] D_imm16=D_instr[15:0];
wire [31:0] D_imm32;
EXT ext(
    .in(D_imm16), 
    .ext_op(D_ExtOp), 
    .out(D_imm32)
    );

wire [31:0] MFRSD,MFRTD;	 
CMP cmp(
    .grf_rs(MFRSD), 
    .grf_rt(MFRTD), 
    .eq(D_eq),
	 .neq(D_neq),
	 .lez(D_lez),
	 .ltz(D_ltz),
	 .gez(D_gez),
	 .gtz(D_gtz)
    );


assign b_addr = D_pc+4+(D_imm32);	 
assign j_l_addr = {{D_pc[31:28]},D_instr[25:0],2'b00};
assign j_r_addr = MFRSD;//需要转发


/**************************************ID/EX************************************/
wire [31:0] E_pc,E_instr;
wire [31:0] E_imm32;
wire [31:0] E_grf_rs,E_grf_rt;
ID_EX id_ex(
    .clk(clk), 
    .reset(reset), 
	 .stall(stall),
	 .IRQ(IRQ),
	 
	 .bd_in(D_bd),
	 .bd_out(E_bd),
    .pc_in(D_pc), 
    .pc_out(E_pc), 
    .instr_in(D_instr), 
    .instr_out(E_instr), 
    .imm32_in(D_imm32), 
    .imm32_out(E_imm32), 
    .grf_rs_in(MFRSD), 
    .grf_rs_out(E_grf_rs), 
    .grf_rt_in(MFRTD), 
    .grf_rt_out(E_grf_rt),
	 
	 .exccode_in(D_exccode),
	 .exccode_out(E_exccode_pre)
    );
/******************************************E************************************/
wire [3:0] E_ALUSrcA,E_ALUSrcB,E_ToReg;
wire [4:0] E_ALUOp;
wire [4:0] E_RSA,E_RTA,E_WA;
wire [31:0] E_grf_wd;
wire [4:0] E_TWA;
wire [4:0] E_Tnew;
wire E_EXLClr;
CU e_cu(
    .overflow(E_overflow),
    .instr(E_instr), 
    .ALUSrcA(E_ALUSrcA), 
    .ALUSrcB(E_ALUSrcB), 
    .ALUOp(E_ALUOp),
	 .E_ToReg(E_ToReg),
	 .E_RSA(E_RSA),
	 .E_RTA(E_RTA),
	 .E_WA(E_WA),
	 .E_TWA(E_TWA),
	 .E_Tnew(E_Tnew),
	 .E_EXLClr(E_EXLClr),
	 .E_Ov(E_Ov)
    );
assign E_grf_wd = (E_ToReg == `E_ToReg_imm32)?E_imm32:
                  (E_ToReg == `E_ToReg_pc8)?E_pc+8:
						0;

wire [31:0] E_alua,E_alub,E_aluout;
wire [31:0] MFRSE,MFRTE;
//ALUMUX
assign E_alua = (E_ALUSrcA == `ALUSrcA_grf_rs)?MFRSE:
                (E_ALUSrcA == `ALUSrcA_grf_rt)?MFRTE:
                0;
assign E_alub = (E_ALUSrcB == `ALUSrcB_grf_rt)?MFRTE:
                (E_ALUSrcB == `ALUSrcB_grf_rs)?MFRSE:
                (E_ALUSrcB == `ALUSrcB_imm)   ?E_imm32:
					 0;
wire E_overflow;
ALU alu(
    .instr(E_instr),
    .A(E_alua), 
    .B(E_alub), 
    .alu_op(E_ALUOp), 
    .out(E_aluout),
	 .overflow(E_overflow)
    );

wire start,busy;
wire [31:0] E_mulout;

MULT_DIV mult_div(
    .clk(clk), 
    .reset(reset),
    .IRQ(IRQ),
	 
    .instr(E_instr), 
    .A(E_alua), 
    .B(E_alub), 
    .out(E_mulout), 
    .start(start), 
    .busy(busy)
    );
/***************************************EX/ME************************************/
wire [31:0] M_pc,M_instr;
wire [31:0] M_grf_rs,M_grf_rt;
wire [31:0] M_aluout,M_mulout;
wire M_overflow;
EX_ME ex_me(
    .clk(clk), 
    .reset(reset),
    .IRQ(IRQ),
	 
	 .bd_in(E_bd),
	 .bd_out(M_bd),
    .pc_in(E_pc), 
    .pc_out(M_pc), 
    .instr_in(E_instr), 
    .instr_out(M_instr),
	 .grf_rs_in(MFRSE),
    .grf_rs_out(M_grf_rs),
    .grf_rt_in(MFRTE),
    .grf_rt_out(M_grf_rt),	 
    .aluout_in(E_aluout), 
    .aluout_out(M_aluout),
	 .mulout_in(E_mulout),
	 .mulout_out(M_mulout),
	 
	 .E_overflow(E_overflow),
	 .M_overflow(M_overflow),
	 .exccode_in(E_exccode),
	 .exccode_out(M_exccode_pre)
    );
/*****************************************M*****************************************/
wire M_MemRead,M_MemWrite;
wire [3:0] M_ToReg;
wire [4:0] M_RSA,M_RTA,M_WA;
wire [31:0] M_grf_wd;
wire [4:0] M_TWA;
wire [4:0] M_Tnew; 

CU m_cu(
    .overflow(M_overflow),
    .IRQ(IRQ),
    .instr(M_instr), 
    .MemRead(M_MemRead), 
    .MemWrite(M_MemWrite),
	 .M_ToReg(M_ToReg),
	 .M_RTA(M_RTA),
	 .M_WA(M_WA),
	 .M_TWA(M_TWA),
	 .M_Tnew(M_Tnew),
	 .CP0_WE(CP0_WE),
	 .M_EXLSet(M_EXLSet),
	 .M_EXLClr(M_EXLClr),
	 .Branch_eret(Branch_eret),
	 .M_Ov(M_Ov)
    );
	 
assign M_grf_wd = (M_ToReg == `M_ToReg_aluout)?M_aluout:
                  (M_ToReg == `M_ToReg_pc8)?M_pc + 8:
						(M_ToReg == `M_ToReg_mulout)?M_mulout:
						0;
wire [3:0] M_be;
BEEXT beext(
    .instr(M_instr), 
    .aluout(M_aluout), 
    .be(M_be)
    );

wire [31:0] M_dmout;
wire [31:0] MFRSM,MFRTM;
DM dm(
    .clk(clk), 
    .reset(reset),
    .IRQ(IRQ),
	 
    .a(M_aluout), 
    .wd(MFRTM), 
    .pc(M_pc), 
	 .be(M_be),
    .we(M_MemWrite), 
    .re(M_MemRead), 
    .rd(M_dmout)
    );
	 
wire CP0_WE,CP0_BD,M_EXLSet,M_EXLClr;
wire IRQ;
wire [31:0] EPC,M_CP0out;

CP0 cp0(
    .A1(M_instr[15:11]), 
    .A2(M_instr[15:11]), 
    .Din(MFRTM), 
    .PC(PrPC), 
    .ExcCode(M_exccode), 
    .HWInt(HWInt), 
    .WE(CP0_WE), 
    .EXLSet(M_EXLSet), 
    .EXLClr(M_EXLClr), 
    .BD(CP0_BD), 
    .clk(clk), 
    .reset(reset), 
    .IRQ(IRQ), 
    .EPC(EPC), 
    .Dout(M_CP0out)
    );
/*****************************************ME/WB*************************************/
wire [31:0] W_instr;
wire [31:0] W_grf_rs,W_grf_rt;
wire [31:0] W_aluout,W_dmout,W_mulout,W_CP0out;
ME_WB me_wb(
    .clk(clk), 
    .reset(reset),
    .IRQ(IRQ),
	 .PrRD(PrRD),
	 
    .pc_in(M_pc), 
    .pc_out(W_pc), 
    .instr_in(M_instr), 
    .instr_out(W_instr), 
	 .grf_rs_in(MFRSM), 
    .grf_rs_out(W_grf_rs),
    .grf_rt_in(MFRTM), 
    .grf_rt_out(W_grf_rt), 
	 .aluout_in(M_aluout),
	 .aluout_out(W_aluout),
    .dmout_in(M_dmout), 
    .dmout_out(W_dmout),
	 .mulout_in(M_mulout),
	 .mulout_out(W_mulout),
	 .CP0out_in(M_CP0out),
	 .CP0out_out(W_CP0out)
    );
/*******************************************W*************************************/
wire [3:0] W_MemToReg;

wire [4:0] W_rs=W_instr[25:21];
wire [4:0] W_rt=W_instr[20:16];
wire [4:0] W_rd=W_instr[15:11];
wire [4:0] W_WA;
wire [4:0] W_Tnew;
CU w_cu(
    .instr(W_instr), 
    .MemToReg(W_MemToReg), 
    .RegDst(W_RegDst), 
    .RegWrite(W_RegWrite),
	 .W_WA(W_WA),
	 .W_Tnew(W_Tnew)
	 
    );
wire [31:0] W_dmout_ext;
DMOUT_EXT dmout_ext(
    .instr(W_instr), 
    .dmout(W_dmout), 
    .aluout(W_aluout), 
    .dmout_ext(W_dmout_ext)
    );
//RegDataMUX
assign W_grf_wd = (W_MemToReg == `MemToReg_aluout)?W_aluout:
                  (W_MemToReg == `MemToReg_dmout)?W_dmout:
						(W_MemToReg == `MemToReg_dmout_ext)?W_dmout_ext:
						(W_MemToReg == `MemToReg_pc8)?W_pc+8:
						(W_MemToReg == `MemToReg_mulout)?W_mulout:
						(W_MemToReg == `MemToReg_CP0out)?W_CP0out:
						0;

/****************************************************************************************/
FORWARD forward(
    .D_RSA(D_RSA), 
    .D_RTA(D_RTA), 
    .E_RSA(E_RSA), 
    .E_RTA(E_RTA), 
	 .M_RSA(M_RSA),
    .M_RTA(M_RTA), 
    .E_WA(E_WA), 
    .M_WA(M_WA), 
    .W_WA(W_WA), 
    .E_grf_wd(E_grf_wd), 
    .M_grf_wd(M_grf_wd), 
    .W_grf_wd(W_grf_wd), 
    .D_grf_rs(D_grf_rs), 
    .D_grf_rt(D_grf_rt), 
    .E_grf_rs(E_grf_rs), 
    .E_grf_rt(E_grf_rt),
    .M_grf_rs(M_grf_rs),	 
    .M_grf_rt(M_grf_rt), 
    .MFRSD(MFRSD), 
    .MFRTD(MFRTD), 
    .MFRSE(MFRSE), 
    .MFRTE(MFRTE), 
	 .MFRSM(MFRSM),
    .MFRTM(MFRTM)
    );
	 

STALL hazard(
    .instr(D_instr),
	 .start(start),
	 .busy(busy),
    .D_RSTuse(D_RSTuse), 
    .D_RTTuse(D_RTTuse), 
    .E_Tnew(E_Tnew), 
    .M_Tnew(M_Tnew), 
    .W_Tnew(W_Tnew), 
    .E_TWA(E_TWA), 
    .M_TWA(M_TWA),  
	 .D_TRSA(D_TRSA), 
    .D_TRTA(D_TRTA),
    .stall(stall)
    );


endmodule



