
_public_get_ROM:

;DS18B20.c,71 :: 		char* public_get_ROM(unsigned short sIndex)
;DS18B20.c,73 :: 		return g_cSlaveROM[sIndex];
	MOVLW       3
	MOVWF       R2 
	MOVF        FARG_public_get_ROM_sIndex+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__public_get_ROM59:
	BZ          L__public_get_ROM60
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__public_get_ROM59
L__public_get_ROM60:
	MOVLW       _g_cSlaveROM+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_g_cSlaveROM+0)
	ADDWFC      R1, 1 
;DS18B20.c,74 :: 		}
L_end_public_get_ROM:
	RETURN      0
; end of _public_get_ROM

_public_Search:

;DS18B20.c,75 :: 		void public_Search(){
;DS18B20.c,76 :: 		LastDiscrepancy = 0;
	CLRF        _LastDiscrepancy+0 
	CLRF        _LastDiscrepancy+1 
;DS18B20.c,77 :: 		LastDeviceFlag = 0;
	CLRF        _LastDeviceFlag+0 
	CLRF        _LastDeviceFlag+1 
;DS18B20.c,78 :: 		LastFamilyDiscrepancy = 0;
	CLRF        _LastFamilyDiscrepancy+0 
	CLRF        _LastFamilyDiscrepancy+1 
;DS18B20.c,79 :: 		Ow_Reset(&PORT, PIN);
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Reset_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Reset_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Reset_pin+0 
	CALL        _Ow_Reset+0, 0
;DS18B20.c,80 :: 		Ow_Write(&PORT, PIN, 0xF0); // Issue command Search_ROM
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       240
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,84 :: 		jj = 0;
	CLRF        _jj+0 
	CLRF        _jj+1 
;DS18B20.c,86 :: 		while (1)
L_public_Search0:
;DS18B20.c,88 :: 		if (search()== 0)
	CALL        _search+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__public_Search62
	MOVLW       0
	XORWF       R0, 0 
L__public_Search62:
	BTFSS       STATUS+0, 2 
	GOTO        L_public_Search2
;DS18B20.c,89 :: 		break;
	GOTO        L_public_Search1
L_public_Search2:
;DS18B20.c,90 :: 		UART1_Write_Text("search");
	MOVLW       ?lstr2_DS18B20+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_DS18B20+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;DS18B20.c,92 :: 		UART1_Write_Text(iTemp);
	MOVF        _iTemp+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        _iTemp+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;DS18B20.c,93 :: 		UART1_Write(10);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;DS18B20.c,94 :: 		UART1_Write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;DS18B20.c,95 :: 		for(iTemp=0; iTemp<8; iTemp++)
	CLRF        _iTemp+0 
	CLRF        _iTemp+1 
L_public_Search3:
	MOVLW       0
	SUBWF       _iTemp+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__public_Search63
	MOVLW       8
	SUBWF       _iTemp+0, 0 
L__public_Search63:
	BTFSC       STATUS+0, 0 
	GOTO        L_public_Search4
;DS18B20.c,97 :: 		g_cSlaveROM[jj][iTemp]=ROM_NO[iTemp];
	MOVLW       3
	MOVWF       R2 
	MOVF        _jj+0, 0 
	MOVWF       R0 
	MOVF        _jj+1, 0 
	MOVWF       R1 
	MOVF        R2, 0 
L__public_Search64:
	BZ          L__public_Search65
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__public_Search64
L__public_Search65:
	MOVLW       _g_cSlaveROM+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_g_cSlaveROM+0)
	ADDWFC      R1, 1 
	MOVF        _iTemp+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVF        _iTemp+1, 0 
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       _ROM_NO+0
	ADDWF       _iTemp+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_ROM_NO+0)
	ADDWFC      _iTemp+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;DS18B20.c,98 :: 		ByteToHex(ROM_NO[iTemp],ctext);
	MOVLW       _ROM_NO+0
	ADDWF       _iTemp+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_ROM_NO+0)
	ADDWFC      _iTemp+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ByteToHex_input+0 
	MOVF        _ctext+0, 0 
	MOVWF       FARG_ByteToHex_output+0 
	MOVF        _ctext+1, 0 
	MOVWF       FARG_ByteToHex_output+1 
	CALL        _ByteToHex+0, 0
;DS18B20.c,99 :: 		UART1_Write_Text(ctext);
	MOVF        _ctext+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        _ctext+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;DS18B20.c,95 :: 		for(iTemp=0; iTemp<8; iTemp++)
	INFSNZ      _iTemp+0, 1 
	INCF        _iTemp+1, 1 
;DS18B20.c,100 :: 		}
	GOTO        L_public_Search3
L_public_Search4:
;DS18B20.c,101 :: 		jj++;
	INFSNZ      _jj+0, 1 
	INCF        _jj+1, 1 
;DS18B20.c,102 :: 		}
	GOTO        L_public_Search0
