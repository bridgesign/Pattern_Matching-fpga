import serial
import time
from math import ceil

#Definition for encoding the input
def convert(s,l):
  #Insert the padding P if required
  if(len(s) <l):
    s = s+"P"*(l - len(s))
  #"v" is the value to be sent in form of bytes
  v = 0
  for c in s:
    #A encoded as 000.
    #Hence we shift it three times.
    if c=='A':
      v*=2
      v*=2
      v*=2
    #T encoded as 001
    #Hence three shifts and then adding 1.
    elif c=='T':
      v*=2
      v*=2
      v*=2
      v+=1
    #G encoded as 010.
    #Hence shifted twice, add 1 and shift.
    elif c=='G':
      v*=2
      v*=2
      v+=1
      v*=2
    #C enoded as 011.
    #Hence shift twice, add 1, shift and add 1.
    elif c=='C':
      v*=2
      v*=2
      v+=1
      v*=2
      v+=1
    #P enocded as 110
    # Hence shift, add 1, shift, add 1 and shift.
    elif c=='P':
      v*=2
      v+=1
      v*=2
      v+=1
      v*=2
    #E encoded as 111
    elif c=='E':
      v*=2
      v+=1
      v*=2
      v+=1
      v*=2
      v+=1
    #S encoded as 100
    elif c=='S':
      v*=2
      v+=1
      v*=2
      v*=2
  #Defines the array containing values of each byte
  send =[]
  #For defining the number of bytes to be sent
  lent = ceil((l*3)/8)
  #Appending the values to send.
  for i in range(lent):
    send.append((v//256**(lent-i-1))%256)
  return send

#Defines the file operator for file
fp = open(input("File: "),'r')

#Stroes the input pattern
pattern = input("Pattern: ")
#Stores the length of pattern
l = len(pattern)

#Defines the port for serial
port = input("Input Port: ")

#Defines the serial with given port
ser = serial.Serial(port)

#Defines the baudrate for serial
ser.baudrate=int(input("Baudrate: "))

#Prints the serial details
print(ser)

#Check if serial port open. If not then try to open it.
if ser.is_open==False:
  try:
    ser.open()
  except:
    print("Serial Port not open")

#Sends the start bits for starting the pattern matching
s = 'S'
for i in convert(s,l):
  ser.write(bytes([i]))

#Sends the pattern data
s = pattern
for i in convert(s,l):
  ser.write(bytes([i]))

#Start to send the text
s = fp.read(l)
while(s!=''):
  for i in convert(s,l):
    ser.write(bytes([i]))
  s = fp.read(l)

#Sends the end signal for matching
s = 'E'
for i in convert(s,l):
  ser.write(bytes([i]))

#Closes the serial and file handlers
ser.close()
fp.close()
