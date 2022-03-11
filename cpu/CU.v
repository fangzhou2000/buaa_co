`timescale 1ns / 1ps
`include"head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:46:31 11/28/2020 
// Design Name: 
// Module Name:    CU 
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
module CU(
    input wire overflow,
    input wire IRQ,
    input wire [31:0] instr,
/************D************/
	 output wire [3:0] ExtOp,
	 output wire [3:0] Branch,
	 output wire [4:0] D_RSA,
	 output wire [4:0] D_RTA,
	 output wire [4:0] D_RSTuse,
	 output wire [4:0] D_RTTuse,
	 output wire [4:0] D_TRSA,
	 output wire [4:0] D_TRTA,
	 
	 output wire RI,
	 output wire D_EXLClr,
/************E************/	 
	 output wire [3:0] ALUSrcA,
	 output wire [3:0] ALUSrcB,
	 output wire [4:0] ALUOp,
	 output wire [3:0] E_ToReg,
	 output wire [4:0] E_RSA,
	 output wire [4:0] E_RTA,
	 output wire [4:0] E_WA,
	 output wire [4:0] E_TWA,
	 output wire [4:0] E_Tnew,
	 
	 output wire E_EXLClr,
	 output wire E_Ov,
/*************M************/	 
	 output wire MemRead,
	 output wire MemWrite,
	 output wire [3:0] M_ToReg,
	 output wire [4:0] M_RSA,
	 output wire [4:0] M_RTA,
	 output wire [4:0] M_WA,
	 output wire [4:0] M_TWA,
	 output wire [4:0] M_Tnew,
	 
	 output wire CP0_WE,
	 output wire M_EXLSet,
	 output wire M_EXLClr,
	 output wire Branch_eret,
	 output wire M_Ov,
	 
/*************W************/	 
	 output wire [3:0] MemToReg,
	 output wire [3:0] RegDst,
	 output wire RegWrite,
	 output wire [4:0] W_WA,
	 output wire [4:0] W_Tnew
    );
	 
	 wire [5:0]func,op;
	 wire [4:0]rs,rt,rd;
	 assign func=instr[5:0];
	 assign rd=instr[15:11];
	 assign rt=instr[20:16];
	 assign rs=instr[25:21];
	 assign op=instr[31:26];
	 
	 wire add,addu,sub,subu,and_,or_,xor_,nor_,sll,srl,sra,sllv,srlv,srav,slt,sltu;
	 wire ori,addi,addiu,andi,xori,slti,sltiu,lui;
	 wire lw,lb,lbu,lh,lhu;
	 wire sw,sb,sh;
	 wire beq,bne,blez,bltz,bgez,bgtz,jal,jr,j,jalr;
	 wire mult,multu,div,divu,mfhi,mflo,mthi,mtlo;
	 wire mfc0,mtc0,eret;
	 
	 assign add = (op == `R&&func == `add) ? 1 : 0;
	 assign addu = (op == `R&&func == `addu) ? 1 : 0;
	 assign sub = (op == `R&&func == `sub) ? 1 : 0;
	 assign subu = (op == `R&&func == `subu) ? 1 : 0;
	 assign and_ = (op == `R&&func == `and_) ? 1 : 0;
	 assign or_ = (op == `R&&func == `or_) ? 1 : 0;
 	 assign xor_ = (op == `R&&func == `xor_) ? 1 : 0;
	 assign nor_ = (op == `R&&func == `nor_) ? 1 : 0;
	 assign sll = (op == `R&&func == `sll) ? 1 : 0;
	 assign srl = (op == `R&&func == `srl) ? 1 : 0; 
	 assign sra = (op == `R&&func == `sra) ? 1 : 0;
	 assign sllv = (op == `R&&func == `sllv) ? 1 : 0;
	 assign srlv = (op == `R&&func == `srlv) ? 1 : 0; 
	 assign srav = (op == `R&&func == `srav) ? 1 : 0;
	 assign slt = (op == `R&&func == `slt) ? 1 : 0;
	 assign sltu = (op == `R&&func == `sltu) ? 1 : 0;
	 
	 assign ori = (op == `ori) ? 1 : 0;
	 assign addi = (op == `addi) ? 1 : 0;
	 assign addiu = (op == `addiu) ? 1 : 0;
	 assign andi = (op == `andi) ? 1 : 0;
	 assign xori = (op == `xori) ? 1 : 0;
	 assign slti = (op == `slti) ? 1 : 0;
	 assign sltiu = (op == `sltiu) ? 1 : 0; 
	 assign lui = (op == `lui) ? 1 : 0;
	 
    assign lw = (op == `lw)	? 1 : 0;
	 assign lb = (op == `lb) ? 1 : 0;
	 assign lbu = (op == `lbu) ? 1 : 0;
	 assign lh = (op == `lh) ? 1 : 0;
	 assign lhu = (op == `lhu) ? 1 : 0;
	 
    assign sw = (op == `sw) ? 1 : 0;
	 assign sb = (op == `sb) ? 1 : 0;
	 assign sh = (op == `sh) ? 1 : 0;
	 
    assign beq = (op == `beq) ? 1 : 0;
	 assign bne = (op == `bne) ? 1 : 0;
	 assign blez = (op == `blez) ? 1 : 0;
	 assign bltz = (op == `bltz_regimm && rt == `bltz) ? 1 : 0;
	 assign bgez = (op == `bgez_regimm && rt == `bgez) ? 1 : 0;
	 assign bgtz = (op == `bgtz) ? 1 : 0;
    assign jal = (op == `jal) ? 1 : 0;	 
	 assign j = (op == `j) ? 1 : 0;
	 assign jr = (op == `R&&func == `jr) ? 1 : 0;
	 assign jalr = (op == `R&&func == `jalr) ? 1 : 0; 
	 
	 assign mult = (op == `R&&func == `mult)?1:0;
    assign multu = (op == `R&&func == `multu)?1:0;
    assign div = (op == `R&&func == `div)?1:0;
    assign divu = (op == `R&&func == `divu)?1:0;
    assign mfhi = (op == `R&&func == `mfhi)?1:0;
    assign mflo = (op == `R&&func == `mflo)?1:0;
    assign mthi = (op == `R&&func == `mthi)?1:0;
    assign mtlo = (op == `R&&func == `mtlo)?1:0;
	 
	 assign mfc0 = (op == `COP0&&rs == `MF)?1:0;
	 assign mtc0 = (op == `COP0&&rs == `MT)?1:0;
	 assign eret = (op == `COP0&&func == `eret)?1:0;
	 
	 wire cal_r,cal_i,store,load,b,j_l,j_r,md,mt,mf;
	 assign cal_r = (add|addu|sub|subu|and_|or_|xor_|nor_|sll|srl|sra|sllv|srlv|srav|slt|sltu)?1:0;
	 assign cal_i = (ori|addi|addiu|andi|xori|slti|sltiu)?1:0;
	 assign store = (sw|sb|sh)?1:0;
	 assign load = (lw|lb|lbu|lh|lhu)?1:0;
	 assign b = (beq|bne|blez|bltz|bgez|bgtz)?1:0;
	 assign j_l = (j|jal)?1:0;
	 assign j_r = (jr|jalr)?1:0; 
	 assign md = (mult|multu|div|divu)?1:0;
	 assign mt = (mthi|mtlo)?1:0;
	 assign mf = (mfhi|mflo)?1:0;
	 
