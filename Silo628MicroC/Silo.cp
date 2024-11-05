#line 1 "D:/Devreler/Silo/Silo628MicroC/Silo.c"
#line 1 "d:/devreler/silo/silo628microc/ds18b20.h"





extern char g_cSlaveROM[2][8];

void public_Search();

char* public_Read(unsigned short sIndex);

char* public_get_ROM(unsigned short sIndex);

char* public_Read_Temp();
#line 20 "D:/Devreler/Silo/Silo628MicroC/Silo.c"
void init();
void readTemp();
void SentUART();
void AddLine();

void Display_Temperature();


int temp;
char *text = "000.0000";
const unsigned short TEMP_RESOLUTION = 12;
unsigned char* _ROM_NO;


char dat[9];
char i,j;
sbit rs485_rxtx_pin at RC2_bit;
sbit rs485_rxtx_pin_direction at TRISC2_bit;

void interrupt() {
 RS485Slave_Receive(dat);

}

void init(){
 PORTD = 0xFF;
 TRISD = 0;
 TRISA.B0=0;

 UART1_Init(9600);
 Delay_ms(100);
 RS485Slave_Init(160);

 dat[4] = 0;
 dat[5] = 0;
 dat[6] = 0;

 RCIE_bit = 1;
 TXIE_bit = 0;
 PEIE_bit = 1;
 GIE_bit = 1;





}


void main() {

 init();
 public_Search();

 while(1){
 PORTA.B0=1;
 Delay_ms(300);
 PORTA.B0=0;
 UART1_Write_Text("Line");
 AddLine();

 text = public_Read(0);
 UART1_Write_Text(text);
 AddLine();

 text = public_Read(1);
 UART1_Write_Text(text);
 AddLine();

 UART1_Write_text(dat[4]);
 if (dat[5]) {
 PORTD = 0xAA;
 dat[5] = 0;
 }
 if (dat[4]!=0) {
 UART1_Write_text("okudu");
 dat[4] = 0;
 j = dat[3];
 for (i = 1; i <= dat[3];i++){
 PORTD = dat[i-1];

 }
 dat[0] = dat[0]+1;



 Delay_ms(1);
 UART1_Write_text("RS485Slave_Send");
 RS485Slave_Send(dat,1);
 }
 Delay_ms(1000);

 }
}
void AddLine(){
 UART1_Write(10);
 UART1_Write(13);
 UART1_Write_Text("======");
 UART1_Write(10);
 UART1_Write(13);
}
