// week11_1_arduino_joystick_analogRead_A0_A1
// 要把 joystick 的 A0,A1接起來、讀資料
void setup() {
  // put your setup code here, to run once:

}

void loop() {
  int x = analogRead(A0);//讀入x座標
  int y = analogRead(A1);//讀入y座標
  tone(8, x); //會把x的值，直接很吵的輸出
  //如果太吵、想暫時停止，把makeUno的跳針，往左推
}
