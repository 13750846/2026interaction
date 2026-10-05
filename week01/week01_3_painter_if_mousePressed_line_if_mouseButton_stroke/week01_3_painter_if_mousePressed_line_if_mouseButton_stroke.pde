// week01_3_painter_if_mousePressed_line_if_mouseButton_stroke
// 想做一個小畫家，用 mouse 畫圖
void setup() {
 size(500, 500); 
}

void draw() {
  if (mouseButton==LEFT) stroke(255,0,0); //左鍵綠色
  if (mouseButton==CENTER) stroke(0,255,0); //中鍵紅色
  if (mouseButton==RIGHT) stroke(0,0,255); //右鍵藍色
  if (mousePressed) line(mouseX, mouseY, pmouseX, pmouseY);
  // 按下去的時候，(用剛剛的色彩)畫線 mouse 座標 、之前 mouse 座標
}
