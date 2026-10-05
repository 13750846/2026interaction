// week02_5_arduino_do_re_mi_Serial_begin_avaiable_read_if_tone
// google: 我想要把 Arduino 跟 Processing 結合
// 在 Processing 按下 key 1 2 3 對應 arduino 的 Do Re Mi 使用 USB Serial
// 寫完程式，用工具 Tool-序列阜監控視窗SerialMonitor 來傳送 1 2 3 測試很麻煩(等一下關掉)
// 因為只有一條 USB Serial 線，要記得關掉 Serial Montor
void setup() {
  Serial.begin(9600); // USB Serial 開始傳輸，速度9600 bps
}

void loop() {
  if(Serial.available()){
    char c = Serial.read();
    if (c=='1') tone(8,523,1000); //Do 1秒
    if (c=='2') tone(8,587,1000); //Re 1秒
    if (c=='3') tone(8,659,1000); //Mi 1秒
 }
}
