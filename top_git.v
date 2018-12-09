`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2018 19:55:10
// Design Name: 
// Module Name: top_git
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top
(
	input				clk_s	,	//50MHz
	input 				rstn_s	,
	input				iDATA	,
	output	reg [ 7:0]	oDATA	,
	output	reg			oDONE	,
	output				oTXDATA	
);
//=========================================================
wire 			clk143M	;
wire			rxDONE	;
wire	[ 7:0]	rxDATA	;

//=========================================================
 always@(*)
begin
	if(!rstn_s)
		begin
			oDATA	=	8'd0	;
			oDONE	=	1'b0	;
		end
	else if(rxDONE)
		begin
			oDATA	=	rxDATA	;
			oDONE	=	rxDONE	;
		end
	else
		oDONE	=	1'b0	;
end 
//=========================================================
rx_rs232	rx_rs232_INST
(
	.clk_s			(clk_s	),		
	.rstn_s			(rstn_s	),
	.iDATA			(iDATA	),
	.oDATA			(rxDATA	),
	.oDONE			(rxDONE	)
);
tx_rs232	tx_rs232_INST
(
	.clk_s			(clk_s	),
	.rstn_s			(rstn_s	),
	.iSEND			(rxDONE	),
	.iDATA			(rxDATA	),
	.oDATA			(oTXDATA),
	.oFINISH		()	
);

endmodule