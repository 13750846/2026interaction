// week01_2_void_setup_void_draw_if_mousePressed_background
void setup(){
  size(500,500); // 視窗大小
}
void draw() { //準備畫圖的函式，每次60秒
  if(mousePressed) background(255, 0 ,0); 
  else background(0, 255,0); //否則 呂色
}
