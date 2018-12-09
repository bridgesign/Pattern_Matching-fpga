`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2018 20:00:06
// Design Name: 
// Module Name: re232_top_ke_saath
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


module rx_rs232
(
	input				clk_s	,		
	input				rstn_s	,		
	input				iDATA	,
	output		[ 7:0]	oDATA	,
	output				oDONE			//1Frame finish oDONE=1
);
localparam		clkNUM_bit		=	104	;//Baudrate 960000
//=========================================================
//UART 0-START [1:8]-DATA 9-EVEN/OOD 10-STOP
localparam		clkNUM_frame	=	clkNUM_bit*11	;
reg				D_sig		;	//Detect signal
reg				F_sig		;	//Finish signal
reg		[17:0]	CNT_frame	;	//163691 clk/frame
reg		[ 7:0]	REG_DATA	;
//============== Detect Signal ============================
always@(posedge clk_s)
begin
	if(!rstn_s)
		D_sig	<=	1'b0	;
	else if(!iDATA)		//I detect U
		D_sig	<=	1'b1	;
	else if(CNT_frame==clkNUM_frame)
		D_sig	<=	1'b0	;
end 
//============= CNT_frame =================================
always@(posedge clk_s)
begin
	if(!rstn_s)
		CNT_frame	<=	18'd0	;
	else if(CNT_frame==clkNUM_frame)
		CNT_frame	<=	18'd0	;
	else if(D_sig)
		CNT_frame	<=	CNT_frame + 1'd1	;
	else
		CNT_frame	<=	18'd0	;
end
//============ REG_DATA ===================================
always@(posedge clk_s)
begin
	if(!rstn_s)
		begin
			REG_DATA	<=	8'he0	;
			F_sig		<=	1'b0	;
		end
	else if(CNT_frame == clkNUM_bit/2*3)	//1bit data
		REG_DATA[0]	<=	iDATA	;
	else if(CNT_frame == clkNUM_bit/2*5)	//2bit data
		REG_DATA[1]	<=	iDATA	;
	else if(CNT_frame == clkNUM_bit/2*7)	//3bit data
		REG_DATA[2]	<=	iDATA	;
	else if(CNT_frame == clkNUM_bit/2*9)	//4bit data
		REG_DATA[3]	<=	iDATA	;
	else if(CNT_frame == clkNUM_bit/2*11)	//5bit data
		REG_DATA[4]	<=	iDATA	;
	else if(CNT_frame == clkNUM_bit/2*13)	//6bit data
		REG_DATA[5]	<=	iDATA	;
	else if(CNT_frame == clkNUM_bit/2*15)	//7bit data
		REG_DATA[6]	<=	iDATA	;
	else if(CNT_frame == clkNUM_bit/2*17)	//8bit data
		begin
			REG_DATA[7]	<=	iDATA	;
			F_sig		<=	1'b1	;
		end
	else
		begin
			F_sig		<=	1'b0	;
		end
end
//============== ASSIGN ===================================
assign 	oDATA	=	(F_sig) ? REG_DATA : 8'h00	;
assign	oDONE	=	F_sig		;
endmodule