/*************************************************D**************************************************/	 
	 
	 assign RI = (instr == 0/*nop*/|add|addu|sub|subu|and_|or_|xor_|nor_|
	              sll|srl|sra|sllv|srlv|srav|slt|sltu|
	              ori|addi|addiu|andi|xori|slti|sltiu|lui|
					  lw|lb|lbu|lh|lhu|
					  sw|sb|sh|
					  beq|bne|blez|bltz|bgez|bgtz|jal|jr|j|jalr|
					  mult|multu|div|divu|mfhi|mflo|mthi|mtlo|
					  mfc0|mtc0|eret) ? 0 : 1;//注意别写反了
	 assign D_EXLClr = (eret)?1:0;
	 
	 assign ExtOp = (ori|andi|xori)?`ext_zero:
	                (lw|lb|lbu|lh|lhu|sw|sb|sh|addi|addiu|slti|sltiu)?`ext_sign:
						 (beq|bne|blez|bltz|bgez|bgtz)?`ext_2:
						 (lui)?`ext_tohigh:
						 (sll|srl|sra)?`ext_shamt:
						 0;
	 assign Branch = (beq)?`ifbeq:
	                 (bne)?`ifbne:
						  (blez)?`ifblez:
						  (bltz)?`ifbltz:
						  (bgez)?`ifbgez:
						  (bgtz)?`ifbgtz:
	                 (j)?`ifj:
                    (jal)?`ifjal:
                    (jr)?`ifjr:
                    (jalr)?`ifjalr:				  
	                 `pc4;
	 assign D_RSA = (b|jr|jalr)?rs:0;
	 assign D_RTA = (beq|bne)?rt:0;
	 
	 assign D_TRSA = (cal_r|cal_i|load|store|b|jr|jalr|md|mt)?rs:0;
	 assign D_TRTA = (cal_r|store|beq|bne|md|mtc0)?rt:0;
	 
	 assign D_RSTuse = (cal_r|cal_i|load|store|md|mt)?1:
	                   (b|jr|jalr)?0:  
							  31;
	 assign D_RTTuse = (store|mtc0)?2:
	                   (cal_r|md)?1:
							 (beq|bne)?0:
	 						  31;
