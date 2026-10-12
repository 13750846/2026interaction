// week06_5_processing_rotate_chessboard
// 修改自week06_3_processing_rotate_rect
// 想要做一個旋轉的迷宮(西洋的棋盤)
void setup() {
  size(500,500);
}

void draw(){
  background(0);
  translate(250,250);
  rotate( radians(frameCount) );
  rect(-200, -200, 400, 400);
  for (int i=0; i<8; i++){
    for(int j=0; j<8; j++){
      if((i+j)%2 ==1)fill(255);
      else fill(0);
      rect(j*50-200, i*50-200, 50, 50);
    }
  }
}
