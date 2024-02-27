# 세탁기 프로젝트
* atmega128을 이용하여 세탁기를 구현
## 구현 목표 및 내용
- dc모터와 pwm을 이용하여 세탁 
- 초음파 센서를 이용하여 여닫이 문이 닫혔을 시에만 전원 버튼 동작
- 스위치를 이용하여 전원, 세탁 모드, 탈수 횟수 버튼, 일시정지/재시작 버튼 구현
- 세탁 종료시 부저를 활용하여 세탁 종료 음악 구현
### 어려웠던 점
- **일시정지 부분**
  - 일시정지 버튼을 누르면 시간이 흐르고 다시 누르면 시간이 정지, 그리고 세탁기 함수들 안에 while(pause!=1){OCR0=0} 을 넣어줘서 일시정지 상태일 때 모터 속도를 0으로 만들어주고 다시 버튼이 눌릴 때까지 무한루프 하도록 만들었습니다.
- **초음파 센서 함수와 bgm함수 그리고 타임오버플로우 인터럽트에서 같은 타이머를 쓰니 모터가 동작이 안되는 문제**
  - getEcho()와 bgm()은 타이머 1을 쓰고 오버플로우 인터럽트는 타이머 3, 즉 타이머를 따로 쓰니 해결되었습니다.
