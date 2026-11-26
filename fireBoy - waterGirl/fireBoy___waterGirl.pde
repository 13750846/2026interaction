// ==========================================
// 冰火雙人合作跑酷 - 第二階段完整修正版（雙門皆支援雙向接力）
// ==========================================

Player fireBoy;
Player waterGirl;

ArrayList<Platform> platforms;
ArrayList<HazardPool> pools;
ArrayList<Gate> gates;
ArrayList<PressureButton> buttons;
GoalDoor fireDoor;
GoalDoor waterDoor;

boolean[] keys = new boolean[256];
boolean[] codedKeys = new boolean[256];

String gameState = "PLAYING";
String failReason = "";

void setup() {
  size(960, 600);
  smooth();
  
  PFont font = createFont("Microsoft JhengHei", 16);
  textFont(font);
  
  initLevel();
}

void initLevel() {
  gameState = "PLAYING";
  failReason = "";
  
  fireBoy = new Player(70, 480, 32, 42, color(255, 85, 65), true);
  waterGirl = new Player(125, 480, 32, 42, color(65, 185, 255), false);
  
  platforms = new ArrayList<Platform>();
  pools = new ArrayList<HazardPool>();
  gates = new ArrayList<Gate>();
  buttons = new ArrayList<PressureButton>();
  
  // 1. 四周外牆
  platforms.add(new Platform(0, height - 30, width, 30));
  platforms.add(new Platform(0, 0, width, 20));
  platforms.add(new Platform(0, 0, 20, height));
  platforms.add(new Platform(width - 20, 0, 20, height));
  
  // 2. 底部屬性水池
  pools.add(new HazardPool(230, height - 42, 80, 12, "FIRE"));
  pools.add(new HazardPool(440, height - 42, 80, 12, "WATER"));
  
  // 右下階梯
  platforms.add(new Platform(650, 490, 290, 25));
  platforms.add(new Platform(520, 420, 100, 20));
  
  // 第二層平台（中左）
  platforms.add(new Platform(20, 360, 460, 25));
  pools.add(new HazardPool(210, 348, 75, 12, "POISON"));
  
  // 第三層平台（中右）
  platforms.add(new Platform(420, 250, 520, 25));
  platforms.add(new Platform(220, 290, 140, 20));
  
  // 紫色門 A（雙按鈕接力：左右各一顆）
  Gate gateA = new Gate(505, 165, 22, 85, color(190, 110, 255));
  gates.add(gateA);
  buttons.add(new PressureButton(80, 348, 44, 12, color(190, 110, 255), gateA));  // 左側紫色按鈕
  buttons.add(new PressureButton(620, 238, 44, 12, color(190, 110, 255), gateA)); // 右側紫色按鈕（新增！）
  
  // 黃色門 B（雙按鈕接力：內外各一顆）
  Gate gateB = new Gate(340, 20, 22, 120, color(255, 195, 65));
  gates.add(gateB);
  buttons.add(new PressureButton(840, 238, 44, 12, color(255, 195, 65), gateB)); // 右下黃色按鈕
  buttons.add(new PressureButton(250, 128, 44, 12, color(255, 195, 65), gateB)); // 終點旁黃色按鈕
  
  // 頂層終點平台（左上）
  platforms.add(new Platform(20, 140, 460, 25));
  platforms.add(new Platform(540, 180, 120, 20));
  
  // 雙人終點門
  fireDoor = new GoalDoor(60, 72, 46, 68, color(255, 85, 65), true);
  waterDoor = new GoalDoor(130, 72, 46, 68, color(65, 185, 255), false);
}

void draw() {
  background(28, 32, 42);
  drawBackgroundGrid();
  
  for (Platform p : platforms) p.display();
  
  fireDoor.display(fireBoy);
  waterDoor.display(waterGirl);
  
  for (Gate g : gates) g.isOpen = false;
  for (PressureButton b : buttons) {
    b.checkPress(fireBoy, waterGirl);
    b.display();
  }
  for (Gate g : gates) {
    g.update();
    g.display();
  }
  
  for (HazardPool pool : pools) pool.display();
  
  if (gameState.equals("PLAYING")) {
    fireBoy.update(platforms, gates);
    waterGirl.update(platforms, gates);
    checkHazards();
    if (fireDoor.isReached(fireBoy) && waterDoor.isReached(waterGirl)) {
      gameState = "WIN";
    }
  }
  
  fireBoy.display();
  waterGirl.display();
  drawHUD();
  
  if (!gameState.equals("PLAYING")) drawOverlay();
}

