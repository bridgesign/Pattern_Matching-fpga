# Pattern_Matching-fpga
Project-cum-presentation for ES203:Digital Systems. The project was done on Basys3 board. It counts the number of overlapping occurences of a pattern in the given DNA text.
## Introduction
The static pattern matching problem has a text and a pattern given as its inputs
and the outputs are all the text locations where the pattern occurs.  The first linear
time  algorithm  was  given  by  Knuth,  Morris  and  Pratt  (KMP  Algorithm) and many more algorithms have been developed.
We here will be encoding a given gene data and pattern and finding the number of
matches in the gene data.  For this, we will use the 'Fischer Patterson Algorithm'.

We  are  going  to  modify  the  implementation  of  the  algorithm  and  simplify  it
due the fact that the implementation will be on FPGA. We need to do this so that
bit-wise manipulation is possible according to our requirements.
Thus we can formulate the problem statement as follows:
• Implement a way to load the given huge-size data( a gene sequence, basically)
in chucks on the FPGA.
• Find  the  number  of  overlapping  matches  of  the  pattern(to  be  loaded  exter-
nally).
• Display the number of matches on the FPGA board.
• Verify  the  result  generated  by  the  FPGA  through  some  other  means(here,
through python).
## Requirements
Python 3 with pyserial library for serial communication.
Basys3 FPGA board.
## Parameters
There are two parameters which need to be set 
