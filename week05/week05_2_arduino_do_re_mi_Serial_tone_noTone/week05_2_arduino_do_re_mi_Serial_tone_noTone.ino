// week05_2_arduino_do_re_mi_Serial_tone_noTone
// 修改week05_1_arduino_do_re_mi_Serial
// google: 我想要把 Arduino 跟 Processing 結合
// 在 Processing 按下 key 1 2 3 對應 arduino 的 Do Re Mi 使用 USB Serial
// 寫完程式，用工具 Tool-序列阜監控視窗SerialMonitor 來傳送 1 2 3 測試很麻煩(等一下關掉)
// 因為只有一條 USB Serial 線，要記得關掉 Serial Montor
void setup() {
  Serial.begin(9600); // USB Serial 開始傳輸，速度9600 bps
  tone(8,523,100);delay(200); //Do
  tone(8,587,100);delay(200); //Re
  tone(8,659,100);delay(200); //Mi
  tone(8,587,100);delay(200); //Re
  tone(8,523,100);delay(200); //Do
}
char c = '0';
void loop() {
  if(Serial.available()){ //如果 USB Serial有收到資料
    c = Serial.read(); //就讀進來(不要再宣告char c,直接寫c)
    if (c=='0') noTone(8); //不要發出聲音
    if (c=='1') tone(8, 523, 100); //Do 0.1秒
    if (c=='2') tone(8, 587, 100); //Re 0.1秒
    if (c=='3') tone(8, 659, 100); //Mi 0.1秒
    }
}
