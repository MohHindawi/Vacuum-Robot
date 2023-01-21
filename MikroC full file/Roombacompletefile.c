      //RB0 - Input  - IR Sensor
//RB1 - Input  - Echo1
//RB2 - Output - Trigger1
//RB3 - Input  - Echo2
//RC5 - Output - Trigger2
//RC3 - Input  - Echo3
//RC4 - Output - Trigger3
//RD4 - Output - Motor1
//RD5 - Output - Motor1
//RD6 - Output - Motor2
//RD7 - Output - Motor2

//Forward:  0xAA
//Left:     0x66;
//Right:    0x99;
//Stop:     0x00;
//Backward: 0x55;

//HS oscillator
//WDT disabled
//PWRTEN disabled
//BOREN enabled
//LVP disabled (RB3 is digital I/O)
//CPD disabled
//DEBUG disabled
//Code Protect - None
//Write Protection - Off

#define _XTAL_FREQ 8000000
void usDelay(unsigned int);
void msDelay1(unsigned int);
void msDelay2(unsigned int);
unsigned int T1overflow;
unsigned int Total;
void interrupt(void){
    if(INTCON&0x01){
        INTCON=INTCON&0xFE;     //Clear RBIF
    }
    if(INTCON&0x02){
        PORTD = 0x00;           //STOP
        msDelay2(500);
        PORTD = 0x99;           //RIGHT
        msDelay2(1000);
        PORTD = 0xAA;           //FORWARD
        INTCON=INTCON&0xFD;     //Clear INTF
    }
    if(PIR1&0x04){
        PIR1=PIR1&0xFB;         //Clear CCP1IF
    }
    if(PIR1&0x01){
        T1overflow++;
        PIR1=PIR1&0xFE;         //Clear TMR1IF
    }
    PORTD = 0xAA;
}

void main() {
    TRISB = 0xAB;
    TRISD = 0x00;
    PORTB = 0x00;
    PORTD = 0xAA;
    TRISC = 0x08;
    PORTC = 0x00;
    INTCON = INTCON | 0xD0;     //Enable GIE, INTE, RBIE
    PIE1=PIE1|0x01;             //Enable TMR1 Overflow Interrupt
    T1CON=0x18;                 //TMR1 OFF
    while(1){
        PORTD = 0xAA;		//FORWARD

        //Sensor1 on leftside
        T1overflow=0;
        TMR1H=0;
        TMR1L=0;
        PORTB=PORTB|0x04;       //Trigger1 on
        usDelay(100);           //keep trigger for 100 usec
        PORTB=PORTB&0xFB;       //Trigger1 off
        while(!(PORTB&0x02));   //if Echo1 on
        T1CON=0x19;             //TMR1 ON
        while(PORTB&0x02);      //if Echo1 off
        T1CON=0x18;             //TMR1 OFF
        Total=(TMR1H<<8)|TMR1L;
        if(Total<200){
            PORTD = 0x00;       //STOP
            msDelay1(500);
            PORTD = 0x99;       //RIGHT
            msDelay1(1000);
	   }
        PORTD = 0xAA;       	//FORWARD

        //Sensor2 on middle
        T1overflow=0;
        TMR1H=0;
        TMR1L=0;
        PORTC=PORTC|0x20;       //Trigger2 on
        usDelay(100);           //keep trigger for 100 usec
        PORTC=PORTC&0xDF;       //Trigger2 off
        while(!(PORTB&0x08));   //if Echo2 on
        T1CON=0x19;             //TMR1 ON
        while(PORTB&0x08);      //if Echo2 off
        T1CON=0x18;             //TMR1 OFF
        Total=(TMR1H<<8)|TMR1L;
        if(Total<200){
            PORTD = 0x00;       //STOP
            msDelay1(500);
            PORTD = 0x99;       //RIGHT
            msDelay1(1000);
	   }
        PORTD = 0xAA;       	//FORWARD

        //Sensor3 on rightside
        T1overflow=0;
        TMR1H=0;
        TMR1L=0;
        PORTC=PORTC|0x10;       //Trigger3 on
        usDelay(100);           //keep trigger for 100 usec
        PORTC=PORTC&0xEF;       //Trigger3 off
        while(!(PORTC&0x08));   //if Echo3 on
        T1CON=0x19;             //TMR1 ON
        while(PORTC&0x08);      //if Echo3 off
        T1CON=0x18;             //TMR1 OFF
        Total=(TMR1H<<8)|TMR1L;
        if(Total<200){
            PORTD = 0x00;       //STOP
            msDelay1(500);
            PORTD = 0x66;       //LEFT
            msDelay1(1000);
	   }
        PORTD = 0xAA;       	//FORWARD
    }
}
void usDelay(unsigned int usCnt){
    unsigned int us=0;
    for(us=0;us<usCnt;us++){
      asm NOP;//0.5uS
      asm NOP;//0.5uS
}}
void msDelay1(unsigned int msCnt){
    unsigned int ms=0;
    unsigned int cc=0;
    for(ms=0;ms<(msCnt);ms++){
    for(cc=0;cc<155;cc++);//1ms
}}
void msDelay2(unsigned int msCnt){
    unsigned int ms=0;
    unsigned int cc=0;
    for(ms=0;ms<(msCnt);ms++){
    for(cc=0;cc<155;cc++);//1ms
}}