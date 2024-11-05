#line 1 "D:/Devreler/Silo/Silo628MicroC/DS18B20.c"
#line 1 "d:/devreler/silo/silo628microc/ds18b20.h"





extern char g_cSlaveROM[2][8];

void public_Search();

char* public_Read(unsigned short sIndex);

char* public_get_ROM(unsigned short sIndex);

char* public_Read_Temp();
#line 17 "D:/Devreler/Silo/Silo628MicroC/DS18B20.c"
char g_cSlaveROM[5][8];
unsigned g_iPreTemp[20];

unsigned short sRES_SHIFT = 12-8;
char *ctext = "000.0000";
unsigned iTemp;
unsigned short index;
unsigned char ROM_NO[8];
int LastDiscrepancy;
int LastFamilyDiscrepancy;
int LastDeviceFlag;
unsigned char crc8;


char temp_whole;
unsigned int temp_fraction;

int id_bit_number;
int last_zero, rom_byte_number, search_result;
int id_bit, cmp_id_bit;
unsigned char rom_byte_mask, search_direction;
int jj;


const unsigned char dscrc_table[] = {
0, 94,188,226, 97, 63,221,131,194,156,126, 32,163,253, 31, 65,
157,195, 33,127,252,162, 64, 30, 95, 1,227,189, 62, 96,130,220,
35,125,159,193, 66, 28,254,160,225,191, 93, 3,128,222, 60, 98,
190,224, 2, 92,223,129, 99, 61,124, 34,192,158, 29, 67,161,255,
70, 24,250,164, 39,121,155,197,132,218, 56,102,229,187, 89, 7,
219,133,103, 57,186,228, 6, 88, 25, 71,165,251,120, 38,196,154,
101, 59,217,135, 4, 90,184,230,167,249, 27, 69,198,152,122, 36,
248,166, 68, 26,153,199, 37,123, 58,100,134,216, 91, 5,231,185,
140,210, 48,110,237,179, 81, 15, 78, 16,242,172, 47,113,147,205,
17, 79,173,243,112, 46,204,146,211,141,111, 49,178,236, 14, 80,
175,241, 19, 77,206,144,114, 44,109, 51,209,143, 12, 82,176,238,
50,108,142,208, 83, 13,239,177,240,174, 76, 18,145,207, 45,115,
202,148,118, 40,171,245, 23, 73, 8, 86,180,234,105, 55,213,139,
87, 9,235,181, 54,104,138,212,149,203, 41,119,244,170, 72, 22,
233,183, 85, 11,136,214, 52,106, 43,117,151,201, 74, 20,246,168,
116, 42,200,150, 21, 75,169,247,182,232, 10, 84,215,137,107, 53};


int search();
unsigned short Ow_Read_Bit();
void Ow_Write_One();
void Ow_Write_Zero();
void TEMPtoTEXT();
int get_IndexFrom_Sensor(char* ROM_NO);





char* public_get_ROM(unsigned short sIndex)
{
 return g_cSlaveROM[sIndex];
}
void public_Search(){
 LastDiscrepancy = 0;
 LastDeviceFlag = 0;
 LastFamilyDiscrepancy = 0;
 Ow_Reset(& PORTB ,  4 );
 Ow_Write(& PORTB ,  4 , 0xF0);



 jj = 0;

 while (1)
 {
 if (search()== 0)
 break;
 UART1_Write_Text("search");

 UART1_Write_Text(iTemp);
 UART1_Write(10);
 UART1_Write(13);
 for(iTemp=0; iTemp<8; iTemp++)
 {
 g_cSlaveROM[jj][iTemp]=ROM_NO[iTemp];
 ByteToHex(ROM_NO[iTemp],ctext);
 UART1_Write_Text(ctext);
 }
 jj++;
 }
}

char* public_Read(unsigned short sIndex){
 Ow_Reset(& PORTB ,  4 );
 Ow_Write(& PORTB ,  4 , 0x55);


 for (index=0;index<8;index++)
 {
 Ow_Write(& PORTB ,  4 , g_cSlaveROM[sIndex][index]);
 }
 Delay_ms(10);

 Ow_Write(& PORTB ,  4 , 0x44);
 Delay_ms(760);


 Ow_Reset(& PORTB ,  4 );
 Ow_Write(& PORTB ,  4 , 0x55);

 for (index=0;index<8;index++)
 {
 Ow_Write(& PORTB ,  4 , g_cSlaveROM[sIndex][index]);
 }
 Delay_ms(10);
 Ow_Write(& PORTB ,  4 , 0xBE);

 iTemp = Ow_Read(& PORTB ,  4 );
 iTemp = (Ow_Read(& PORTB ,  4 ) << 8) + iTemp;
 TEMPtoTEXT();
 return ctext;
}

