// week02_2_arduino_void_setup_void_loop_digitalWrite
void setup() {
  // put your setup code here, to run once:
  pinMode(8,OUTPUT); // 第8個腳，要發出Buzzer聲音
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(8, HIGH);
  delay(1000);
  digitalWrite(8,LOW);
  delay(1000);
}
