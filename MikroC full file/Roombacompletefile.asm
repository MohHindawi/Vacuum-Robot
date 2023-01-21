
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Roombacompletefile.c,35 :: 		void interrupt(void){
;Roombacompletefile.c,36 :: 		if(INTCON&0x01){
	BTFSS      INTCON+0, 0
	GOTO       L_interrupt0
;Roombacompletefile.c,37 :: 		INTCON=INTCON&0xFE;     //Clear RBIF
	MOVLW      254
	ANDWF      INTCON+0, 1
;Roombacompletefile.c,38 :: 		}
L_interrupt0:
;Roombacompletefile.c,39 :: 		if(INTCON&0x02){
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt1
;Roombacompletefile.c,40 :: 		PORTD = 0x00;           //STOP
	CLRF       PORTD+0
;Roombacompletefile.c,41 :: 		msDelay2(500);
	MOVLW      244
	MOVWF      FARG_msDelay2+0
	MOVLW      1
	MOVWF      FARG_msDelay2+1
	CALL       _msDelay2+0
;Roombacompletefile.c,42 :: 		PORTD = 0x99;           //RIGHT
	MOVLW      153
	MOVWF      PORTD+0
;Roombacompletefile.c,43 :: 		msDelay2(1000);
	MOVLW      232
	MOVWF      FARG_msDelay2+0
	MOVLW      3
	MOVWF      FARG_msDelay2+1
	CALL       _msDelay2+0
;Roombacompletefile.c,44 :: 		PORTD = 0xAA;           //FORWARD
	MOVLW      170
	MOVWF      PORTD+0
;Roombacompletefile.c,45 :: 		INTCON=INTCON&0xFD;     //Clear INTF
	MOVLW      253
	ANDWF      INTCON+0, 1
;Roombacompletefile.c,46 :: 		}
L_interrupt1:
;Roombacompletefile.c,47 :: 		if(PIR1&0x04){
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt2
;Roombacompletefile.c,48 :: 		PIR1=PIR1&0xFB;         //Clear CCP1IF
	MOVLW      251
	ANDWF      PIR1+0, 1
;Roombacompletefile.c,49 :: 		}
L_interrupt2:
;Roombacompletefile.c,50 :: 		if(PIR1&0x01){
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt3
;Roombacompletefile.c,51 :: 		T1overflow++;
	INCF       _T1overflow+0, 1
	BTFSC      STATUS+0, 2
	INCF       _T1overflow+1, 1
;Roombacompletefile.c,52 :: 		PIR1=PIR1&0xFE;         //Clear TMR1IF
	MOVLW      254
	ANDWF      PIR1+0, 1
;Roombacompletefile.c,53 :: 		}
L_interrupt3:
;Roombacompletefile.c,54 :: 		PORTD = 0xAA;
	MOVLW      170
	MOVWF      PORTD+0
;Roombacompletefile.c,55 :: 		}
L_end_interrupt:
L__interrupt37:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Roombacompletefile.c,57 :: 		void main() {
;Roombacompletefile.c,58 :: 		TRISB = 0xAB;
	MOVLW      171
	MOVWF      TRISB+0
;Roombacompletefile.c,59 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;Roombacompletefile.c,60 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;Roombacompletefile.c,61 :: 		PORTD = 0xAA;
	MOVLW      170
	MOVWF      PORTD+0
;Roombacompletefile.c,62 :: 		TRISC = 0x08;
	MOVLW      8
	MOVWF      TRISC+0
;Roombacompletefile.c,63 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;Roombacompletefile.c,64 :: 		INTCON = INTCON | 0xD0;     //Enable GIE, INTE, RBIE
	MOVLW      208
	IORWF      INTCON+0, 1
;Roombacompletefile.c,65 :: 		PIE1=PIE1|0x01;             //Enable TMR1 Overflow Interrupt
	BSF        PIE1+0, 0
;Roombacompletefile.c,66 :: 		T1CON=0x18;                 //TMR1 OFF
	MOVLW      24
	MOVWF      T1CON+0
;Roombacompletefile.c,67 :: 		while(1){
L_main4:
;Roombacompletefile.c,68 :: 		PORTD = 0xAA;		//FORWARD
	MOVLW      170
	MOVWF      PORTD+0
;Roombacompletefile.c,71 :: 		T1overflow=0;
	CLRF       _T1overflow+0
	CLRF       _T1overflow+1
;Roombacompletefile.c,72 :: 		TMR1H=0;
	CLRF       TMR1H+0
;Roombacompletefile.c,73 :: 		TMR1L=0;
	CLRF       TMR1L+0
;Roombacompletefile.c,74 :: 		PORTB=PORTB|0x04;       //Trigger1 on
	BSF        PORTB+0, 2
;Roombacompletefile.c,75 :: 		usDelay(100);           //keep trigger for 100 usec
	MOVLW      100
	MOVWF      FARG_usDelay+0
	MOVLW      0
	MOVWF      FARG_usDelay+1
	CALL       _usDelay+0
;Roombacompletefile.c,76 :: 		PORTB=PORTB&0xFB;       //Trigger1 off
	MOVLW      251
	ANDWF      PORTB+0, 1
;Roombacompletefile.c,77 :: 		while(!(PORTB&0x02));   //if Echo1 on
L_main6:
	BTFSC      PORTB+0, 1
	GOTO       L_main7
	GOTO       L_main6
L_main7:
;Roombacompletefile.c,78 :: 		T1CON=0x19;             //TMR1 ON
	MOVLW      25
	MOVWF      T1CON+0
;Roombacompletefile.c,79 :: 		while(PORTB&0x02);      //if Echo1 off
L_main8:
	BTFSS      PORTB+0, 1
	GOTO       L_main9
	GOTO       L_main8
L_main9:
;Roombacompletefile.c,80 :: 		T1CON=0x18;             //TMR1 OFF
	MOVLW      24
	MOVWF      T1CON+0
;Roombacompletefile.c,81 :: 		Total=(TMR1H<<8)|TMR1L;
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	MOVWF      R2+1
	MOVLW      0
	IORWF      R2+1, 1
	MOVF       R2+0, 0
	MOVWF      _Total+0
	MOVF       R2+1, 0
	MOVWF      _Total+1
;Roombacompletefile.c,82 :: 		if(Total<200){
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main39
	MOVLW      200
	SUBWF      R2+0, 0
L__main39:
	BTFSC      STATUS+0, 0
	GOTO       L_main10
;Roombacompletefile.c,83 :: 		PORTD = 0x00;       //STOP
	CLRF       PORTD+0
;Roombacompletefile.c,84 :: 		msDelay1(500);
	MOVLW      244
	MOVWF      FARG_msDelay1+0
	MOVLW      1
	MOVWF      FARG_msDelay1+1
	CALL       _msDelay1+0
;Roombacompletefile.c,85 :: 		PORTD = 0x99;       //RIGHT
	MOVLW      153
	MOVWF      PORTD+0
;Roombacompletefile.c,86 :: 		msDelay1(1000);
	MOVLW      232
	MOVWF      FARG_msDelay1+0
	MOVLW      3
	MOVWF      FARG_msDelay1+1
	CALL       _msDelay1+0
;Roombacompletefile.c,87 :: 		}
L_main10:
;Roombacompletefile.c,88 :: 		PORTD = 0xAA;       	//FORWARD
	MOVLW      170
	MOVWF      PORTD+0
;Roombacompletefile.c,91 :: 		T1overflow=0;
	CLRF       _T1overflow+0
	CLRF       _T1overflow+1
;Roombacompletefile.c,92 :: 		TMR1H=0;
	CLRF       TMR1H+0
;Roombacompletefile.c,93 :: 		TMR1L=0;
	CLRF       TMR1L+0
;Roombacompletefile.c,94 :: 		PORTC=PORTC|0x20;       //Trigger2 on
	BSF        PORTC+0, 5
;Roombacompletefile.c,95 :: 		usDelay(100);           //keep trigger for 100 usec
	MOVLW      100
	MOVWF      FARG_usDelay+0
	MOVLW      0
	MOVWF      FARG_usDelay+1
	CALL       _usDelay+0
;Roombacompletefile.c,96 :: 		PORTC=PORTC&0xDF;       //Trigger2 off
	MOVLW      223
	ANDWF      PORTC+0, 1
;Roombacompletefile.c,97 :: 		while(!(PORTB&0x08));   //if Echo2 on
L_main11:
	BTFSC      PORTB+0, 3
	GOTO       L_main12
	GOTO       L_main11
L_main12:
;Roombacompletefile.c,98 :: 		T1CON=0x19;             //TMR1 ON
	MOVLW      25
	MOVWF      T1CON+0
;Roombacompletefile.c,99 :: 		while(PORTB&0x08);      //if Echo2 off
L_main13:
	BTFSS      PORTB+0, 3
	GOTO       L_main14
	GOTO       L_main13
L_main14:
;Roombacompletefile.c,100 :: 		T1CON=0x18;             //TMR1 OFF
	MOVLW      24
	MOVWF      T1CON+0
;Roombacompletefile.c,101 :: 		Total=(TMR1H<<8)|TMR1L;
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	MOVWF      R2+1
	MOVLW      0
	IORWF      R2+1, 1
	MOVF       R2+0, 0
	MOVWF      _Total+0
	MOVF       R2+1, 0
	MOVWF      _Total+1
;Roombacompletefile.c,102 :: 		if(Total<200){
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main40
	MOVLW      200
	SUBWF      R2+0, 0
L__main40:
	BTFSC      STATUS+0, 0
	GOTO       L_main15
;Roombacompletefile.c,103 :: 		PORTD = 0x00;       //STOP
	CLRF       PORTD+0
;Roombacompletefile.c,104 :: 		msDelay1(500);
	MOVLW      244
	MOVWF      FARG_msDelay1+0
	MOVLW      1
	MOVWF      FARG_msDelay1+1
	CALL       _msDelay1+0
;Roombacompletefile.c,105 :: 		PORTD = 0x99;       //RIGHT
	MOVLW      153
	MOVWF      PORTD+0
;Roombacompletefile.c,106 :: 		msDelay1(1000);
	MOVLW      232
	MOVWF      FARG_msDelay1+0
	MOVLW      3
	MOVWF      FARG_msDelay1+1
	CALL       _msDelay1+0
;Roombacompletefile.c,107 :: 		}
L_main15:
;Roombacompletefile.c,108 :: 		PORTD = 0xAA;       	//FORWARD
	MOVLW      170
	MOVWF      PORTD+0
;Roombacompletefile.c,111 :: 		T1overflow=0;
	CLRF       _T1overflow+0
	CLRF       _T1overflow+1
;Roombacompletefile.c,112 :: 		TMR1H=0;
	CLRF       TMR1H+0
;Roombacompletefile.c,113 :: 		TMR1L=0;
	CLRF       TMR1L+0
;Roombacompletefile.c,114 :: 		PORTC=PORTC|0x10;       //Trigger3 on
	BSF        PORTC+0, 4
;Roombacompletefile.c,115 :: 		usDelay(100);           //keep trigger for 100 usec
	MOVLW      100
	MOVWF      FARG_usDelay+0
	MOVLW      0
	MOVWF      FARG_usDelay+1
	CALL       _usDelay+0
;Roombacompletefile.c,116 :: 		PORTC=PORTC&0xEF;       //Trigger3 off
	MOVLW      239
	ANDWF      PORTC+0, 1
;Roombacompletefile.c,117 :: 		while(!(PORTC&0x08));   //if Echo3 on
L_main16:
	BTFSC      PORTC+0, 3
	GOTO       L_main17
	GOTO       L_main16
L_main17:
;Roombacompletefile.c,118 :: 		T1CON=0x19;             //TMR1 ON
	MOVLW      25
	MOVWF      T1CON+0
;Roombacompletefile.c,119 :: 		while(PORTC&0x08);      //if Echo3 off
L_main18:
	BTFSS      PORTC+0, 3
	GOTO       L_main19
	GOTO       L_main18
L_main19:
;Roombacompletefile.c,120 :: 		T1CON=0x18;             //TMR1 OFF
	MOVLW      24
	MOVWF      T1CON+0
;Roombacompletefile.c,121 :: 		Total=(TMR1H<<8)|TMR1L;
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	MOVWF      R2+1
	MOVLW      0
	IORWF      R2+1, 1
	MOVF       R2+0, 0
	MOVWF      _Total+0
	MOVF       R2+1, 0
	MOVWF      _Total+1
;Roombacompletefile.c,122 :: 		if(Total<200){
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main41
	MOVLW      200
	SUBWF      R2+0, 0
L__main41:
	BTFSC      STATUS+0, 0
	GOTO       L_main20
;Roombacompletefile.c,123 :: 		PORTD = 0x00;       //STOP
	CLRF       PORTD+0
;Roombacompletefile.c,124 :: 		msDelay1(500);
	MOVLW      244
	MOVWF      FARG_msDelay1+0
	MOVLW      1
	MOVWF      FARG_msDelay1+1
	CALL       _msDelay1+0
;Roombacompletefile.c,125 :: 		PORTD = 0x66;       //LEFT
	MOVLW      102
	MOVWF      PORTD+0
;Roombacompletefile.c,126 :: 		msDelay1(1000);
	MOVLW      232
	MOVWF      FARG_msDelay1+0
	MOVLW      3
	MOVWF      FARG_msDelay1+1
	CALL       _msDelay1+0
;Roombacompletefile.c,127 :: 		}
L_main20:
;Roombacompletefile.c,128 :: 		PORTD = 0xAA;       	//FORWARD
	MOVLW      170
	MOVWF      PORTD+0
;Roombacompletefile.c,129 :: 		}
	GOTO       L_main4
;Roombacompletefile.c,130 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_usDelay:

;Roombacompletefile.c,131 :: 		void usDelay(unsigned int usCnt){
;Roombacompletefile.c,132 :: 		unsigned int us=0;
	CLRF       usDelay_us_L0+0
	CLRF       usDelay_us_L0+1
;Roombacompletefile.c,133 :: 		for(us=0;us<usCnt;us++){
	CLRF       usDelay_us_L0+0
	CLRF       usDelay_us_L0+1
L_usDelay21:
	MOVF       FARG_usDelay_usCnt+1, 0
	SUBWF      usDelay_us_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__usDelay43
	MOVF       FARG_usDelay_usCnt+0, 0
	SUBWF      usDelay_us_L0+0, 0
L__usDelay43:
	BTFSC      STATUS+0, 0
	GOTO       L_usDelay22
;Roombacompletefile.c,134 :: 		asm NOP;//0.5uS
	NOP
;Roombacompletefile.c,135 :: 		asm NOP;//0.5uS
	NOP
;Roombacompletefile.c,133 :: 		for(us=0;us<usCnt;us++){
	INCF       usDelay_us_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       usDelay_us_L0+1, 1
;Roombacompletefile.c,136 :: 		}}
	GOTO       L_usDelay21
L_usDelay22:
L_end_usDelay:
	RETURN
; end of _usDelay

_msDelay1:

;Roombacompletefile.c,137 :: 		void msDelay1(unsigned int msCnt){
;Roombacompletefile.c,138 :: 		unsigned int ms=0;
	CLRF       msDelay1_ms_L0+0
	CLRF       msDelay1_ms_L0+1
	CLRF       msDelay1_cc_L0+0
	CLRF       msDelay1_cc_L0+1
;Roombacompletefile.c,140 :: 		for(ms=0;ms<(msCnt);ms++){
	CLRF       msDelay1_ms_L0+0
	CLRF       msDelay1_ms_L0+1
L_msDelay124:
	MOVF       FARG_msDelay1_msCnt+1, 0
	SUBWF      msDelay1_ms_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay145
	MOVF       FARG_msDelay1_msCnt+0, 0
	SUBWF      msDelay1_ms_L0+0, 0
L__msDelay145:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay125
;Roombacompletefile.c,141 :: 		for(cc=0;cc<155;cc++);//1ms
	CLRF       msDelay1_cc_L0+0
	CLRF       msDelay1_cc_L0+1
L_msDelay127:
	MOVLW      0
	SUBWF      msDelay1_cc_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay146
	MOVLW      155
	SUBWF      msDelay1_cc_L0+0, 0
L__msDelay146:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay128
	INCF       msDelay1_cc_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay1_cc_L0+1, 1
	GOTO       L_msDelay127
L_msDelay128:
;Roombacompletefile.c,140 :: 		for(ms=0;ms<(msCnt);ms++){
	INCF       msDelay1_ms_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay1_ms_L0+1, 1
;Roombacompletefile.c,142 :: 		}}
	GOTO       L_msDelay124
L_msDelay125:
L_end_msDelay1:
	RETURN
; end of _msDelay1

_msDelay2:

;Roombacompletefile.c,143 :: 		void msDelay2(unsigned int msCnt){
;Roombacompletefile.c,144 :: 		unsigned int ms=0;
	CLRF       msDelay2_ms_L0+0
	CLRF       msDelay2_ms_L0+1
	CLRF       msDelay2_cc_L0+0
	CLRF       msDelay2_cc_L0+1
;Roombacompletefile.c,146 :: 		for(ms=0;ms<(msCnt);ms++){
	CLRF       msDelay2_ms_L0+0
	CLRF       msDelay2_ms_L0+1
L_msDelay230:
	MOVF       FARG_msDelay2_msCnt+1, 0
	SUBWF      msDelay2_ms_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay248
	MOVF       FARG_msDelay2_msCnt+0, 0
	SUBWF      msDelay2_ms_L0+0, 0
L__msDelay248:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay231
;Roombacompletefile.c,147 :: 		for(cc=0;cc<155;cc++);//1ms
	CLRF       msDelay2_cc_L0+0
	CLRF       msDelay2_cc_L0+1
L_msDelay233:
	MOVLW      0
	SUBWF      msDelay2_cc_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay249
	MOVLW      155
	SUBWF      msDelay2_cc_L0+0, 0
L__msDelay249:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay234
	INCF       msDelay2_cc_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay2_cc_L0+1, 1
	GOTO       L_msDelay233
L_msDelay234:
;Roombacompletefile.c,146 :: 		for(ms=0;ms<(msCnt);ms++){
	INCF       msDelay2_ms_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay2_ms_L0+1, 1
;Roombacompletefile.c,148 :: 		}}
	GOTO       L_msDelay230
L_msDelay231:
L_end_msDelay2:
	RETURN
; end of _msDelay2
