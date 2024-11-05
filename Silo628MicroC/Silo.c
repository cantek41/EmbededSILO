/*********main.c*********
Silo project PROP U1 code
Aim of this code is
take tempurature from each sensor by indexa and Id
and compare old value, if there is a diff it sent data
to RTU by RS485
*******************/
//#include <18F452.h>
//#config OSC = INTIO67, WDT = OFF, LVP = OFF, BOREN = OFF, PWRT = OFF, FOSC = XT
#include "DS18B20.h"


/* Symbolic Constants*/


/* Type Definations*/


/* Function Prototypes*/
void init();
void readTemp();
void SentUART();
void AddLine();

void Display_Temperature();

/* Global Variables*/
int temp;
char *text = "000.0000";
const unsigned short TEMP_RESOLUTION = 12;
unsigned char* _ROM_NO;

/* Variable RS485*/
char dat[9];             // buffer for receving/sending messages
char i,j;
sbit rs485_rxtx_pin at RC2_bit;             // set transcieve pin
sbit rs485_rxtx_pin_direction at TRISC2_bit;   // set transcieve pin direction

void interrupt() {
 RS485Slave_Receive(dat);
// PORTD = 0x0F;
}

void init(){
  PORTD = 0xFF;
  TRISD = 0;
  TRISA.B0=0;
  
  UART1_Init(9600);               // Initialize UART module at 9600 bps
  Delay_ms(100);
  RS485Slave_Init(160);              // Intialize MCU as slave, address 160

  dat[4] = 0;                        // ensure that message received flag is 0
  dat[5] = 0;                        // ensure that message received flag is 0
  dat[6] = 0;                        // ensure that error flag is 0

  RCIE_bit = 1;                      // enable interrupt on UART1 receive
  TXIE_bit = 0;                      // disable interrupt on UART1 transmit
  PEIE_bit = 1;                      // enable peripheral interrupts
  GIE_bit = 1;                       // enable all interrupts
  
//  RCIE = 1;                      // enable interrupt on UART1 receive
//  TXIE = 0;                      // disable interrupt on UART1 transmit
//  PEIE = 1;                      // enable peripheral interrupts
//  GIE = 1;
}

/* Main*/
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

    text = public_Read(1);// public_Read_Temp();
    UART1_Write_Text(text);
    AddLine();

    UART1_Write_text(dat[4]);
    if (dat[5])  {                     // if an error detected, signal it
      PORTD = 0xAA;                  //   setting portd to 0xAA
      dat[5] = 0;
    }
    if (dat[4]!=0) {                    // upon completed valid message receive
      UART1_Write_text("okudu");
      dat[4] = 0;                    //   data[4] is set to 0xFF
      j = dat[3];
      for (i = 1; i <= dat[3];i++){
        PORTD = dat[i-1];
       // UART1_Write_text("ds");
      }
      dat[0] = dat[0]+1;
//      dat[0] = text[0];
//      dat[1] = text[1];
//      dat[2] = text[2];
      Delay_ms(1);
      UART1_Write_text("RS485Slave_Send");
      RS485Slave_Send(dat,1);        //   and send it back to master
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