void checkHazards() {
  for (HazardPool pool : pools) {
    if (pool.collidesWith(fireBoy)) {
      if (pool.type.equals("WATER")) {
        gameState = "GAMEOVER";
        failReason = "火人掉進寒冰池熄滅了！";
      } else if (pool.type.equals("POISON")) {
        gameState = "GAMEOVER";
        failReason = "火人碰到了劇毒沼澤！";
      }
    }
    if (pool.collidesWith(waterGirl)) {
      if (pool.type.equals("FIRE")) {
        gameState = "GAMEOVER";
        failReason = "冰人掉進岩漿池蒸發了！";
      } else if (pool.type.equals("POISON")) {
        gameState = "GAMEOVER";
        failReason = "冰人碰到了劇毒沼澤！";
      }
    }
  }
}

class Player {
  float x, y, w, h;
  float vx, vy;
  float speed = 4.5;
  float jumpForce = -11.5;
  float gravity = 0.55;
  boolean isGrounded = false;
  boolean isFire;
  color col;
  
  Player(float x, float y, float w, float h, color col, boolean isFire) {
    this.x = x; this.y = y; this.w = w; this.h = h;
    this.col = col; this.isFire = isFire;
  }
  
  void update(ArrayList<Platform> plats, ArrayList<Gate> gateList) {
    boolean left  = isFire ? keys['A'] || keys['a'] : codedKeys[LEFT];
    boolean right = isFire ? keys['D'] || keys['d'] : codedKeys[RIGHT];
    boolean jump  = isFire ? keys['W'] || keys['w'] : codedKeys[UP];
    
    vx = 0;
    if (left)  vx = -speed;
    if (right) vx = speed;
    
    if (jump && isGrounded) {
      vy = jumpForce;
      isGrounded = false;
    }
    
    vy += gravity;
    if (vy > 14) vy = 14;
    
    x += vx;
    for (Platform p : plats) {
      if (rectOverlap(x, y, w, h, p.x, p.y, p.w, p.h)) {
        if (vx > 0) x = p.x - w;
        else if (vx < 0) x = p.x + p.w;
      }
    }
    for (Gate g : gateList) {
      if (g.currentH > 5 && rectOverlap(x, y, w, h, g.x, g.y, g.w, g.currentH)) {
        if (vx > 0) x = g.x - w;
        else if (vx < 0) x = g.x + g.w;
      }
    }
    
    y += vy;
    isGrounded = false;
    for (Platform p : plats) {
      if (rectOverlap(x, y, w, h, p.x, p.y, p.w, p.h)) {
        if (vy > 0) {
          y = p.y - h;
          vy = 0;
          isGrounded = true;
        } else if (vy < 0) {
          y = p.y + p.h;
          vy = 0;
        }
      }
    }
    for (Gate g : gateList) {
      if (g.currentH > 5 && rectOverlap(x, y, w, h, g.x, g.y, g.w, g.currentH)) {
        if (vy > 0) {
          y = g.y - h;
          vy = 0;
          isGrounded = true;
        } else if (vy < 0) {
          y = g.y + g.currentH;
          vy = 0;
        }
      }
    }
  }
  
  void display() {
    pushStyle();
    noStroke();
    fill(col, 60);
    rect(x - 4, y - 4, w + 8, h + 8, 10);
    
    fill(col);
    rect(x, y, w, h, 8);
    
    float eyeOffset = (vx > 0) ? 3 : (vx < 0 ? -3 : 0);
    fill(255);
    ellipse(x + w * 0.32 + eyeOffset, y + h * 0.38, 8, 10);
    ellipse(x + w * 0.68 + eyeOffset, y + h * 0.38, 8, 10);
    
    fill(20);
    ellipse(x + w * 0.32 + eyeOffset * 1.3, y + h * 0.38, 4, 5);
    ellipse(x + w * 0.68 + eyeOffset * 1.3, y + h * 0.38, 4, 5);
    popStyle();
  }
}

class Platform {
  float x, y, w, h;
  Platform(float x, float y, float w, float h) {
    this.x = x; this.y = y; this.w = w; this.h = h;
  }
  void display() {
    pushStyle();
    fill(68, 76, 92);
    stroke(95, 105, 125);
    strokeWeight(1.5);
    rect(x, y, w, h, 4);
    noStroke();
    fill(115, 130, 155);
    rect(x + 2, y, w - 4, 4, 2);
    popStyle();
  }
}

class HazardPool {
  float x, y, w, h;
  String type;
  color col;
  
  HazardPool(float x, float y, float w, float h, String type) {
    this.x = x; this.y = y; this.w = w; this.h = h;
    this.type = type;
    if (type.equals("FIRE")) col = color(255, 75, 45);
    else if (type.equals("WATER")) col = color(50, 175, 255);
    else col = color(75, 225, 95);
  }
  
  boolean collidesWith(Player p) {
    return rectOverlap(p.x + 4, p.y + 4, p.w - 8, p.h - 4, x, y, w, h);
  }
  
  void display() {
    pushStyle();
    noStroke();
    fill(col, 80);
    rect(x - 2, y - 4, w + 4, h + 4, 4);
    
    fill(col);
    rect(x, y, w, h, 3);
    
    fill(255, 160);
    float wave = sin(frameCount * 0.1 + x) * 3;
    rect(x + 6 + wave, y + 2, w - 12, 3, 2);
    popStyle();
  }
}

