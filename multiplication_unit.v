module multiplication_unit(p,q,clk,signal,p_out);
parameter n = 30;   //Parameter for defining pattern bit length
input [n-1:0]p,q;   //Input bit sequences
input clk;          //clock
input signal;       //Activation signal
output reg [2*n-1:0]p_out;  //Output register
integer i;          //Integer to keep count
reg [(2*n-1):0]t;   //Temporary register for shifting


always @(posedge clk)
    //High signal is acting as reset
    if(signal==1)
        begin
        i = 0;
        t = p;
        p_out = 0;
        end
    else
        begin
        if(i<n)
            begin
            //On first iteration, we need to set the value of p_out to begin
            if(i==0)
                if(q[i]==0)
                    p_out=0;
                else
                    p_out = t;
            else if(q[i]==1)
                p_out = p_out|t;    //Bitwise OR to get the matches
            else
                p_out = p_out;
            t = t<<1;       //Shifting of t
            i = i+1;        //Increasing the counter i
            end
        end
endmodule
