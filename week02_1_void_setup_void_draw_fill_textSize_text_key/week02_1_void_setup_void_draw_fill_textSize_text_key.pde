// week02_1_void_setup_void_draw_fill_textSize_text_key
// 鍵盤的操作，與上週的mouse結合
// File-Preference 字型放大
void setup(){ // 設定的函式
  size(500,500);
}
void draw(){
 if(mousePressed) background(#92F5E8);
 else background(#FDA7FF);
 fill(0,0,255);
 textSize(80);
 text("key: " + key,200,300);
}
