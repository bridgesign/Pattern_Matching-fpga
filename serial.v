`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2018 06:38:19 PM
// Design Name: 
// Module Name: serial
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


module serial(clk, reset, rxD,sout,signal,counter);
input clk;      //clock
input reset;    //reset
input rxD;      //Serial input

parameter n = 30;   //Pattern bit length

output reg [n-1:0]sout; //Chunked data to be processed
output reg signal;      //Signal to tell that chunk is ready

parameter count = 4;   //For maintaining the chunk counts
output reg [31:0]counter;       //Counter for counting chunks


reg [1:0]delay;     //To give delay for chunked data stabilization and signal toggle
wire [7:0]s_in;     //Input wires from serial communication module
wire sig;           //Input wire for signal from serial communication module
wire otxdata;

top ser(clk,~reset, rxD, s_in, sig, otxdata); //serial communication module

always @(negedge sig, posedge reset)
    if(reset)
    begin
        counter <= 0;   //Reset the counter
    end
    else
    begin
        sout<={sout,s_in};  //Shifting data from serial in to chunked data
        if(counter < (count-1))
        begin
            counter <= counter+1;   //Counter increments
        end
        else if(counter==(count-1))
        begin
            counter <= 0;           //Counter resets
        end
     end
     
always @(posedge clk, posedge reset)
if(reset)
    delay<=0;   //Reset delay
else if(sig==1 && counter==(count-1))
    delay<=1;   //Creating delay
else if(delay==1)
    begin
    delay<=2;
    signal<=1;  //Signal toggle
    end
else if(delay==2)
    begin
    delay<=3;
    end
else if(delay==3)
    begin
        delay<=0;   //Delay resets
        signal<=0;  //Signal toggle
    end
endmodule