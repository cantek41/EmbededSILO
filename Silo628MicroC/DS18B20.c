/*********DS18B20.c*********
Search All sensors and save to list
Read tempurature from sensor
*******************/

/* Inculude */
#include "DS18B20.h"

/* Symbolic Constants*/
#define PORT PORTB
#define PIN 4
#define TRISBIT TRISB.B4
#define PORTBIT PORTB.B4

/* Variables*/

char g_cSlaveROM[5][8];
unsigned g_iPreTemp[20];

unsigned short sRES_SHIFT = 12-8;    //sTEMP_RESOLUTION = 12;
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

/* Functions Prototypes*/
int search();
unsigned short Ow_Read_Bit();
void Ow_Write_One();
void Ow_Write_Zero();
void TEMPtoTEXT();
int get_IndexFrom_Sensor(char* ROM_NO);




/* Public Functions*/
char* public_get_ROM(unsigned short sIndex)
{
  return g_cSlaveROM[sIndex];
}
void public_Search(){
  LastDiscrepancy = 0;
  LastDeviceFlag = 0;
  LastFamilyDiscrepancy = 0;
  Ow_Reset(&PORT, PIN);
  Ow_Write(&PORT, PIN, 0xF0); // Issue command Search_ROM


  //DevicesFound = 0; // Reset device counter
  jj = 0;

  while (1)
  {
    if (search()== 0)
        break;
    UART1_Write_Text("search");
    //index = get_IndexFrom_Sensor(ROM_NO);
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
  Ow_Reset(&PORT, PIN);                         // Onewire reset signal
  Ow_Write(&PORT, PIN, 0x55);                   // Issue command Match_ROM

  // send DS18B20 sensor 2 ROM
  for (index=0;index<8;index++)
  {
    Ow_Write(&PORT, PIN, g_cSlaveROM[sIndex][index]);
  }
  Delay_ms(10);

  Ow_Write(&PORT, PIN, 0x44);                   // Issue command CONVERT_T
  Delay_ms(760);        // 760ms
  
  
  Ow_Reset(&PORT, PIN);
  Ow_Write(&PORT, PIN, 0x55);                   // Issue command Match_ROM
  // send DS18B20 sensor 2 ROM
  for (index=0;index<8;index++)
  {
    Ow_Write(&PORT, PIN, g_cSlaveROM[sIndex][index]);
  }
  Delay_ms(10);
  Ow_Write(&PORT, PIN, 0xBE);

  iTemp =  Ow_Read(&PORT, PIN);                  // LSB (the LSB is first transferred
  iTemp = (Ow_Read(&PORT, PIN) << 8) + iTemp;
  TEMPtoTEXT();
  return ctext;
}

char* public_Read_Temp(){
    Ow_Reset(&PORT, PIN);                         // Onewire reset signal
    Ow_Write(&PORT, PIN, 0xCC);                   // Issue command SKIP_ROM
    Ow_Write(&PORT, PIN, 0x44);                   // Issue command CONVERT_T
    Delay_us(120);

    Ow_Reset(&PORT, PIN);
    Ow_Write(&PORT, PIN, 0xCC);                   // Issue command SKIP_ROM
    Ow_Write(&PORT, PIN, 0xBE);                   // Issue command READ_SCRATCHPAD

    iTemp =  Ow_Read(&PORT, PIN);
    iTemp = (Ow_Read(&PORT, PIN) << 8) + iTemp;

    Delay_us(120);
    TEMPtoTEXT();
    return ctext;
}

/* Private Functions*/

void TEMPtoTEXT() {
  // Check if temperature is negative
  if (iTemp & 0x8000) {
     ctext[0] = '-';
     iTemp = ~iTemp + 1;
     }

  // Extract temp_whole
  temp_whole = iTemp >> sRES_SHIFT ;

  // Convert temp_whole to characters
  if (temp_whole/100)
     ctext[0] = temp_whole/100  + 48;
  else
     ctext[0] = '0';

  ctext[1] = (temp_whole/10)%10 + 48;             // Extract tens digit
  ctext[2] =  temp_whole%10     + 48;             // Extract ones digit

  // Extract temp_fraction and convert it to unsigned int
  temp_fraction  = iTemp << (4-sRES_SHIFT);
  temp_fraction &= 0x000F;
  temp_fraction *= 625;

  // Convert temp_fraction to characters
  ctext[4] =  temp_fraction/1000    + 48;         // Extract thousands digit
  ctext[5] = (temp_fraction/100)%10 + 48;         // Extract hundreds digit
  ctext[6] = (temp_fraction/10)%10  + 48;         // Extract tens digit
  ctext[7] =  temp_fraction%10      + 48;         // Extract ones digit

}


unsigned char docrc8(unsigned char value)
{
  crc8 = dscrc_table[crc8 ^ value];    // Xor operation
  return crc8;
}

int search()
{
   // initialize for search
   id_bit_number = 1;
   last_zero = 0;
   rom_byte_number = 0;
   rom_byte_mask = 1;
   search_result = 0;
   crc8 = 0;

   // if the last call was not the last one
   if (!LastDeviceFlag)
   {
      // check if there are 1-Wire device (s) 0 if the device(s) responded, 1 if no devices did
      if (Ow_Reset(&PORT, PIN))
      {
         // reset the search
         LastDiscrepancy = 0;
         LastDeviceFlag = 0;
         LastFamilyDiscrepancy = 0;
         return 0;
      }
      // Issue command Search_ROM
      Ow_Write(&PORT, PIN, 0xF0);

      // loop to do the search
      do
      {
         // read a bit and its complement
         id_bit = OW_Read_Bit();
         cmp_id_bit = OW_Read_Bit();

         // 11 no devices on the 1-wire

         // check for no devices on 1-wire
         if ((id_bit == 1) && (cmp_id_bit == 1))
            break;
         else
         {
            // all devices coupled have 0 or 1
            if (id_bit != cmp_id_bit)
               search_direction = id_bit; // bit write value for search
            else
            {
               // if this discrepancy is before the Last Discrepancy
               // on a previous next then pick the same as last time

               if (id_bit_number < LastDiscrepancy)
                  search_direction = ((ROM_NO[rom_byte_number] & rom_byte_mask) > 0);
               else
                  // if equal to last pick 1, if not then pick 0
                  search_direction = (id_bit_number == LastDiscrepancy);

               // if 0 was picked then record its position in LastZero
               if (search_direction == 0)
               {
                  last_zero = id_bit_number;
                  // check for Last discrepancy in family
                  if (last_zero < 9)
                     LastFamilyDiscrepancy = last_zero;
               }
            }

            // set or clear the bit in the ROM byte rom_byte_number
            // with mask rom_byte_mask

            if (search_direction == 1)
               ROM_NO[rom_byte_number] |= rom_byte_mask;
            else
               ROM_NO[rom_byte_number] &= ~rom_byte_mask;

            // serial number search direction write bit
            if (search_direction)
               Ow_Write_One();
            else
               Ow_Write_Zero();
            // increment the byte counter id_bit_number
            // and shift the mask rom_byte_mask

            id_bit_number++;
            rom_byte_mask <<= 1;

            // if the mask is 0 then go to new SerialNum byte rom_byte_number
            // and reset mask
//
            if (rom_byte_mask == 0)
            {
//               crc8 = dscrc_table[crc8 ^ ROM_NO[rom_byte_number]];
               docrc8(ROM_NO[rom_byte_number]); // accumulate the CRC
               rom_byte_number++;
               rom_byte_mask = 1;
            }
         }
      } // End of search loop
      while (rom_byte_number < 8); // loop until through all ROM bytes 0-7

      // if the search was successful then
      if (!((id_bit_number < 65) || (crc8 != 0)))
      {
         // search successful so set LastDiscrepancy,LastDeviceFlag,search_result
         LastDiscrepancy = last_zero;

         // check for last device
         if (LastDiscrepancy == 0)
            LastDeviceFlag = 1;
         search_result = 1;
      }
   }

   // if no device found then reset counters so next 'search' will be
   // like a first

   if (!search_result || !ROM_NO[0])
   {
      LastDiscrepancy = 0;
      LastDeviceFlag = 0;
      LastFamilyDiscrepancy = 0;
      search_result = 0;
   }
   return search_result;
}

// Get Index from sensor eeprom
int get_IndexFrom_Sensor(char* ROM_NO){

  Ow_Reset(&PORT, PIN);
  Ow_Write(&PORT, PIN, 0x55);                   // Issue command Match_ROM

  for (index=0;index<8;index++)
  {
    Ow_Write(&PORT, PIN, ROM_NO[index]);
  }
  Delay_ms(10);
  Ow_Write(&PORT, PIN, 0xBE);

  Ow_Read(&PORT, PIN);   // LSB (the LSB is first transferred
  Ow_Read(&PORT, PIN) ; // MSB
  index = Ow_Read(&PORT, PIN) ; // TH
//  ByteToHex(index,ctext);
//  UART1_Write_Text(index);
//  UART1_Write_Text(ctext);
  return index;

}
// End of Ow-Search function
unsigned short Ow_Read_Bit()
{
   unsigned short BitValue;    // Bit to be returned
   TRISBIT = 0;                 // Set pin 2 in PORT E as output
   PORTBIT = 0;               // Drive bus low   LATE.B2;   for PIC18
   delay_us(6);                // Wait 6 usecs
   TRISBIT = 1;                 // Release the bus
   delay_us(9);                // Wait 9 usecs
   BitValue = PORTBIT;         // Read bit value on pin 2 on PORT E
   delay_us(55);               // Wait 55 usecs
   return BitValue;            // Return bit read
}

void Ow_Write_One()
{
   TRISBIT = 0;      // Set pin 2 in PORT E as output
   PORTBIT = 0;    // Drive bus low
   delay_us(6);     // Wait 6 usecs        (6*4)*0.25 us
   TRISBIT = 1;      // Release the bus
   delay_us(64);    // Wait 64 usecs        (64*4)*0.25 us
}

void Ow_Write_Zero()
{
   TRISBIT = 0;     // Set pin 2 in PORT E as output
   PORTBIT = 0;   // Drive bus low
   delay_us(60);   // Wait 60 usecs
   TRISBIT = 1;     // Release the bus
   delay_us(10);   // Wait 10 usecs
}