/************************************************E**************************************************/
    
	 assign E_EXLClr = (eret)?1:0;
	 assign E_Ov = ((add|addi|sub)&&overflow)?1:0;
	 
	 assign ALUSrcA = (sll|srl|sra|sllv|srlv|srav)?`ALUSrcA_grf_rt:
	                  `ALUSrcA_grf_rs;
	 assign ALUSrcB = (add|addu|sub|subu|and_|or_|xor_|nor_|slt|sltu)?`ALUSrcB_grf_rt:
	                  (sllv|srlv|srav)?`ALUSrcB_grf_rs:
	                  (ori|addi|addiu|andi|xori|slti|sltiu|lw|lb|lbu|lh|lhu|sw|sb|sh|lui|sll|srl|sra)?`ALUSrcB_imm:
							 0;
	 assign ALUOp = (add|addu|lw|lb|lbu|lh|lhu|sw|sb|sh|lui|addi|addiu)?`alu_add:
	                (sub|subu)?`alu_sub:
						 (and_|andi)?`alu_and:
						 (or_|ori)?`alu_or:
						 (xor_|xori)?`alu_xor:
						 (nor_)?`alu_nor:
						 (sll)?`alu_sll:
						 (srl)?`alu_srl:
						 (sra)?`alu_sra:
						 (sllv)?`alu_sllv:
						 (srlv)?`alu_srlv:
						 (srav)?`alu_srav:
						 (slt|slti)?`alu_slt:
						 (sltu|sltiu)?`alu_sltu:
						  0;
	 assign E_ToReg = (lui)?`E_ToReg_imm32:
	                  (jal|jalr)?`E_ToReg_pc8:
							0;
															
	 assign E_RSA = (cal_r|cal_i|load|store|md|mt)?rs:0;
    assign E_RTA = (cal_r|store|md|mtc0)?rt:0;//store提前转发
    assign E_WA = (lui)?rt:
	               (jal)?5'b11111:
						(jalr)?rd:
						0;

	 assign E_TWA = (cal_r|jalr|mf)?rd:
	                (cal_i|load|lui|mfc0)?rt:
						 (jal)?5'b11111:
						 0;
	 assign E_Tnew = (load|mfc0)?2:
	                 (cal_r|cal_i|mf)?1:
						  0;
/*******************************************************M***********************************************/
    
	 assign CP0_WE = (mtc0)?1:0;
	 assign M_EXLSet = (IRQ)?1:0;
	 assign M_EXLClr = (eret)?1:0;
	 assign Branch_eret = (eret)?1:0;
	 assign M_Ov = ((sw|sh|sb|lw|lh|lhu|lb|lbu)&&overflow)?1:0;
	 
	 assign MemRead = (lw|lb|lbu|lh|lhu|sb|sh)?1:0;//注意sbsh
	 assign MemWrite = (sw|sb|sh)?1:0;
	 assign M_ToReg = (add|addu|sub|subu|and_|or_|xor_|nor_|sll|srl|sra|sllv|srlv|srav|slt|sltu|
	                   ori|addi|addiu|andi|xori|slti|sltiu|lui)?`M_ToReg_aluout:
	                  (jal|jalr)?`M_ToReg_pc8:
							(mf)?`M_ToReg_mulout:
							0;
	 
	 assign M_RSA = 0;
	 assign M_RTA = (store|mtc0)?rt:
	                0;
	 
	 assign M_WA = (cal_r|jalr|mf)?rd:
	               (cal_i|lui)?rt:
						(jal)?5'b11111:
						0;
	 
	 assign M_TWA = (cal_r|jalr|mf)?rd:
	                (cal_i|load|lui|mfc0)?rt:
						 (jal)?5'b11111:
						 0;
	 assign M_Tnew = (load|mfc0)?1:
	                 (cal_r|cal_i|mf)?0:
						  0;
/********************************************************W*********************************************/

	 
	 assign MemToReg = (add|addu|sub|subu|and_|or_|xor_|nor_|sll|srl|sra|sllv|srlv|srav|slt|sltu|
	                    ori|addi|addiu|andi|xori|slti|sltiu|lui)?`MemToReg_aluout:
	                   (lw)?`MemToReg_dmout:
							 (lb|lbu|lh|lhu)?`MemToReg_dmout_ext:
                      (jal|jalr)?`MemToReg_pc8:
							 (mf)?`MemToReg_mulout:
							 (mfc0)?`MemToReg_CP0out:
                       0; 							 
	 assign RegDst = (add|addu|sub|subu|and_|or_|xor_|nor_|sll|srl|sra|sllv|srlv|srav|slt|sltu|jalr|mf)?`RegDst_rd:
	                 (ori|addi|addiu|andi|xori|slti|sltiu|lw|lb|lbu|lh|lhu|lui|mfc0)?`RegDst_rt:
	                 (jal)?`RegDst_31:
						   0;
	 assign RegWrite = (add|addu|sub|subu|and_|or_|xor_|nor_|sll|srl|sra|sllv|srlv|srav|slt|sltu|
	                    ori|addi|addiu|andi|xori|slti|sltiu|lw|lb|lbu|lh|lhu|lui|jal|jalr|mf|mfc0)?1:0;
	 
	 assign W_WA = (cal_r|jalr|mf)?rd:
	               (cal_i|load|lui|mfc0)?rt:
						(jal)?5'b11111:
						 0;
	 assign W_Tnew = 0;
						  
endmodule