class PressureButton {
  float x, y, w, h;
  color col;
  Gate targetGate;
  boolean pressed = false;
  
  PressureButton(float x, float y, float w, float h, color col, Gate targetGate) {
    this.x = x; this.y = y; this.w = w; this.h = h;
    this.col = col;
    this.targetGate = targetGate;
  }
  
  void checkPress(Player p1, Player p2) {
    boolean p1On = rectOverlap(p1.x, p1.y, p1.w, p1.h + 2, x, y - 4, w, h + 4);
    boolean p2On = rectOverlap(p2.x, p2.y, p2.w, p2.h + 2, x, y - 4, w, h + 4);
    pressed = (p1On || p2On);
    if (pressed) {
      targetGate.isOpen = true;
    }
  }
  
  void display() {
    pushStyle();
    fill(50, 55, 65);
    noStroke();
    rect(x - 4, y + h - 4, w + 8, 4, 2);
    
    fill(col);
    float pressOffset = pressed ? 5 : 0;
    rect(x, y + pressOffset, w, h - pressOffset, 4);
    popStyle();
  }
}

class Gate {
  float x, y, w, maxH, currentH;
  color col;
  boolean isOpen = false;
  
  Gate(float x, float y, float w, float h, color col) {
    this.x = x; this.y = y; this.w = w;
    this.maxH = h;
    this.currentH = h;
    this.col = col;
  }
  
  void update() {
    float targetH = isOpen ? 0 : maxH;
    currentH = lerp(currentH, targetH, 0.15);
  }
  
  void display() {
    if (currentH <= 1) return;
    pushStyle();
    fill(col, 210);
    stroke(255, 150);
    strokeWeight(1.5);
    rect(x, y, w, currentH, 4);
    popStyle();
  }
}

class GoalDoor {
  float x, y, w, h;
  color col;
  boolean forFire;
  
  GoalDoor(float x, float y, float w, float h, color col, boolean forFire) {
    this.x = x; this.y = y; this.w = w; this.h = h;
    this.col = col;
    this.forFire = forFire;
  }
  
  boolean isReached(Player p) {
    if (p.isFire != forFire) return false;
    float px = p.x + p.w / 2;
    float py = p.y + p.h / 2;
    return (px > x && px < x + w && py > y && py < y + h);
  }
  
  void display(Player targetPlayer) {
    pushStyle();
    boolean active = isReached(targetPlayer);
    
    noStroke();
    fill(col, active ? 130 : 45);
    rect(x - 6, y - 6, w + 12, h + 6, 24, 24, 0, 0);
    
    fill(35, 40, 52);
    stroke(col);
    strokeWeight(active ? 4 : 2);
    rect(x, y, w, h, 20, 20, 0, 0);
    
    noStroke();
    fill(col, active ? 200 : 70);
    rect(x + 8, y + 10, w - 16, h - 10, 14, 14, 0, 0);
    popStyle();
  }
}

boolean rectOverlap(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  return (x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode < 256) codedKeys[keyCode] = true;
  } else {
    if (key < 256) keys[key] = true;
  }
  
  if (key == 'r' || key == 'R') {
    initLevel();
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode < 256) codedKeys[keyCode] = false;
  } else {
    if (key < 256) keys[key] = false;
  }
}

void drawBackgroundGrid() {
  stroke(255, 10);
  strokeWeight(1);
  for (int x = 0; x < width; x += 40) line(x, 0, x, height);
  for (int y = 0; y < height; y += 40) line(0, y, width, y);
}

void drawHUD() {
  fill(255, 210);
  textSize(14);
  textAlign(LEFT, TOP);
  text("火人 (紅)：W A D 移動跳躍   |   冰人 (藍)：↑ ← → 移動跳躍   |   按 R 重新開始", 32, 26);
}

void drawOverlay() {
  pushStyle();
  fill(15, 18, 25, 200);
  rect(0, 0, width, height);
  
  textAlign(CENTER, CENTER);
  if (gameState.equals("WIN")) {
    fill(100, 255, 160);
    textSize(46);
    text("神廟試煉通過！", width / 2, height / 2 - 40);
    
    fill(255);
    textSize(20);
    text("冰與火完美合作，成功開啟雙生之門！", width / 2, height / 2 + 15);
  } else {
    fill(255, 95, 95);
    textSize(46);
    text("挑戰失敗", width / 2, height / 2 - 40);
    
    fill(255);
    textSize(20);
    text(failReason, width / 2, height / 2 + 15);
  }
  
  fill(200, 210, 230);
  textSize(16);
  text("按下 [ R ] 鍵立即重新挑戰", width / 2, height / 2 + 65);
  popStyle();
}