L_public_Search1:
;DS18B20.c,103 :: 		}
L_end_public_Search:
	RETURN      0
; end of _public_Search

_public_Read:

;DS18B20.c,105 :: 		char* public_Read(unsigned short sIndex){
;DS18B20.c,106 :: 		Ow_Reset(&PORT, PIN);                         // Onewire reset signal
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Reset_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Reset_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Reset_pin+0 
	CALL        _Ow_Reset+0, 0
;DS18B20.c,107 :: 		Ow_Write(&PORT, PIN, 0x55);                   // Issue command Match_ROM
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       85
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,110 :: 		for (index=0;index<8;index++)
	CLRF        _index+0 
L_public_Read6:
	MOVLW       8
	SUBWF       _index+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_public_Read7
;DS18B20.c,112 :: 		Ow_Write(&PORT, PIN, g_cSlaveROM[sIndex][index]);
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       3
	MOVWF       R2 
	MOVF        FARG_public_Read_sIndex+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__public_Read67:
	BZ          L__public_Read68
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__public_Read67
L__public_Read68:
	MOVLW       _g_cSlaveROM+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_g_cSlaveROM+0)
	ADDWFC      R1, 1 
	MOVF        _index+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,110 :: 		for (index=0;index<8;index++)
	INCF        _index+0, 1 
;DS18B20.c,113 :: 		}
	GOTO        L_public_Read6
L_public_Read7:
;DS18B20.c,114 :: 		Delay_ms(10);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_public_Read9:
	DECFSZ      R13, 1, 1
	BRA         L_public_Read9
	DECFSZ      R12, 1, 1
	BRA         L_public_Read9
	NOP
	NOP
;DS18B20.c,116 :: 		Ow_Write(&PORT, PIN, 0x44);                   // Issue command CONVERT_T
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       68
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,117 :: 		Delay_ms(760);        // 760ms
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       219
	MOVWF       R12, 0
	MOVLW       255
	MOVWF       R13, 0
L_public_Read10:
	DECFSZ      R13, 1, 1
	BRA         L_public_Read10
	DECFSZ      R12, 1, 1
	BRA         L_public_Read10
	DECFSZ      R11, 1, 1
	BRA         L_public_Read10
;DS18B20.c,120 :: 		Ow_Reset(&PORT, PIN);
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Reset_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Reset_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Reset_pin+0 
	CALL        _Ow_Reset+0, 0
;DS18B20.c,121 :: 		Ow_Write(&PORT, PIN, 0x55);                   // Issue command Match_ROM
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       85
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,123 :: 		for (index=0;index<8;index++)
	CLRF        _index+0 
L_public_Read11:
	MOVLW       8
	SUBWF       _index+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_public_Read12
;DS18B20.c,125 :: 		Ow_Write(&PORT, PIN, g_cSlaveROM[sIndex][index]);
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       3
	MOVWF       R2 
	MOVF        FARG_public_Read_sIndex+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__public_Read69:
	BZ          L__public_Read70
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__public_Read69
L__public_Read70:
	MOVLW       _g_cSlaveROM+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_g_cSlaveROM+0)
	ADDWFC      R1, 1 
	MOVF        _index+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,123 :: 		for (index=0;index<8;index++)
	INCF        _index+0, 1 
;DS18B20.c,126 :: 		}
	GOTO        L_public_Read11
L_public_Read12:
;DS18B20.c,127 :: 		Delay_ms(10);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_public_Read14:
	DECFSZ      R13, 1, 1
	BRA         L_public_Read14
	DECFSZ      R12, 1, 1
	BRA         L_public_Read14
	NOP
	NOP
;DS18B20.c,128 :: 		Ow_Write(&PORT, PIN, 0xBE);
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       190
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,130 :: 		iTemp =  Ow_Read(&PORT, PIN);                  // LSB (the LSB is first transferred
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Read_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Read_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Read_pin+0 
	CALL        _Ow_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _iTemp+0 
	MOVLW       0
	MOVWF       _iTemp+1 
;DS18B20.c,131 :: 		iTemp = (Ow_Read(&PORT, PIN) << 8) + iTemp;
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Read_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Read_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Read_pin+0 
	CALL        _Ow_Read+0, 0
	MOVF        R0, 0 
	MOVWF       R2 
	CLRF        R1 
	MOVF        R1, 0 
	ADDWF       _iTemp+0, 1 
	MOVF        R2, 0 
	ADDWFC      _iTemp+1, 1 
;DS18B20.c,132 :: 		TEMPtoTEXT();
	CALL        _TEMPtoTEXT+0, 0
;DS18B20.c,133 :: 		return ctext;
	MOVF        _ctext+0, 0 
	MOVWF       R0 
	MOVF        _ctext+1, 0 
	MOVWF       R1 
;DS18B20.c,134 :: 		}
L_end_public_Read:
	RETURN      0
; end of _public_Read

_public_Read_Temp:

