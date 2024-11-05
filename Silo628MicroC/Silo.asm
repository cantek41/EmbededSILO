
_interrupt:

;Silo.c,39 :: 		void interrupt() {
;Silo.c,40 :: 		RS485Slave_Receive(dat);
	MOVLW       _dat+0
	MOVWF       FARG_RS485Slave_Receive_data_buffer+0 
	MOVLW       hi_addr(_dat+0)
	MOVWF       FARG_RS485Slave_Receive_data_buffer+1 
	CALL        _RS485Slave_Receive+0, 0
;Silo.c,42 :: 		}
L_end_interrupt:
L__interrupt12:
	RETFIE      1
; end of _interrupt

_init:

;Silo.c,44 :: 		void init(){
;Silo.c,45 :: 		PORTD = 0xFF;
	MOVLW       255
	MOVWF       PORTD+0 
;Silo.c,46 :: 		TRISD = 0;
	CLRF        TRISD+0 
;Silo.c,47 :: 		TRISA.B0=0;
	BCF         TRISA+0, 0 
;Silo.c,49 :: 		UART1_Init(9600);               // Initialize UART module at 9600 bps
	MOVLW       25
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Silo.c,50 :: 		Delay_ms(100);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_init0:
	DECFSZ      R13, 1, 1
	BRA         L_init0
	DECFSZ      R12, 1, 1
	BRA         L_init0
	NOP
	NOP
;Silo.c,51 :: 		RS485Slave_Init(160);              // Intialize MCU as slave, address 160
	MOVLW       160
	MOVWF       FARG_RS485Slave_Init_slave_address+0 
	CALL        _RS485Slave_Init+0, 0
;Silo.c,53 :: 		dat[4] = 0;                        // ensure that message received flag is 0
	CLRF        _dat+4 
;Silo.c,54 :: 		dat[5] = 0;                        // ensure that message received flag is 0
	CLRF        _dat+5 
;Silo.c,55 :: 		dat[6] = 0;                        // ensure that error flag is 0
	CLRF        _dat+6 
;Silo.c,57 :: 		RCIE_bit = 1;                      // enable interrupt on UART1 receive
	BSF         RCIE_bit+0, BitPos(RCIE_bit+0) 
;Silo.c,58 :: 		TXIE_bit = 0;                      // disable interrupt on UART1 transmit
	BCF         TXIE_bit+0, BitPos(TXIE_bit+0) 
;Silo.c,59 :: 		PEIE_bit = 1;                      // enable peripheral interrupts
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;Silo.c,60 :: 		GIE_bit = 1;                       // enable all interrupts
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Silo.c,66 :: 		}
L_end_init:
	RETURN      0
; end of _init

_main:

