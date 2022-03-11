`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:36:04 11/29/2020 
// Design Name: 
// Module Name:    FORWARD 
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
module FORWARD(
    input wire [4:0] D_RSA,
	 input wire [4:0] D_RTA,
	 input wire [4:0] E_RSA,
	 input wire [4:0] E_RTA,
	 input wire [4:0] M_RSA,
	 input wire [4:0] M_RTA,
	 input wire [4:0] E_WA,//lui
	 input wire [4:0] M_WA,
	 input wire [4:0] W_WA,
	 input wire [31:0] E_grf_wd,
	 input wire [31:0] M_grf_wd,
	 input wire [31:0] W_grf_wd,
	 input wire [31:0] D_grf_rs,
	 input wire [31:0] D_grf_rt,
	 input wire [31:0] E_grf_rs,
	 input wire [31:0] E_grf_rt,
	 input wire [31:0] M_grf_rs,
	 input wire [31:0] M_grf_rt,
	 output wire [31:0] MFRSD,
	 output wire [31:0] MFRTD,
	 output wire [31:0] MFRSE,
	 output wire [31:0] MFRTE,
	 output wire [31:0] MFRSM,
	 output wire [31:0] MFRTM
    );
	 
	 assign MFRSD = (D_RSA == E_WA && D_RSA!=0)?E_grf_wd:
	                (D_RSA == M_WA && D_RSA!=0)?M_grf_wd:
						 //(D_RSA == W_WA && D_RSA!=0)?W_grf_wd://这一级是可见的
						 D_grf_rs;
	 assign MFRTD = (D_RTA == E_WA && D_RTA!=0)?E_grf_wd:
	                (D_RTA == M_WA && D_RTA!=0)?M_grf_wd:
						 //(D_RTA == W_WA && D_RTA!=0)?W_grf_wd://这一级是可见的
						 D_grf_rt;
	 assign MFRSE = (E_RSA == M_WA && E_RSA!=0)?M_grf_wd:
	                (E_RSA == W_WA && E_RSA!=0)?W_grf_wd:
						 E_grf_rs;
	 assign MFRTE = (E_RTA == M_WA && E_RTA!=0)?M_grf_wd:
	                (E_RTA == W_WA && E_RTA!=0)?W_grf_wd:
						 E_grf_rt;
	 assign MFRSM = (M_RSA == W_WA && M_RSA!=0)?W_grf_wd:
	                M_grf_rs;
	 assign MFRTM = (M_RTA == W_WA && M_RTA!=0)?W_grf_wd:
	                M_grf_rt;
						 
	 
	 


endmodule