char* public_Read_Temp(){
 Ow_Reset(& PORTB ,  4 );
 Ow_Write(& PORTB ,  4 , 0xCC);
 Ow_Write(& PORTB ,  4 , 0x44);
 Delay_us(120);

 Ow_Reset(& PORTB ,  4 );
 Ow_Write(& PORTB ,  4 , 0xCC);
 Ow_Write(& PORTB ,  4 , 0xBE);

 iTemp = Ow_Read(& PORTB ,  4 );
 iTemp = (Ow_Read(& PORTB ,  4 ) << 8) + iTemp;

 Delay_us(120);
 TEMPtoTEXT();
 return ctext;
}



void TEMPtoTEXT() {

 if (iTemp & 0x8000) {
 ctext[0] = '-';
 iTemp = ~iTemp + 1;
 }


 temp_whole = iTemp >> sRES_SHIFT ;


 if (temp_whole/100)
 ctext[0] = temp_whole/100 + 48;
 else
 ctext[0] = '0';

 ctext[1] = (temp_whole/10)%10 + 48;
 ctext[2] = temp_whole%10 + 48;


 temp_fraction = iTemp << (4-sRES_SHIFT);
 temp_fraction &= 0x000F;
 temp_fraction *= 625;


 ctext[4] = temp_fraction/1000 + 48;
 ctext[5] = (temp_fraction/100)%10 + 48;
 ctext[6] = (temp_fraction/10)%10 + 48;
 ctext[7] = temp_fraction%10 + 48;

}


unsigned char docrc8(unsigned char value)
{
 crc8 = dscrc_table[crc8 ^ value];
 return crc8;
}

int search()
{

 id_bit_number = 1;
 last_zero = 0;
 rom_byte_number = 0;
 rom_byte_mask = 1;
 search_result = 0;
 crc8 = 0;


 if (!LastDeviceFlag)
 {

 if (Ow_Reset(& PORTB ,  4 ))
 {

 LastDiscrepancy = 0;
 LastDeviceFlag = 0;
 LastFamilyDiscrepancy = 0;
 return 0;
 }

 Ow_Write(& PORTB ,  4 , 0xF0);


 do
 {

 id_bit = OW_Read_Bit();
 cmp_id_bit = OW_Read_Bit();




 if ((id_bit == 1) && (cmp_id_bit == 1))
 break;
 else
 {

 if (id_bit != cmp_id_bit)
 search_direction = id_bit;
 else
 {



 if (id_bit_number < LastDiscrepancy)
 search_direction = ((ROM_NO[rom_byte_number] & rom_byte_mask) > 0);
 else

 search_direction = (id_bit_number == LastDiscrepancy);


 if (search_direction == 0)
 {
 last_zero = id_bit_number;

 if (last_zero < 9)
 LastFamilyDiscrepancy = last_zero;
 }
 }




 if (search_direction == 1)
 ROM_NO[rom_byte_number] |= rom_byte_mask;
 else
 ROM_NO[rom_byte_number] &= ~rom_byte_mask;


 if (search_direction)
 Ow_Write_One();
 else
 Ow_Write_Zero();



 id_bit_number++;
 rom_byte_mask <<= 1;




 if (rom_byte_mask == 0)
 {

 docrc8(ROM_NO[rom_byte_number]);
 rom_byte_number++;
 rom_byte_mask = 1;
 }
 }
 }
 while (rom_byte_number < 8);


 if (!((id_bit_number < 65) || (crc8 != 0)))
 {

 LastDiscrepancy = last_zero;


 if (LastDiscrepancy == 0)
 LastDeviceFlag = 1;
 search_result = 1;
 }
 }




 if (!search_result || !ROM_NO[0])
 {
 LastDiscrepancy = 0;
 LastDeviceFlag = 0;
 LastFamilyDiscrepancy = 0;
 search_result = 0;
 }
 return search_result;
}


int get_IndexFrom_Sensor(char* ROM_NO){

 Ow_Reset(& PORTB ,  4 );
 Ow_Write(& PORTB ,  4 , 0x55);

 for (index=0;index<8;index++)
 {
 Ow_Write(& PORTB ,  4 , ROM_NO[index]);
 }
 Delay_ms(10);
 Ow_Write(& PORTB ,  4 , 0xBE);

 Ow_Read(& PORTB ,  4 );
 Ow_Read(& PORTB ,  4 ) ;
 index = Ow_Read(& PORTB ,  4 ) ;



 return index;

}

unsigned short Ow_Read_Bit()
{
 unsigned short BitValue;
  TRISB.B4  = 0;
  PORTB.B4  = 0;
 delay_us(6);
  TRISB.B4  = 1;
 delay_us(9);
 BitValue =  PORTB.B4 ;
 delay_us(55);
 return BitValue;
}

void Ow_Write_One()
{
  TRISB.B4  = 0;
  PORTB.B4  = 0;
 delay_us(6);
  TRISB.B4  = 1;
 delay_us(64);
}

void Ow_Write_Zero()
{
  TRISB.B4  = 0;
  PORTB.B4  = 0;
 delay_us(60);
  TRISB.B4  = 1;
 delay_us(10);
}