;DS18B20.c,136 :: 		char* public_Read_Temp(){
;DS18B20.c,137 :: 		Ow_Reset(&PORT, PIN);                         // Onewire reset signal
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Reset_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Reset_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Reset_pin+0 
	CALL        _Ow_Reset+0, 0
;DS18B20.c,138 :: 		Ow_Write(&PORT, PIN, 0xCC);                   // Issue command SKIP_ROM
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       204
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,139 :: 		Ow_Write(&PORT, PIN, 0x44);                   // Issue command CONVERT_T
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       68
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,140 :: 		Delay_us(120);
	MOVLW       39
	MOVWF       R13, 0
L_public_Read_Temp15:
	DECFSZ      R13, 1, 1
	BRA         L_public_Read_Temp15
	NOP
	NOP
;DS18B20.c,142 :: 		Ow_Reset(&PORT, PIN);
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Reset_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Reset_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Reset_pin+0 
	CALL        _Ow_Reset+0, 0
;DS18B20.c,143 :: 		Ow_Write(&PORT, PIN, 0xCC);                   // Issue command SKIP_ROM
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       204
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,144 :: 		Ow_Write(&PORT, PIN, 0xBE);                   // Issue command READ_SCRATCHPAD
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       190
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,146 :: 		iTemp =  Ow_Read(&PORT, PIN);
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Read_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Read_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Read_pin+0 
	CALL        _Ow_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _iTemp+0 
	MOVLW       0
	MOVWF       _iTemp+1 
;DS18B20.c,147 :: 		iTemp = (Ow_Read(&PORT, PIN) << 8) + iTemp;
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Read_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Read_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Read_pin+0 
	CALL        _Ow_Read+0, 0
	MOVF        R0, 0 
	MOVWF       R2 
	CLRF        R1 
	MOVF        R1, 0 
	ADDWF       _iTemp+0, 1 
	MOVF        R2, 0 
	ADDWFC      _iTemp+1, 1 
;DS18B20.c,149 :: 		Delay_us(120);
	MOVLW       39
	MOVWF       R13, 0
L_public_Read_Temp16:
	DECFSZ      R13, 1, 1
	BRA         L_public_Read_Temp16
	NOP
	NOP
;DS18B20.c,150 :: 		TEMPtoTEXT();
	CALL        _TEMPtoTEXT+0, 0
;DS18B20.c,151 :: 		return ctext;
	MOVF        _ctext+0, 0 
	MOVWF       R0 
	MOVF        _ctext+1, 0 
	MOVWF       R1 
;DS18B20.c,152 :: 		}
L_end_public_Read_Temp:
	RETURN      0
; end of _public_Read_Temp

_TEMPtoTEXT:

