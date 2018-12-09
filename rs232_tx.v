`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2018 20:01:11
// Design Name: 
// Module Name: rs232_tx_top_ke_saath
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


module tx_rs232
(
	input			clk_s	,
	input			rstn_s	,
	input			iSEND	,
	input	[ 7:0]	iDATA	,
	output			oDATA	,
	output			oFINISH	
);
localparam		clkNUM_bit		=	104	;//Baudrate is 960000
//===============================================================
//UART 0-START [1:8]-DATA 9-EVEN/OOD 10-STOP
localparam		clkNUM_frame	=	clkNUM_bit*11	;
reg				txDATA		;
reg		[ 7:0]	REG_DATA	;
reg		[17:0]	CNT_frame	;	//163691 clk/frame
reg				START_CNT	;
reg				F_SIG		;	//Finish Signal
//===============================================================
always@(posedge clk_s)
begin
	if(!rstn_s)
		begin
			REG_DATA	=	8'hff	;
			START_CNT	=	1'b0	;
		end
	else if(iSEND)
		begin
			REG_DATA	=	iDATA	;
			START_CNT	=	1'b1	;
		end
	else if(CNT_frame == clkNUM_frame - 1'd1)
		START_CNT	=	1'b0	;
end 
//===============================================================
always@(posedge clk_s)
begin
	if(!rstn_s)
		begin
			txDATA	=	1'b1	;
			F_SIG	=	1'b0	;
		end
	else if(!START_CNT)
		begin
			txDATA	=	1'b1	;
			F_SIG	=	1'b0	;
		end
	else if(START_CNT && CNT_frame == clkNUM_bit*0)
		txDATA	<=	1'b0	;
	else if(START_CNT && CNT_frame == clkNUM_bit*1)
		txDATA	<=	REG_DATA[0]	;
	else if(START_CNT && CNT_frame == clkNUM_bit*2)
		txDATA	<=	REG_DATA[1]	;
	else if(START_CNT && CNT_frame == clkNUM_bit*3)
		txDATA	<=	REG_DATA[2]	;
	else if(START_CNT && CNT_frame == clkNUM_bit*4)
		txDATA	<=	REG_DATA[3]	;
	else if(START_CNT && CNT_frame == clkNUM_bit*5)
		txDATA	<=	REG_DATA[4]	;
	else if(START_CNT && CNT_frame == clkNUM_bit*6)
		txDATA	<=	REG_DATA[5]	;
	else if(START_CNT && CNT_frame == clkNUM_bit*7)
		txDATA	<=	REG_DATA[6]	;
	else if(START_CNT && CNT_frame == clkNUM_bit*8)
		txDATA	<=	REG_DATA[7]	;
	else if(START_CNT && CNT_frame == clkNUM_bit*9)
		txDATA	<=	1'b1	;
	else if(START_CNT && CNT_frame == clkNUM_bit*10)
		txDATA	<=	1'b1	;
	else if(START_CNT && CNT_frame == clkNUM_frame-2'd2)
		F_SIG	<=	1'b1	;
	else
		F_SIG	<=	1'b0	;
end
//===============================================================
always@(posedge clk_s)
begin
	if(!rstn_s)
		CNT_frame	<=	18'd0	;
	else if(CNT_frame == clkNUM_frame-1'd1)
		CNT_frame	<=	18'd0	;
	else if(START_CNT)
		CNT_frame	<=	CNT_frame + 1'd1	;
end
//===============================================================
assign	oDATA	=	txDATA		;
assign	oFINISH	=	F_SIG		;
endmodule
