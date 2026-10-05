// week05_1_processing_do_re_mi_Serial
// 修改week02_5_processing_do_re_mi_import_serial_myPort_void_keyPressed_write
// 我想要把Arduino 跟 Processing 結合
// 在Processing 按下 key 1 2 3 對應 Arduino 的 Do Re Mi 使用 USB Serial
import processing.serial.*;
Serial myPort;
void setup(){
  size(300,200);
  myPort = new Serial(this, "COM3", 9600);
}
void draw(){

}
void keyPressed(){
  if(key=='1')myPort.write('1');
  if(key=='2')myPort.write('2');
  if(key=='3')myPort.write('3');
}