;DS18B20.c,156 :: 		void TEMPtoTEXT() {
;DS18B20.c,158 :: 		if (iTemp & 0x8000) {
	BTFSS       _iTemp+1, 7 
	GOTO        L_TEMPtoTEXT17
;DS18B20.c,159 :: 		ctext[0] = '-';
	MOVFF       _ctext+0, FSR1
	MOVFF       _ctext+1, FSR1H
	MOVLW       45
	MOVWF       POSTINC1+0 
;DS18B20.c,160 :: 		iTemp = ~iTemp + 1;
	COMF        _iTemp+0, 1 
	COMF        _iTemp+1, 1 
	INFSNZ      _iTemp+0, 1 
	INCF        _iTemp+1, 1 
;DS18B20.c,161 :: 		}
L_TEMPtoTEXT17:
;DS18B20.c,164 :: 		temp_whole = iTemp >> sRES_SHIFT ;
	MOVF        _sRES_SHIFT+0, 0 
	MOVWF       R2 
	MOVF        _iTemp+0, 0 
	MOVWF       R0 
	MOVF        _iTemp+1, 0 
	MOVWF       R1 
	MOVF        R2, 0 
L__TEMPtoTEXT73:
	BZ          L__TEMPtoTEXT74
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	ADDLW       255
	GOTO        L__TEMPtoTEXT73
L__TEMPtoTEXT74:
	MOVF        R0, 0 
	MOVWF       _temp_whole+0 
;DS18B20.c,167 :: 		if (temp_whole/100)
	MOVLW       100
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_TEMPtoTEXT18
;DS18B20.c,168 :: 		ctext[0] = temp_whole/100  + 48;
	MOVLW       100
	MOVWF       R4 
	MOVF        _temp_whole+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVFF       _ctext+0, FSR1
	MOVFF       _ctext+1, FSR1H
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       POSTINC1+0 
	GOTO        L_TEMPtoTEXT19
L_TEMPtoTEXT18:
;DS18B20.c,170 :: 		ctext[0] = '0';
	MOVFF       _ctext+0, FSR1
	MOVFF       _ctext+1, FSR1H
	MOVLW       48
	MOVWF       POSTINC1+0 
L_TEMPtoTEXT19:
;DS18B20.c,172 :: 		ctext[1] = (temp_whole/10)%10 + 48;             // Extract tens digit
	MOVLW       1
	ADDWF       _ctext+0, 0 
	MOVWF       FLOC__TEMPtoTEXT+0 
	MOVLW       0
	ADDWFC      _ctext+1, 0 
	MOVWF       FLOC__TEMPtoTEXT+1 
	MOVLW       10
	MOVWF       R4 
	MOVF        _temp_whole+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__TEMPtoTEXT+0, FSR1
	MOVFF       FLOC__TEMPtoTEXT+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;DS18B20.c,173 :: 		ctext[2] =  temp_whole%10     + 48;             // Extract ones digit
	MOVLW       2
	ADDWF       _ctext+0, 0 
	MOVWF       FLOC__TEMPtoTEXT+0 
	MOVLW       0
	ADDWFC      _ctext+1, 0 
	MOVWF       FLOC__TEMPtoTEXT+1 
	MOVLW       10
	MOVWF       R4 
	MOVF        _temp_whole+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__TEMPtoTEXT+0, FSR1
	MOVFF       FLOC__TEMPtoTEXT+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;DS18B20.c,176 :: 		temp_fraction  = iTemp << (4-sRES_SHIFT);
	MOVF        _sRES_SHIFT+0, 0 
	SUBLW       4
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVF        R0, 0 
	MOVWF       R2 
	MOVF        _iTemp+0, 0 
	MOVWF       R0 
	MOVF        _iTemp+1, 0 
	MOVWF       R1 
	MOVF        R2, 0 
L__TEMPtoTEXT75:
	BZ          L__TEMPtoTEXT76
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__TEMPtoTEXT75
L__TEMPtoTEXT76:
	MOVF        R0, 0 
	MOVWF       _temp_fraction+0 
	MOVF        R1, 0 
	MOVWF       _temp_fraction+1 
;DS18B20.c,177 :: 		temp_fraction &= 0x000F;
	MOVLW       15
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       _temp_fraction+0 
	MOVF        R1, 0 
	MOVWF       _temp_fraction+1 
;DS18B20.c,178 :: 		temp_fraction *= 625;
	MOVLW       113
	MOVWF       R4 
	MOVLW       2
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_fraction+0 
	MOVF        R1, 0 
	MOVWF       _temp_fraction+1 
;DS18B20.c,181 :: 		ctext[4] =  temp_fraction/1000    + 48;         // Extract thousands digit
	MOVLW       4
	ADDWF       _ctext+0, 0 
	MOVWF       FLOC__TEMPtoTEXT+0 
	MOVLW       0
	ADDWFC      _ctext+1, 0 
	MOVWF       FLOC__TEMPtoTEXT+1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__TEMPtoTEXT+0, FSR1
	MOVFF       FLOC__TEMPtoTEXT+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;DS18B20.c,182 :: 		ctext[5] = (temp_fraction/100)%10 + 48;         // Extract hundreds digit
	MOVLW       5
	ADDWF       _ctext+0, 0 
	MOVWF       FLOC__TEMPtoTEXT+0 
	MOVLW       0
	ADDWFC      _ctext+1, 0 
	MOVWF       FLOC__TEMPtoTEXT+1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp_fraction+0, 0 
	MOVWF       R0 
	MOVF        _temp_fraction+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__TEMPtoTEXT+0, FSR1
	MOVFF       FLOC__TEMPtoTEXT+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;DS18B20.c,183 :: 		ctext[6] = (temp_fraction/10)%10  + 48;         // Extract tens digit
	MOVLW       6
	ADDWF       _ctext+0, 0 
	MOVWF       FLOC__TEMPtoTEXT+0 
	MOVLW       0
	ADDWFC      _ctext+1, 0 
	MOVWF       FLOC__TEMPtoTEXT+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp_fraction+0, 0 
	MOVWF       R0 
	MOVF        _temp_fraction+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__TEMPtoTEXT+0, FSR1
	MOVFF       FLOC__TEMPtoTEXT+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;DS18B20.c,184 :: 		ctext[7] =  temp_fraction%10      + 48;         // Extract ones digit
	MOVLW       7
	ADDWF       _ctext+0, 0 
	MOVWF       FLOC__TEMPtoTEXT+0 
	MOVLW       0
	ADDWFC      _ctext+1, 0 
	MOVWF       FLOC__TEMPtoTEXT+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp_fraction+0, 0 
	MOVWF       R0 
	MOVF        _temp_fraction+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__TEMPtoTEXT+0, FSR1
	MOVFF       FLOC__TEMPtoTEXT+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;DS18B20.c,186 :: 		}
L_end_TEMPtoTEXT:
	RETURN      0
; end of _TEMPtoTEXT

_docrc8:

