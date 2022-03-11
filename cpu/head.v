`timescale 1ns / 1ps
//NPC
`define pc4 4'b0000
`define ifbeq 4'b0001
`define ifbne 4'b0010
`define ifblez 4'b0011
`define ifbltz 4'b0100
`define ifbgez 4'b0101
`define ifbgtz 4'b0110
`define ifjal 4'b0111
`define ifjr 4'b1000
`define ifj 4'b1001
`define ifjalr 4'b1010


//EXT
`define ext_zero 4'b0000
`define ext_sign 4'b0001
`define ext_2 4'b0010
`define ext_tohigh 4'b0011
`define ext_shamt 4'b0100

//ALU
`define alu_and 5'b00000
`define alu_or 5'b00001
`define alu_add 5'b00010
`define alu_sub 5'b00011
`define alu_xor 5'b00100
`define alu_nor 5'b00101
`define alu_sll 5'b00110
`define alu_srl 5'b00111
`define alu_sra 5'b01000
`define alu_sllv 5'b01001
`define alu_srlv 5'b01010
`define alu_srav 5'b01011
`define alu_slt 5'b01100
`define alu_sltu 5'b01101


//CU
`define RegDst_rt 4'b0000
`define RegDst_rd 4'b0001
`define RegDst_31 4'b0010

`define E_ToReg_imm32 4'b0000
`define E_ToReg_pc8 4'b0001

`define ALUSrcA_grf_rs 4'b0000
`define ALUSrcA_grf_rt 4'b0001

`define ALUSrcB_grf_rt 4'b0000
`define ALUSrcB_grf_rs 4'b0001
`define ALUSrcB_imm 4'b0010

`define M_ToReg_aluout 4'b0000
`define M_ToReg_pc8 4'b0001
`define M_ToReg_mulout 4'b0010

`define MemToReg_aluout 4'b0000
`define MemToReg_dmout 4'b0001
`define MemToReg_dmout_ext 4'b0010
`define MemToReg_pc8 4'b0011
`define MemToReg_mulout 4'b0100
`define MemToReg_CP0out 4'b0101

//CP0
`define SR 12
`define Cause 13
`define EPC 14
`define PrID 15

//ExcCode
`define exccode_int 5'd0
`define exccode_adel 5'd4
`define exccode_ades 5'd5
`define exccode_ri 5'd10
`define exccode_ov 5'd12

//mfc0,mtc0,eret
`define COP0 6'b010000
`define MF 5'b00000
`define MT 5'b00100
`define eret 6'b011000


//opcode
`define R 6'b000000
`define ori 6'b001101
`define addi 6'b001000
`define addiu 6'b001001
`define andi 6'b001100
`define xori 6'b001110
`define slti 6'b001010
`define sltiu 6'b001011
`define lui 6'b001111

`define lw 6'b100011
`define lb 6'b100000
`define lbu 6'b100100
`define lh 6'b100001
`define lhu 6'b100101

`define sw 6'b101011
`define sb 6'b101000
`define sh 6'b101001

`define beq 6'b000100
`define bne 6'b000101
`define blez 6'b000110
`define bltz_regimm 6'b000001
`define bltz 5'b00000
`define bgez_regimm 6'b000001
`define bgez 5'b00001
`define bgtz 6'b000111
`define jal 6'b000011
`define j 6'b000010

//func
`define add 6'b100000//R
`define addu 6'b100001//R
`define sub 6'b100010//R
`define subu 6'b100011//R
`define and_ 6'b100100//R
`define or_ 6'b100101//R
`define xor_ 6'b100110//R
`define nor_ 6'b100111//R
`define sll 6'b000000//R
`define srl 6'b000010//R
`define sra 6'b000011//R
`define sllv 6'b000100//R
`define srlv 6'b000110//R
`define srav 6'b000111//R
`define slt 6'b101010//R
`define sltu 6'b101011//R
`define jr 6'b001000//R 
`define jalr 6'b001001//R

`define mult 6'b011000
`define multu 6'b011001
`define div 6'b011010
`define divu 6'b011011
`define mfhi 6'b010000
`define mflo 6'b010010
`define mthi 6'b010001
`define mtlo 6'b010011
