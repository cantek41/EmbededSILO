
_interrupt:

;Master485.c,10 :: 		void interrupt() {
;Master485.c,11 :: 		RS485Master_Receive(dat);
	MOVLW       _dat+0
	MOVWF       FARG_RS485Master_Receive_data_buffer+0 
	MOVLW       hi_addr(_dat+0)
	MOVWF       FARG_RS485Master_Receive_data_buffer+1 
	CALL        _RS485Master_Receive+0, 0
;Master485.c,12 :: 		}
L_end_interrupt:
L__interrupt12:
	RETFIE      1
; end of _interrupt

_main:

;Master485.c,14 :: 		void main() {
;Master485.c,17 :: 		PORTB  = 0;
	CLRF        PORTB+0 
;Master485.c,18 :: 		PORTD  = 0;
	CLRF        PORTD+0 
;Master485.c,19 :: 		TRISB  = 0;
	CLRF        TRISB+0 
;Master485.c,20 :: 		TRISD  = 0;
	CLRF        TRISD+0 
;Master485.c,23 :: 		UART1_Init(9600);                    // initialize UART1 module
	MOVLW       25
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Master485.c,24 :: 		Delay_ms(100);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	NOP
	NOP
;Master485.c,26 :: 		RS485Master_Init();                  // initialize MCU as Master
	CALL        _RS485Master_Init+0, 0
;Master485.c,27 :: 		dat[0] = 0x01;
	MOVLW       1
	MOVWF       _dat+0 
;Master485.c,28 :: 		dat[1] = 0xF0;
	MOVLW       240
	MOVWF       _dat+1 
;Master485.c,29 :: 		dat[2] = 0x0F;
	MOVLW       15
	MOVWF       _dat+2 
;Master485.c,30 :: 		dat[4] = 0;                          // ensure that message received flag is 0
	CLRF        _dat+4 
;Master485.c,31 :: 		dat[5] = 0;                          // ensure that error flag is 0
	CLRF        _dat+5 
;Master485.c,32 :: 		dat[6] = 0;
	CLRF        _dat+6 
;Master485.c,34 :: 		RS485Master_Send(dat,1,160);
	MOVLW       _dat+0
	MOVWF       FARG_RS485Master_Send_data_buffer+0 
	MOVLW       hi_addr(_dat+0)
	MOVWF       FARG_RS485Master_Send_data_buffer+1 
	MOVLW       1
	MOVWF       FARG_RS485Master_Send_datalen+0 
	MOVLW       160
	MOVWF       FARG_RS485Master_Send_slave_address+0 
	CALL        _RS485Master_Send+0, 0
;Master485.c,37 :: 		RCIE_bit = 1;                        // enable interrupt on UART1 receive
	BSF         RCIE_bit+0, BitPos(RCIE_bit+0) 
;Master485.c,38 :: 		TXIE_bit = 0;                        // disable interrupt on UART1 transmit
	BCF         TXIE_bit+0, BitPos(TXIE_bit+0) 
;Master485.c,39 :: 		PEIE_bit = 1;                        // enable peripheral interrupts
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;Master485.c,40 :: 		GIE_bit = 1;                         // enable all interrupts
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Master485.c,42 :: 		while (1){
L_main1:
;Master485.c,45 :: 		cnt++;
	MOVLW       1
	ADDWF       _cnt+0, 1 
	MOVLW       0
	ADDWFC      _cnt+1, 1 
	ADDWFC      _cnt+2, 1 
	ADDWFC      _cnt+3, 1 
;Master485.c,46 :: 		if (dat[5])  {                     // if an error detected, signal it
	MOVF        _dat+5, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main3
;Master485.c,47 :: 		PORTD = 0xAA;                    //   by setting portd to 0xAA
	MOVLW       170
	MOVWF       PORTD+0 
;Master485.c,48 :: 		}
L_main3:
;Master485.c,49 :: 		if (dat[4]) {                      // if message received successfully
	MOVF        _dat+4, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
;Master485.c,50 :: 		cnt = 0;
	CLRF        _cnt+0 
	CLRF        _cnt+1 
	CLRF        _cnt+2 
	CLRF        _cnt+3 
;Master485.c,51 :: 		dat[4] = 0;                      // clear message received flag
	CLRF        _dat+4 
;Master485.c,52 :: 		j = dat[3];
	MOVF        _dat+3, 0 
	MOVWF       _j+0 
;Master485.c,53 :: 		for (i = 1; i <= dat[3]; i++) {  // show data on PORTB
	MOVLW       1
	MOVWF       _i+0 
L_main5:
	MOVF        _i+0, 0 
	SUBWF       _dat+3, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main6
;Master485.c,54 :: 		PORTB = dat[i-1];
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
	MOVWF       PORTB+0 
;Master485.c,53 :: 		for (i = 1; i <= dat[3]; i++) {  // show data on PORTB
	INCF        _i+0, 1 
;Master485.c,57 :: 		}                                // increment received dat[0]
	GOTO        L_main5
L_main6:
;Master485.c,58 :: 		UART1_Write(10);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;Master485.c,59 :: 		UART1_Write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;Master485.c,60 :: 		dat[0] = dat[0]+1;
	INCF        _dat+0, 1 
;Master485.c,61 :: 		Delay_ms(1);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       75
	MOVWF       R13, 0
L_main8:
	DECFSZ      R13, 1, 1
	BRA         L_main8
	DECFSZ      R12, 1, 1
	BRA         L_main8
;Master485.c,62 :: 		RS485Master_Send(dat,1,160);
	MOVLW       _dat+0
	MOVWF       FARG_RS485Master_Send_data_buffer+0 
	MOVLW       hi_addr(_dat+0)
	MOVWF       FARG_RS485Master_Send_data_buffer+1 
	MOVLW       1
	MOVWF       FARG_RS485Master_Send_datalen+0 
	MOVLW       160
	MOVWF       FARG_RS485Master_Send_slave_address+0 
	CALL        _RS485Master_Send+0, 0
;Master485.c,64 :: 		}
L_main4:
;Master485.c,65 :: 		if (cnt > 100000) {
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	XORWF       _cnt+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main14
	MOVF        _cnt+2, 0 
	SUBLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main14
	MOVF        _cnt+1, 0 
	SUBLW       134
	BTFSS       STATUS+0, 2 
	GOTO        L__main14
	MOVF        _cnt+0, 0 
	SUBLW       160
L__main14:
	BTFSC       STATUS+0, 0 
	GOTO        L_main9
;Master485.c,66 :: 		PORTD ++;
	MOVF        PORTD+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       PORTD+0 
;Master485.c,67 :: 		cnt = 0;
	CLRF        _cnt+0 
	CLRF        _cnt+1 
	CLRF        _cnt+2 
	CLRF        _cnt+3 
;Master485.c,68 :: 		RS485Master_Send(dat,1,160);
	MOVLW       _dat+0
	MOVWF       FARG_RS485Master_Send_data_buffer+0 
	MOVLW       hi_addr(_dat+0)
	MOVWF       FARG_RS485Master_Send_data_buffer+1 
	MOVLW       1
	MOVWF       FARG_RS485Master_Send_datalen+0 
	MOVLW       160
	MOVWF       FARG_RS485Master_Send_slave_address+0 
	CALL        _RS485Master_Send+0, 0
;Master485.c,69 :: 		if (PORTD > 10)                  // if sending failed 10 times
	MOVF        PORTD+0, 0 
	SUBLW       10
	BTFSC       STATUS+0, 0 
	GOTO        L_main10
;Master485.c,70 :: 		RS485Master_Send(dat,1,50);    //   send message on broadcast address
	MOVLW       _dat+0
	MOVWF       FARG_RS485Master_Send_data_buffer+0 
	MOVLW       hi_addr(_dat+0)
	MOVWF       FARG_RS485Master_Send_data_buffer+1 
	MOVLW       1
	MOVWF       FARG_RS485Master_Send_datalen+0 
	MOVLW       50
	MOVWF       FARG_RS485Master_Send_slave_address+0 
	CALL        _RS485Master_Send+0, 0
L_main10:
;Master485.c,71 :: 		}
L_main9:
;Master485.c,72 :: 		}
	GOTO        L_main1
;Master485.c,75 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