;Silo.c,69 :: 		void main() {
;Silo.c,71 :: 		init();
	CALL        _init+0, 0
;Silo.c,72 :: 		public_Search();
	CALL        _public_Search+0, 0
;Silo.c,74 :: 		while(1){
L_main1:
;Silo.c,75 :: 		PORTA.B0=1;
	BSF         PORTA+0, 0 
;Silo.c,76 :: 		Delay_ms(300);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       134
	MOVWF       R12, 0
	MOVLW       153
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
;Silo.c,77 :: 		PORTA.B0=0;
	BCF         PORTA+0, 0 
;Silo.c,78 :: 		UART1_Write_Text("Line");
	MOVLW       ?lstr2_Silo+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_Silo+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Silo.c,79 :: 		AddLine();
	CALL        _AddLine+0, 0
;Silo.c,81 :: 		text = public_Read(0);
	CLRF        FARG_public_Read_sIndex+0 
	CALL        _public_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _text+0 
	MOVF        R1, 0 
	MOVWF       _text+1 
;Silo.c,82 :: 		UART1_Write_Text(text);
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Silo.c,83 :: 		AddLine();
	CALL        _AddLine+0, 0
;Silo.c,85 :: 		text = public_Read(1);// public_Read_Temp();
	MOVLW       1
	MOVWF       FARG_public_Read_sIndex+0 
	CALL        _public_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _text+0 
	MOVF        R1, 0 
	MOVWF       _text+1 
;Silo.c,86 :: 		UART1_Write_Text(text);
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Silo.c,87 :: 		AddLine();
	CALL        _AddLine+0, 0
;Silo.c,89 :: 		UART1_Write_text(dat[4]);
	MOVF        _dat+4, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       0
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Silo.c,90 :: 		if (dat[5])  {                     // if an error detected, signal it
	MOVF        _dat+5, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
;Silo.c,91 :: 		PORTD = 0xAA;                  //   setting portd to 0xAA
	MOVLW       170
	MOVWF       PORTD+0 
;Silo.c,92 :: 		dat[5] = 0;
	CLRF        _dat+5 
;Silo.c,93 :: 		}
L_main4:
;Silo.c,94 :: 		if (dat[4]!=0) {                    // upon completed valid message receive
	MOVF        _dat+4, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main5
;Silo.c,95 :: 		UART1_Write_text("okudu");
	MOVLW       ?lstr3_Silo+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_Silo+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Silo.c,96 :: 		dat[4] = 0;                    //   data[4] is set to 0xFF
	CLRF        _dat+4 
;Silo.c,97 :: 		j = dat[3];
	MOVF        _dat+3, 0 
	MOVWF       _j+0 
;Silo.c,98 :: 		for (i = 1; i <= dat[3];i++){
	MOVLW       1
	MOVWF       _i+0 
L_main6:
	MOVF        _i+0, 0 
	SUBWF       _dat+3, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main7
;Silo.c,99 :: 		PORTD = dat[i-1];
	DECF        _i+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       _dat+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_dat+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTD+0 
;Silo.c,98 :: 		for (i = 1; i <= dat[3];i++){
	INCF        _i+0, 1 
;Silo.c,101 :: 		}
	GOTO        L_main6
L_main7:
;Silo.c,102 :: 		dat[0] = dat[0]+1;
	INCF        _dat+0, 1 
;Silo.c,106 :: 		Delay_ms(1);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       75
	MOVWF       R13, 0
L_main9:
	DECFSZ      R13, 1, 1
	BRA         L_main9
	DECFSZ      R12, 1, 1
	BRA         L_main9
;Silo.c,107 :: 		UART1_Write_text("RS485Slave_Send");
	MOVLW       ?lstr4_Silo+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_Silo+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Silo.c,108 :: 		RS485Slave_Send(dat,1);        //   and send it back to master
	MOVLW       _dat+0
	MOVWF       FARG_RS485Slave_Send_data_buffer+0 
	MOVLW       hi_addr(_dat+0)
	MOVWF       FARG_RS485Slave_Send_data_buffer+1 
	MOVLW       1
	MOVWF       FARG_RS485Slave_Send_datalen+0 
	CALL        _RS485Slave_Send+0, 0
;Silo.c,109 :: 		}
L_main5:
;Silo.c,110 :: 		Delay_ms(1000);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main10:
	DECFSZ      R13, 1, 1
	BRA         L_main10
	DECFSZ      R12, 1, 1
	BRA         L_main10
	DECFSZ      R11, 1, 1
	BRA         L_main10
	NOP
	NOP
;Silo.c,112 :: 		}
	GOTO        L_main1
;Silo.c,113 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_AddLine:

;Silo.c,114 :: 		void AddLine(){
;Silo.c,115 :: 		UART1_Write(10);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;Silo.c,116 :: 		UART1_Write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;Silo.c,117 :: 		UART1_Write_Text("======");
	MOVLW       ?lstr5_Silo+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_Silo+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Silo.c,118 :: 		UART1_Write(10);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;Silo.c,119 :: 		UART1_Write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;Silo.c,120 :: 		}
L_end_AddLine:
	RETURN      0
; end of _AddLine
