`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 10/07/2018 06:53:30 PM
// Designer Name: Rohan Patil 
// Module Name: control_unit
// Project Name: Pattern Matching
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: serial, ledDisplay and multiplication_unit
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit(clk,seg,an,reset,rxD,signal,state,counter);
    input clk;                          //Clock from FPGA
    input reset;
    input rxD;
    output [6:0]seg;                    //Led Display
    output [3:0]an;                     //Select Display unit
    output [9:0]counter;

    reg [15:0]led_display;              //Input to the Led Display Unit
    
    parameter n = 30;
    
    output reg [2:0]state;              //Used to keep track of state
    wire [n:1]s_in;                     //Wires from output from serial
    output wire signal;                 //Wire from signal of serial
    reg [n:1]pattern;                   //Stores the pattern
    wire [2*n:1]fft_op1;                //Output from first FFT module
     wire [2*n:1]fft_op2;               //Output from second FFT module
     reg [2*n:1]count1;                 //Stores the bitwise OR of Multiplication unit
     reg [2*n:1]count2;                 //Stores the bitwise OR of Multiplication unit
                                        //in next pass
    reg [2*n:1]temp;                    //Temporary memory for processing
    reg [2*n:1]count;                   //For counting the occurences
   
    reg d_count;                        //For keeping track of double count
    
    reg [1:0]fsm;                       //For triggering states with delay
    
    integer k;                          //For delay
    
    serial serial_in(clk,reset,rxD,s_in,signal,counter);//Chunked data from serial
    multiplication_unit fft_1(pattern, ~s_in, clk, signal, fft_op1);
    multiplication_unit fft_2(~pattern, s_in, clk, signal, fft_op2);
    ledDisplay display(led_display, clk,0, seg, an,nul);//Led Display Unit

always @(negedge signal, posedge reset)
begin
    if(reset)
    begin
        state <= 3'b000;    //State reset
    end
    else
    begin
        if((state==3'b000) && (s_in[n:(n-2)] == 3'b100))
            state <= 3'b001;
        else if(state==3'b001)
            state <= 3'b011;          //Pattern Copying
        else if(state==3'b011)
            state <= 3'b111;          //Initial data collect
        else if(state==3'b111)
            state <= 3'b110;         //Pattern Matching Started
        else if(state==3'b110 && (s_in[n:(n-2)] == 3'b111))
        begin
            state <= 3'b100;         //Change State on Serial End            
        end
    end
end

always @(posedge clk)
begin
    if(reset)   //Reset
    begin
        k = 0;
        temp = 0;
        count = 0;
        count1=0;
        count2=0;
        led_display = 0;
        d_count = 0;
        fsm = 2'b00;
    end
    else
    begin
        if((state==3'b000) && (s_in[n:(n-2)] == 3'b100))
        begin
            led_display = 0;            //Reset the led display
            d_count = 0;                //Reset double count
        end
        else if(state==3'b011)
           fsm = 2'b10;                 //State for pattern copying
        else if(state==3'b111)
            fsm = 2'b01;                //State for initial data collect
        else if(state==3'b110 && (s_in[n:(n-2)] != 3'b111))
        begin
            count1 = count2;
            fsm = 2'b11;                //State for pattern matching
        end
    end

    if (signal==1) begin
        k = 0;  //Reset counting integer
    end
    else if(fsm==2'b00)
       fsm <=fsm;
    else if(fsm==2'b01)
    begin
        if(k<(n+2))     //For generating delay to get stable output from
                        //Multiplication Unit
            k = k + 1;
        else
        begin
            count2 = fft_op1 | fft_op2;  //Gets the bitwise OR
            fsm = 2'b00;
        end
    end
    else if(fsm==2'b11)
    begin
        if(k<(n+2))     //For generating delay to get stable output from
                        //Multiplication Unit
            k = k+1;
        else if(k==n+2)
        begin
            count2 = fft_op1 | fft_op2;  //Gets the bitwise OR
            temp = count2 >> n-1;
            count1 = count1 << 1;
            count = count1 | temp;      //Gets the bitwise OR
            k=k+1;
        end
        else if(k<2*n+4)
        begin
           if(count[k-n-2] == 0)
                    led_display = led_display+1;    //Increase led output
           k = k+3;     //Increasing the counter according to encoding
        end
        else if(k==2*n+6)
        begin
           led_display = led_display - d_count;    //Remove Double Count
            if(count[1]==0)
                d_count = 1;                        //Double Count Check
            else
                d_count = 0;
           k = k+1;
           fsm = 2'b00;
        end
    end
    else if(fsm==2'b10)
    begin
    //Stores pattern in reverse
        if(k<n)
        begin
            pattern[n-k] = s_in[k+1];
            k = k+1;
        end
        else
            fsm = 2'b00;
    end

end

endmodule
