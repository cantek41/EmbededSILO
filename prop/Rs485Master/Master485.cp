#line 1 "D:/Devreler/Rs485Master/Master485.c"
char dat[10];
char i,j;

sbit rs485_rxtx_pin at RC2_bit;
sbit rs485_rxtx_pin_direction at TRISC2_bit;
long cnt = 0;
char* text;


void interrupt() {
 RS485Master_Receive(dat);
}

void main() {


 PORTB = 0;
 PORTD = 0;
 TRISB = 0;
 TRISD = 0;


 UART1_Init(9600);
 Delay_ms(100);

 RS485Master_Init();
 dat[0] = 0x01;
 dat[1] = 0xF0;
 dat[2] = 0x0F;
 dat[4] = 0;
 dat[5] = 0;
 dat[6] = 0;

 RS485Master_Send(dat,1,160);


 RCIE_bit = 1;
 TXIE_bit = 0;
 PEIE_bit = 1;
 GIE_bit = 1;

 while (1){


 cnt++;
 if (dat[5]) {
 PORTD = 0xAA;
 }
 if (dat[4]) {
 cnt = 0;
 dat[4] = 0;
 j = dat[3];
 for (i = 1; i <= dat[3]; i++) {
 PORTB = dat[i-1];


 }
 UART1_Write(10);
 UART1_Write(13);
 dat[0] = dat[0]+1;
 Delay_ms(1);
 RS485Master_Send(dat,1,160);

 }
 if (cnt > 100000) {
 PORTD ++;
 cnt = 0;
 RS485Master_Send(dat,1,160);
 if (PORTD > 10)
 RS485Master_Send(dat,1,50);
 }
 }


}
