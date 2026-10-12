// week06_4_processing_rotate_serial_available_read
// 修改自week06_3_processing_rotate_rect
import processing.serial.*;
Serial myPort;
void setup() {
  size(500,500);
  myPort = new Serial(this, "COM3", 9600);
}
int now = 0;
int dd = 1;
void draw(){
  if(myPort.available() > 0){
    if(myPort.read()=='1')dd = -1;
    else dd = 1;
  }
  background(0);
  translate(250,250);
  now +=dd;
  rotate( radians(frameCount) );
  rect(-200, -200, 400, 400);
}
void mousePressed(){
  if(dd==1) dd = -1;
  else dd = 1;
}
