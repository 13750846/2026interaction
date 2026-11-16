//week11_4_processing_2048
//from week10_4_processing_2048
//2048格子上下移動
import processing.serial.*;
Serial myPort;

void setup(){
  size(550, 550);
  genNewBlock();
  myPort = new Serial(this,"COM3", 9600);
}
//int [][] a = {{0, 2, 0, 0}, {0, 0, 0, 0}, {0, 2, 2, 2}, {4, 4, 4, 4} };
int [][] a = new int[4][4];
void genNewBlock() {
  int zero = 0;
  for(int i=0; i<4; i++){
    for(int j=0; j<4; j++){
      if (a[i][j]==0) zero++;
  }
}
int choose = int(random(zero));
for(int i=0; i<4; i++){
    for(int j=0; j<4; j++){
      if (a[i][j]==0) {
        if(choose==0) a[i][j] = 2;
        choose--;
      }
    }
  }
} 
void keyPressed(){
  if(keyCode==RIGHT) move(1);
  if(keyCode==LEFT) move(2);
  if(keyCode==UP) move(3);
  if(keyCode==DOWN) move(4);
}
void move(int type) {
  if (type==1) {
    for(int i=0; i<4; i++){
      int j2 = 3;
      for(int j=3; j>=0; j--){
        if(a[i][j]>0) {
          int temp = a[i][j2];
          a[i][j2] = a[i][j];
          a[i][j] = temp;
          j2--;
        }
      }
    }
  } else if (type==2){
    for(int i=0; i<4; i++){
      int j2 = 0;
      for(int j=0; j<4; j++){
        if(a[i][j]>0) {
          int temp = a[i][j2];
          a[i][j2] = a[i][j];
          a[i][j] = temp;
          j2++;
        }
      }
    } 
  } else if (type==3){
    for(int j=0; j<4; j++){
      int i2 = 0;
      for(int i=0; i<4; i++){
        if(a[i][j]>0) {
          int temp = a[i2][j];
          a[i2][j] = a[i][j];
          a[i][j] = temp;
          i2++;
        }
      }
    } 
  } else if (type==4){
    for(int j=0; j<4; j++){
      int i2 = 3;
      for(int i=3; i>=0; i--){
        if(a[i][j]>0) {
          int temp = a[i2][j];
          a[i2][j] = a[i][j];
          a[i][j] = temp;
          i2--;
        }
      }
    }
  } 
  genNewBlock();
}
int x = 128,y = 128, sw = 0;
void draw(){
  background(250, 248, 239);
  if (myPort.available() >= 3){
    int x2 = (int)myPort.read();
    int y2 = (int)myPort.read();
    int sw2 = (int)myPort.read();
    if (x < 128+50 && x2 >= 128+50) move(1);
    if (x > 128-50 && x2 <= 128-50) move(2);
    if (y < 128+50 && y2 <= 128+50) move(3);
    if (y > 128-50 && y2 <= 128-50) move(4);
    x = x2;
    y = y2;
}
  noStroke();
  fill(187, 173, 160);
  rect(40, 40, 450, 450, 9);
  for (int i=0; i<4; i++){
    for (int j=0; j<4; j++){
      int x = 50 + j * (100+10); 
      int y = 50 + i * (100+10);
      fill( tileColor(a[i][j]) );
      rect(x, y, 100, 100, 6);
    }
  }
}
int tileColor(int n) {
  switch(n) {
    case 0:return color(205,193,180);
    case 2:return color(238,228,218);
    case 4:return color(237,224,200);
    case 8:return color(242,177,121);
    case 16:return color(245,149,99);
    case 32:return color(246,124,95);
    case 64:return color(246,94,59);
    case 128:return color(237,207,114);
    case 256:return color(237,204,97);
    case 512:return color(237,200,80);
    case 1024:return color(237,197,63);
    default:return color(237,194,46);
  }
}
