#line 1 "C:/Users/lenovo/Desktop/MikroC full file/Roombacompletefile.c"
#line 30 "C:/Users/lenovo/Desktop/MikroC full file/Roombacompletefile.c"
void usDelay(unsigned int);
void msDelay1(unsigned int);
void msDelay2(unsigned int);
unsigned int T1overflow;
unsigned int Total;
void interrupt(void){
 if(INTCON&0x01){
 INTCON=INTCON&0xFE;
 }
 if(INTCON&0x02){
 PORTD = 0x00;
 msDelay2(500);
 PORTD = 0x99;
 msDelay2(1000);
 PORTD = 0xAA;
 INTCON=INTCON&0xFD;
 }
 if(PIR1&0x04){
 PIR1=PIR1&0xFB;
 }
 if(PIR1&0x01){
 T1overflow++;
 PIR1=PIR1&0xFE;
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
 INTCON = INTCON | 0xD0;
 PIE1=PIE1|0x01;
 T1CON=0x18;
 while(1){
 PORTD = 0xAA;


 T1overflow=0;
 TMR1H=0;
 TMR1L=0;
 PORTB=PORTB|0x04;
 usDelay(100);
 PORTB=PORTB&0xFB;
 while(!(PORTB&0x02));
 T1CON=0x19;
 while(PORTB&0x02);
 T1CON=0x18;
 Total=(TMR1H<<8)|TMR1L;
 if(Total<200){
 PORTD = 0x00;
 msDelay1(500);
 PORTD = 0x99;
 msDelay1(1000);
 }
 PORTD = 0xAA;


 T1overflow=0;
 TMR1H=0;
 TMR1L=0;
 PORTC=PORTC|0x20;
 usDelay(100);
 PORTC=PORTC&0xDF;
 while(!(PORTB&0x08));
 T1CON=0x19;
 while(PORTB&0x08);
 T1CON=0x18;
 Total=(TMR1H<<8)|TMR1L;
 if(Total<200){
 PORTD = 0x00;
 msDelay1(500);
 PORTD = 0x99;
 msDelay1(1000);
 }
 PORTD = 0xAA;


 T1overflow=0;
 TMR1H=0;
 TMR1L=0;
 PORTC=PORTC|0x10;
 usDelay(100);
 PORTC=PORTC&0xEF;
 while(!(PORTC&0x08));
 T1CON=0x19;
 while(PORTC&0x08);
 T1CON=0x18;
 Total=(TMR1H<<8)|TMR1L;
 if(Total<200){
 PORTD = 0x00;
 msDelay1(500);
 PORTD = 0x66;
 msDelay1(1000);
 }
 PORTD = 0xAA;
 }
}
void usDelay(unsigned int usCnt){
 unsigned int us=0;
 for(us=0;us<usCnt;us++){
 asm NOP;
 asm NOP;
}}
void msDelay1(unsigned int msCnt){
 unsigned int ms=0;
 unsigned int cc=0;
 for(ms=0;ms<(msCnt);ms++){
 for(cc=0;cc<155;cc++);
}}
void msDelay2(unsigned int msCnt){
 unsigned int ms=0;
 unsigned int cc=0;
 for(ms=0;ms<(msCnt);ms++){
 for(cc=0;cc<155;cc++);
}}