;DS18B20.c,189 :: 		unsigned char docrc8(unsigned char value)
;DS18B20.c,191 :: 		crc8 = dscrc_table[crc8 ^ value];    // Xor operation
	MOVF        FARG_docrc8_value+0, 0 
	XORWF       _crc8+0, 0 
	MOVWF       R0 
	MOVLW       _dscrc_table+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_dscrc_table+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_dscrc_table+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 0 
	MOVWF       _crc8+0 
;DS18B20.c,192 :: 		return crc8;
;DS18B20.c,193 :: 		}
L_end_docrc8:
	RETURN      0
; end of _docrc8

_search:

;DS18B20.c,195 :: 		int search()
;DS18B20.c,198 :: 		id_bit_number = 1;
	MOVLW       1
	MOVWF       _id_bit_number+0 
	MOVLW       0
	MOVWF       _id_bit_number+1 
;DS18B20.c,199 :: 		last_zero = 0;
	CLRF        _last_zero+0 
	CLRF        _last_zero+1 
;DS18B20.c,200 :: 		rom_byte_number = 0;
	CLRF        _rom_byte_number+0 
	CLRF        _rom_byte_number+1 
;DS18B20.c,201 :: 		rom_byte_mask = 1;
	MOVLW       1
	MOVWF       _rom_byte_mask+0 
;DS18B20.c,202 :: 		search_result = 0;
	CLRF        _search_result+0 
	CLRF        _search_result+1 
;DS18B20.c,203 :: 		crc8 = 0;
	CLRF        _crc8+0 
;DS18B20.c,206 :: 		if (!LastDeviceFlag)
	MOVF        _LastDeviceFlag+0, 0 
	IORWF       _LastDeviceFlag+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_search20
;DS18B20.c,209 :: 		if (Ow_Reset(&PORT, PIN))
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Reset_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Reset_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Reset_pin+0 
	CALL        _Ow_Reset+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_search21
;DS18B20.c,212 :: 		LastDiscrepancy = 0;
	CLRF        _LastDiscrepancy+0 
	CLRF        _LastDiscrepancy+1 
;DS18B20.c,213 :: 		LastDeviceFlag = 0;
	CLRF        _LastDeviceFlag+0 
	CLRF        _LastDeviceFlag+1 
;DS18B20.c,214 :: 		LastFamilyDiscrepancy = 0;
	CLRF        _LastFamilyDiscrepancy+0 
	CLRF        _LastFamilyDiscrepancy+1 
;DS18B20.c,215 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_search
;DS18B20.c,216 :: 		}
L_search21:
;DS18B20.c,218 :: 		Ow_Write(&PORT, PIN, 0xF0);
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       240
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,221 :: 		do
L_search22:
;DS18B20.c,224 :: 		id_bit = OW_Read_Bit();
	CALL        _Ow_Read_Bit+0, 0
	MOVF        R0, 0 
	MOVWF       _id_bit+0 
	MOVLW       0
	MOVWF       _id_bit+1 
;DS18B20.c,225 :: 		cmp_id_bit = OW_Read_Bit();
	CALL        _Ow_Read_Bit+0, 0
	MOVF        R0, 0 
	MOVWF       _cmp_id_bit+0 
	MOVLW       0
	MOVWF       _cmp_id_bit+1 
;DS18B20.c,230 :: 		if ((id_bit == 1) && (cmp_id_bit == 1))
	MOVLW       0
	XORWF       _id_bit+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__search79
	MOVLW       1
	XORWF       _id_bit+0, 0 
L__search79:
	BTFSS       STATUS+0, 2 
	GOTO        L_search27
	MOVLW       0
	XORWF       _cmp_id_bit+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__search80
	MOVLW       1
	XORWF       _cmp_id_bit+0, 0 
L__search80:
	BTFSS       STATUS+0, 2 
	GOTO        L_search27
L__search57:
;DS18B20.c,231 :: 		break;
	GOTO        L_search23
L_search27:
;DS18B20.c,235 :: 		if (id_bit != cmp_id_bit)
	MOVF        _id_bit+1, 0 
	XORWF       _cmp_id_bit+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__search81
	MOVF        _cmp_id_bit+0, 0 
	XORWF       _id_bit+0, 0 
L__search81:
	BTFSC       STATUS+0, 2 
	GOTO        L_search29
;DS18B20.c,236 :: 		search_direction = id_bit; // bit write value for search
	MOVF        _id_bit+0, 0 
	MOVWF       _search_direction+0 
	GOTO        L_search30
L_search29:
;DS18B20.c,242 :: 		if (id_bit_number < LastDiscrepancy)
	MOVLW       128
	XORWF       _id_bit_number+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _LastDiscrepancy+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__search82
	MOVF        _LastDiscrepancy+0, 0 
	SUBWF       _id_bit_number+0, 0 
L__search82:
	BTFSC       STATUS+0, 0 
	GOTO        L_search31
