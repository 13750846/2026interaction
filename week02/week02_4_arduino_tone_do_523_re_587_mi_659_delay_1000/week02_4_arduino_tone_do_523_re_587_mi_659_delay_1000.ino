// week02_4_arduino_tone_do_523_re_587_mi_659_delay_1000
void setup() {
  // put your setup code here, to run once:
  pinMode(8,OUTPUT);

  tone(8,523,100); // Do 0.1 秒
  delay(1000);
  tone(8,587,1000);// Re 0.1 秒
  delay(1000);
  tone(8,659,1000);// Mi 0.1 秒
  delay(1000);
}

void loop() {
  // put your main code here, to run repeatedly:
  // 下面會一直迴圈重複做、不會停
}
