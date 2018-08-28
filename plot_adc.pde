// Pro_Graph2.pde //<>//
/*
 Used in the Youtube video "Arduino and Processing ( Graph Example )"
 Based in the Tom Igoe example.
 Mofified by Arduining 17 Mar 2012:
  -A wider line was used. strokeWeight(4);
  -Continuous line instead of vertical lines.
  -Bigger Window size 600x400.
-------------------------------------------------------------------------------
This program takes ASCII-encoded strings
from the serial port at 9600 baud and graphs them. It expects values in the
range 0 to 1023, followed by a newline, or newline and carriage return

Created 20 Apr 2005
Updated 18 Jan 2008
by Tom Igoe
This example code is in the public domain.
*/

import processing.serial.*;

Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph 

//Variables to draw a continuous line.
int lastxPos=1;
int lastheight=400;

void setup () {
  // set the window size:
  size(512, 800);        

  // List all the available serial ports
  println(Serial.list());
  // Check the listed serial ports in your machine
  // and use the correct index number in Serial.list()[].

  myPort = new Serial(this, Serial.list()[0], 115200);  //

  // A serialEvent() is generated when a newline character is received :
  myPort.bufferUntil('\n');
  
  for(int i=0; i<512; i++)
  {
    vals[i] = 0;
  }
}
volatile int vals[] = new int[512];
void draw () {
  background(125);      // set inital background:
  
  stroke(255,0,0); //stroke(127,34,255);     //stroke color
  strokeWeight(1);        //stroke wider
  line(0, (height/2) , width , (height/2)); 
  
  for( int i = 1; i < 512; i++)
  {
    stroke(255,255,255); //stroke(127,34,255);     //stroke color
    strokeWeight(2);        //stroke wider
    line(i-1, vals[i-1], i, vals[i]); 
  }
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);                // trim off whitespaces.
    if( inString.charAt(0) == 's' )
    {
      //we have 512 integers that we need to print
      int charPtrIdx = 1;  //charAt(0) == s,... 1 begins first integer
      for(int i=0; i< 512; i++)
      {
        //find the substring of the next integer
        int tmpPtr = inString.indexOf(",", charPtrIdx);
        String sNextInt;
        if(i<511)
        {
          sNextInt = inString.substring(charPtrIdx, tmpPtr);
        }else
        {
          sNextInt = inString.substring(charPtrIdx);
        }
        charPtrIdx = tmpPtr + 1;
        float fNextInt = float(sNextInt);
        fNextInt *= -1;
        fNextInt = map(fNextInt, -512, 511, 0, height);
        int iNextInt = int(fNextInt);
        vals[i] = iNextInt;
      }
    }
  }
}
