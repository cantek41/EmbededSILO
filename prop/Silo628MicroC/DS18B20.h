#ifndef DS18B20S_H
#define DS18B20S_H

/* Valuable */

extern char g_cSlaveROM[2][8];

void public_Search();

char* public_Read(unsigned short sIndex);

char* public_get_ROM(unsigned short sIndex);

char* public_Read_Temp();

#endif