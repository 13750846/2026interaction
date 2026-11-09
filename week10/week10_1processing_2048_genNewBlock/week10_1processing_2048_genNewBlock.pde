// week10_1processing_2048_genNewBlock
// 修改自 week09_5_processing_2048_array
// 自己寫 2048 配上聲音，從簡單到完整
void setup(){
  size(550,550);
  genNewBlock();
}
//int [][]a = { {0, 2, 0, 0}, {0, 0, 0, 0}, {0, 2, 2, 2}, {4, 4, 4, 4} };
int[][]a = new int[4][4];
void genNewBlock(){
  int zeros = 0;
  for(int i=0; i<4; i++){ // 用迴圈，畫4*4格子
    for(int j=0; j<4; j++){
      if (a[i][j]==0) zeros++;
    }
  }
  int choose = int(random(zeros));
  for(int i=0; i<4; i++){
    for(int j=0; j<4; j++){
      if(a[i][j]==0){
        if(choose==0) a[i][j] = 2;
        choose--;
      }
    }
  }
}
void keyPressed(){
  genNewBlock();
}
void draw(){
  background(255, 242, 204); // 淡淡的背景色
  noStroke(); // 不要黑線
  fill(119, 110, 101); //大格子色彩
  rect(40, 40, 450, 450, 9); // 大格子
  for(int i=0; i<4; i++){
    for(int j=0; j<4; j++){
      int x = 50 + j *(100+10);
      int y = 50 + i * (100+10);
      fill(tileColor(a[i][j]));
      rect(x,y,100,100,6);
    }
  }
}
int tileColor(int n) { // week09_5 這個函式，是 week09_3 最後面拿來用
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