;DS18B20.c,243 :: 		search_direction = ((ROM_NO[rom_byte_number] & rom_byte_mask) > 0);
	MOVLW       _ROM_NO+0
	ADDWF       _rom_byte_number+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_ROM_NO+0)
	ADDWFC      _rom_byte_number+1, 0 
	MOVWF       FSR0H 
	MOVF        _rom_byte_mask+0, 0 
	ANDWF       POSTINC0+0, 0 
	MOVWF       _search_direction+0 
	MOVF        _search_direction+0, 0 
	SUBLW       0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       _search_direction+0 
	GOTO        L_search32
L_search31:
;DS18B20.c,246 :: 		search_direction = (id_bit_number == LastDiscrepancy);
	MOVF        _id_bit_number+1, 0 
	XORWF       _LastDiscrepancy+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__search83
	MOVF        _LastDiscrepancy+0, 0 
	XORWF       _id_bit_number+0, 0 
L__search83:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       _search_direction+0 
L_search32:
;DS18B20.c,249 :: 		if (search_direction == 0)
	MOVF        _search_direction+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_search33
;DS18B20.c,251 :: 		last_zero = id_bit_number;
	MOVF        _id_bit_number+0, 0 
	MOVWF       _last_zero+0 
	MOVF        _id_bit_number+1, 0 
	MOVWF       _last_zero+1 
;DS18B20.c,253 :: 		if (last_zero < 9)
	MOVLW       128
	XORWF       _id_bit_number+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__search84
	MOVLW       9
	SUBWF       _id_bit_number+0, 0 
L__search84:
	BTFSC       STATUS+0, 0 
	GOTO        L_search34
;DS18B20.c,254 :: 		LastFamilyDiscrepancy = last_zero;
	MOVF        _last_zero+0, 0 
	MOVWF       _LastFamilyDiscrepancy+0 
	MOVF        _last_zero+1, 0 
	MOVWF       _LastFamilyDiscrepancy+1 
L_search34:
;DS18B20.c,255 :: 		}
L_search33:
;DS18B20.c,256 :: 		}
L_search30:
;DS18B20.c,261 :: 		if (search_direction == 1)
	MOVF        _search_direction+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_search35
;DS18B20.c,262 :: 		ROM_NO[rom_byte_number] |= rom_byte_mask;
	MOVLW       _ROM_NO+0
	ADDWF       _rom_byte_number+0, 0 
	MOVWF       R1 
	MOVLW       hi_addr(_ROM_NO+0)
	ADDWFC      _rom_byte_number+1, 0 
	MOVWF       R2 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        _rom_byte_mask+0, 0 
	IORWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	GOTO        L_search36
L_search35:
;DS18B20.c,264 :: 		ROM_NO[rom_byte_number] &= ~rom_byte_mask;
	MOVLW       _ROM_NO+0
	ADDWF       _rom_byte_number+0, 0 
	MOVWF       R1 
	MOVLW       hi_addr(_ROM_NO+0)
	ADDWFC      _rom_byte_number+1, 0 
	MOVWF       R2 
	COMF        _rom_byte_mask+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	ANDWF       R0, 1 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
L_search36:
;DS18B20.c,267 :: 		if (search_direction)
	MOVF        _search_direction+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_search37
;DS18B20.c,268 :: 		Ow_Write_One();
	CALL        _Ow_Write_One+0, 0
	GOTO        L_search38
L_search37:
;DS18B20.c,270 :: 		Ow_Write_Zero();
	CALL        _Ow_Write_Zero+0, 0
L_search38:
;DS18B20.c,274 :: 		id_bit_number++;
	INFSNZ      _id_bit_number+0, 1 
	INCF        _id_bit_number+1, 1 
;DS18B20.c,275 :: 		rom_byte_mask <<= 1;
	MOVF        _rom_byte_mask+0, 0 
	MOVWF       R1 
	RLCF        R1, 1 
	BCF         R1, 0 
	MOVF        R1, 0 
	MOVWF       _rom_byte_mask+0 
;DS18B20.c,280 :: 		if (rom_byte_mask == 0)
	MOVF        R1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_search39
;DS18B20.c,283 :: 		docrc8(ROM_NO[rom_byte_number]); // accumulate the CRC
	MOVLW       _ROM_NO+0
	ADDWF       _rom_byte_number+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_ROM_NO+0)
	ADDWFC      _rom_byte_number+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_docrc8_value+0 
	CALL        _docrc8+0, 0
;DS18B20.c,284 :: 		rom_byte_number++;
	INFSNZ      _rom_byte_number+0, 1 
	INCF        _rom_byte_number+1, 1 
;DS18B20.c,285 :: 		rom_byte_mask = 1;
	MOVLW       1
	MOVWF       _rom_byte_mask+0 
;DS18B20.c,286 :: 		}
L_search39:
;DS18B20.c,289 :: 		while (rom_byte_number < 8); // loop until through all ROM bytes 0-7
	MOVLW       128
	XORWF       _rom_byte_number+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__search85
	MOVLW       8
	SUBWF       _rom_byte_number+0, 0 
