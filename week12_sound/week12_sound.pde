import processing.sound.*;

// 8個音階的頻率 (C4 Do ~ C5 高音Do)
float[] freqs = {261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25};
String[] noteNames = {"Do", "Re", "Mi", "Fa", "Sol", "La", "Si", "Do+"};
char[] keyBindings = {'a', 's', 'd', 'f', 'g', 'h', 'j', 'k'};

SinOsc[] oscs = new SinOsc[8];       // 8個獨立振盪器（支援多鍵同時按壓的和弦）
boolean[] isPressed = new boolean[8]; // 記錄每個鍵是否被按下
ArrayList<Ripple> ripples = new ArrayList<Ripple>(); // 存放視覺波紋特效

void setup() {
  size(800, 450);
  textAlign(CENTER, CENTER);
  
  // 初始化 8 個音源
  for (int i = 0; i < 8; i++) {
    oscs[i] = new SinOsc(this);
  }
}

void draw() {
  background(25, 28, 36); // 深色質感背景
  
  // 1. 繪製上方視覺波紋特效區域
  for (int i = ripples.size() - 1; i >= 0; i--) {
    Ripple r = ripples.get(i);
    r.update();
    r.display();
    if (r.isFinished()) {
      ripples.remove(i);
    }
  }
  
  // 2. 繪製下方 8 個鋼琴白鍵
  float keyWidth = width / 8.0;
  float keyHeight = 220;
  float startY = height - keyHeight;
  
  for (int i = 0; i < 8; i++) {
    float x = i * keyWidth;
    
    // 判斷顏色（按下時發光變色，沒按時為象牙白）
    if (isPressed[i]) {
      fill(100, 220, 255); // 按下時的螢光藍
    } else {
      fill(245);
    }
    
    stroke(40);
    strokeWeight(2);
    rect(x, startY, keyWidth, keyHeight, 0, 0, 10, 10); // 下方圓角琴鍵
    
    // 顯示音名與對應鍵盤按鍵
    fill(isPressed[i] ? 20 : 80);
    textSize(20);
    text(noteNames[i], x + keyWidth / 2, startY + keyHeight - 60);
    
    textSize(14);
    fill(130);
    text("[" + Character.toUpperCase(keyBindings[i]) + "]", x + keyWidth / 2, startY + keyHeight - 30);
  }
  
  // 標題提示
  fill(200);
  textSize(16);
  text("使用鍵盤 A ~ K 或滑鼠點擊彈奏", width / 2, 30);
}

// --- 觸發發聲與特效的共用函式 ---
void triggerNote(int index) {
  if (index >= 0 && index < 8 && !isPressed[index]) {
    isPressed[index] = true;
    oscs[index].freq(freqs[index]);
    oscs[index].amp(0.4); // 音量設為 0.4 避免多鍵同時按爆音
    oscs[index].play();
    
    // 在該琴鍵上方產生一個擴散波紋
    float keyWidth = width / 8.0;
    float centerX = index * keyWidth + keyWidth / 2;
    ripples.add(new Ripple(centerX, height - 240, color(100, 220, 255)));
  }
}

void releaseNote(int index) {
  if (index >= 0 && index < 8 && isPressed[index]) {
    isPressed[index] = false;
    oscs[index].stop();
  }
}

// --- 鍵盤事件 ---
void keyPressed() {
  char k = Character.toLowerCase(key);
  for (int i = 0; i < 8; i++) {
    if (k == keyBindings[i]) {
      triggerNote(i);
    }
  }
}

void keyReleased() {
  char k = Character.toLowerCase(key);
  for (int i = 0; i < 8; i++) {
    if (k == keyBindings[i]) {
      releaseNote(i);
    }
  }
}

// --- 滑鼠事件 ---
void mousePressed() {
  if (mouseY >= height - 220) {
    int index = int(mouseX / (width / 8.0));
    triggerNote(index);
  }
}

void mouseReleased() {
  for (int i = 0; i < 8; i++) {
    releaseNote(i);
  }
}

// --- 波紋特效類別 (視覺組員可大幅發揮的地方) ---
class Ripple {
  float x, y, radius, alpha;
  color c;
  
  Ripple(float x, float y, color c) {
    this.x = x;
    this.y = y;
    this.radius = 10;
    this.alpha = 255;
    this.c = c;
  }
  
  void update() {
    radius += 3.5;
    alpha -= 5;
  }
  
  void display() {
    noFill();
    stroke(c, alpha);
    strokeWeight(3);
    ellipse(x, y, radius * 2, radius * 2);
  }
  
  boolean isFinished() {
    return alpha <= 0;
  }
}