L__search85:
	BTFSS       STATUS+0, 0 
	GOTO        L_search22
L_search23:
;DS18B20.c,292 :: 		if (!((id_bit_number < 65) || (crc8 != 0)))
	MOVLW       128
	XORWF       _id_bit_number+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__search86
	MOVLW       65
	SUBWF       _id_bit_number+0, 0 
L__search86:
	BTFSS       STATUS+0, 0 
	GOTO        L_search41
	MOVF        _crc8+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_search41
	CLRF        R0 
	GOTO        L_search40
L_search41:
	MOVLW       1
	MOVWF       R0 
L_search40:
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_search42
;DS18B20.c,295 :: 		LastDiscrepancy = last_zero;
	MOVF        _last_zero+0, 0 
	MOVWF       _LastDiscrepancy+0 
	MOVF        _last_zero+1, 0 
	MOVWF       _LastDiscrepancy+1 
;DS18B20.c,298 :: 		if (LastDiscrepancy == 0)
	MOVLW       0
	XORWF       _last_zero+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__search87
	MOVLW       0
	XORWF       _last_zero+0, 0 
L__search87:
	BTFSS       STATUS+0, 2 
	GOTO        L_search43
;DS18B20.c,299 :: 		LastDeviceFlag = 1;
	MOVLW       1
	MOVWF       _LastDeviceFlag+0 
	MOVLW       0
	MOVWF       _LastDeviceFlag+1 
L_search43:
;DS18B20.c,300 :: 		search_result = 1;
	MOVLW       1
	MOVWF       _search_result+0 
	MOVLW       0
	MOVWF       _search_result+1 
;DS18B20.c,301 :: 		}
L_search42:
;DS18B20.c,302 :: 		}
L_search20:
;DS18B20.c,307 :: 		if (!search_result || !ROM_NO[0])
	MOVF        _search_result+0, 0 
	IORWF       _search_result+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L__search56
	MOVF        _ROM_NO+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__search56
	GOTO        L_search46
L__search56:
;DS18B20.c,309 :: 		LastDiscrepancy = 0;
	CLRF        _LastDiscrepancy+0 
	CLRF        _LastDiscrepancy+1 
;DS18B20.c,310 :: 		LastDeviceFlag = 0;
	CLRF        _LastDeviceFlag+0 
	CLRF        _LastDeviceFlag+1 
;DS18B20.c,311 :: 		LastFamilyDiscrepancy = 0;
	CLRF        _LastFamilyDiscrepancy+0 
	CLRF        _LastFamilyDiscrepancy+1 
;DS18B20.c,312 :: 		search_result = 0;
	CLRF        _search_result+0 
	CLRF        _search_result+1 
;DS18B20.c,313 :: 		}
L_search46:
;DS18B20.c,314 :: 		return search_result;
	MOVF        _search_result+0, 0 
	MOVWF       R0 
	MOVF        _search_result+1, 0 
	MOVWF       R1 
;DS18B20.c,315 :: 		}
L_end_search:
	RETURN      0
; end of _search

_get_IndexFrom_Sensor:

;DS18B20.c,318 :: 		int get_IndexFrom_Sensor(char* ROM_NO){
;DS18B20.c,320 :: 		Ow_Reset(&PORT, PIN);
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Reset_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Reset_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Reset_pin+0 
	CALL        _Ow_Reset+0, 0
;DS18B20.c,321 :: 		Ow_Write(&PORT, PIN, 0x55);                   // Issue command Match_ROM
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       85
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,323 :: 		for (index=0;index<8;index++)
	CLRF        _index+0 
L_get_IndexFrom_Sensor47:
	MOVLW       8
	SUBWF       _index+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_get_IndexFrom_Sensor48
;DS18B20.c,325 :: 		Ow_Write(&PORT, PIN, ROM_NO[index]);
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVF        _index+0, 0 
	ADDWF       FARG_get_IndexFrom_Sensor_ROM_NO+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_get_IndexFrom_Sensor_ROM_NO+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,323 :: 		for (index=0;index<8;index++)
	INCF        _index+0, 1 
;DS18B20.c,326 :: 		}
	GOTO        L_get_IndexFrom_Sensor47
L_get_IndexFrom_Sensor48:
;DS18B20.c,327 :: 		Delay_ms(10);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_get_IndexFrom_Sensor50:
	DECFSZ      R13, 1, 1
	BRA         L_get_IndexFrom_Sensor50
	DECFSZ      R12, 1, 1
	BRA         L_get_IndexFrom_Sensor50
	NOP
	NOP
;DS18B20.c,328 :: 		Ow_Write(&PORT, PIN, 0xBE);
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       190
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;DS18B20.c,330 :: 		Ow_Read(&PORT, PIN);   // LSB (the LSB is first transferred
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Read_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Read_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Read_pin+0 
	CALL        _Ow_Read+0, 0
;DS18B20.c,331 :: 		Ow_Read(&PORT, PIN) ; // MSB
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Read_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Read_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Read_pin+0 
	CALL        _Ow_Read+0, 0
;DS18B20.c,332 :: 		index = Ow_Read(&PORT, PIN) ; // TH
	MOVLW       PORTB+0
	MOVWF       FARG_Ow_Read_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Ow_Read_port+1 
	MOVLW       4
	MOVWF       FARG_Ow_Read_pin+0 
	CALL        _Ow_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _index+0 
;DS18B20.c,336 :: 		return index;
	MOVLW       0
	MOVWF       R1 
;DS18B20.c,338 :: 		}
L_end_get_IndexFrom_Sensor:
	RETURN      0
; end of _get_IndexFrom_Sensor

_Ow_Read_Bit:

;DS18B20.c,340 :: 		unsigned short Ow_Read_Bit()
;DS18B20.c,343 :: 		TRISBIT = 0;                 // Set pin 2 in PORT E as output
	BCF         TRISB+0, 4 
;DS18B20.c,344 :: 		PORTBIT = 0;               // Drive bus low   LATE.B2;   for PIC18
	BCF         PORTB+0, 4 
;DS18B20.c,345 :: 		delay_us(6);                // Wait 6 usecs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
;DS18B20.c,346 :: 		TRISBIT = 1;                 // Release the bus
	BSF         TRISB+0, 4 
;DS18B20.c,347 :: 		delay_us(9);                // Wait 9 usecs
	MOVLW       2
	MOVWF       R13, 0
L_Ow_Read_Bit51:
	DECFSZ      R13, 1, 1
	BRA         L_Ow_Read_Bit51
	NOP
	NOP
;DS18B20.c,348 :: 		BitValue = PORTBIT;         // Read bit value on pin 2 on PORT E
	MOVLW       0
	BTFSC       PORTB+0, 4 
	MOVLW       1
	MOVWF       R1 
;DS18B20.c,349 :: 		delay_us(55);               // Wait 55 usecs
	MOVLW       18
	MOVWF       R13, 0
L_Ow_Read_Bit52:
	DECFSZ      R13, 1, 1
	BRA         L_Ow_Read_Bit52
;DS18B20.c,350 :: 		return BitValue;            // Return bit read
	MOVF        R1, 0 
	MOVWF       R0 
;DS18B20.c,351 :: 		}
L_end_Ow_Read_Bit:
	RETURN      0
; end of _Ow_Read_Bit

_Ow_Write_One:

;DS18B20.c,353 :: 		void Ow_Write_One()
;DS18B20.c,355 :: 		TRISBIT = 0;      // Set pin 2 in PORT E as output
	BCF         TRISB+0, 4 
;DS18B20.c,356 :: 		PORTBIT = 0;    // Drive bus low
	BCF         PORTB+0, 4 
;DS18B20.c,357 :: 		delay_us(6);     // Wait 6 usecs        (6*4)*0.25 us
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
;DS18B20.c,358 :: 		TRISBIT = 1;      // Release the bus
	BSF         TRISB+0, 4 
;DS18B20.c,359 :: 		delay_us(64);    // Wait 64 usecs        (64*4)*0.25 us
	MOVLW       21
	MOVWF       R13, 0
L_Ow_Write_One53:
	DECFSZ      R13, 1, 1
	BRA         L_Ow_Write_One53
;DS18B20.c,360 :: 		}
L_end_Ow_Write_One:
	RETURN      0
; end of _Ow_Write_One

_Ow_Write_Zero:

;DS18B20.c,362 :: 		void Ow_Write_Zero()
;DS18B20.c,364 :: 		TRISBIT = 0;     // Set pin 2 in PORT E as output
	BCF         TRISB+0, 4 
;DS18B20.c,365 :: 		PORTBIT = 0;   // Drive bus low
	BCF         PORTB+0, 4 
;DS18B20.c,366 :: 		delay_us(60);   // Wait 60 usecs
	MOVLW       19
	MOVWF       R13, 0
L_Ow_Write_Zero54:
	DECFSZ      R13, 1, 1
	BRA         L_Ow_Write_Zero54
	NOP
	NOP
;DS18B20.c,367 :: 		TRISBIT = 1;     // Release the bus
	BSF         TRISB+0, 4 
;DS18B20.c,368 :: 		delay_us(10);   // Wait 10 usecs
	MOVLW       3
	MOVWF       R13, 0
L_Ow_Write_Zero55:
	DECFSZ      R13, 1, 1
	BRA         L_Ow_Write_Zero55
;DS18B20.c,369 :: 		}
L_end_Ow_Write_Zero:
	RETURN      0
; end of _Ow_Write_Zero

DS18B20____?ag:

L_end_DS18B20___?ag:
	RETURN      0
; end of DS18B20____?ag
