/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.6 
Automatic Program Generator
© Copyright 1998-2012 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :   SMART CANE 
Version :  2
Date    : 5/7/2017
Author  : NGUYEN THI HONG PHUC (Evaluation)V1.0 - SonSivRi.to
Company :   BME_IU
Comments:   MICRO PROJECT


Chip type               : ATmega32A
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32a.h>  
#include <math.h>
#include <delay.h>

#define  TRIGGER                   PORTD.5 
#define  ECHO_SRF05                PIND.2      
#define  DATA_REGISTER_EMPTY       (1<<UDRE)
#define     powf   pow
#define  ADC_VREF_TYPE              0x00

// define Ultrasound sensor
unsigned int timer1_value;
unsigned int i;
unsigned int sum_1=0,sum_2=0;
unsigned int distance[30];
unsigned int distance_1;
unsigned int distance_2;
unsigned long int value;
float  volts;

//define ADC for IR
unsigned char High_byte, Low_byte;
unsigned char USART_packet[4]={0};
unsigned char ADC[30]={0};
volatile unsigned char Byte_flag=0;
unsigned int ADC_read(unsigned char ADC_CHANNEL);

//define cho usart
void UART_putChar(char c );
void USART_init(void);
void UART_Printf(char *s);
void System_init(void);    
//void Speak(void);    CHUA SU DUNG

//LCD DEFINE

//Declare LCD
#define   LCD_RS  PORTB.0
#define   LCD_RW  PORTB.1 //PORTA1
#define   LCD_E   PORTB.2 //PORTA2   // enable LCD 

#define   LCD_B4  PORTB.4 //PORTA4
#define   LCD_B5  PORTB.5 //PORTA5
#define   LCD_B6  PORTB.6 //PORTA6
#define   LCD_B7  PORTB.7 //PORTA7

#define   LCD_data_out(data) (PORTB = (PORTB&0x0F)|((data<<4)&0xF0))

#define   MODE_4_BIT     0x28
#define   CLR_SCR        0x01
#define   DISP_ON        0x0C
#define   CURSOR_ON      0x0E
#define   CURSOR_HOME    0x80
#define   CURSOR_LINE1   0x80
#define   CURSOR_LINE2   0xC0


//hien thi len LCD
void LCD_Write_Nibble(char byte);
void LCD_Wait_Busy();
void LCD_Write_Cmd(char cmd);
void LCD_Write_Data(char chr);
void LCD_Putc(char c);
void LCD_GotoXY(unsigned char x, unsigned char y);
void LCD_Init();
void LCD_Write_Int(unsigned int integer );
void LCD_Printf(char *str);
void USART_1(void);
void USART_2(void);



// Declare your global variables here
void main(void)
{
    unsigned int timer_value=0;
    //Port A speaking
    PORTA=0x00;
    DDRA=0xff;
    // Port D sensor
    PORTD=0xff;
    DDRD=0xf0; 
    // PORTB Declare LCD 
    PORTB=0x00;
    DDRB=0x00; 
    //portc-analog-IR
    PORTC=0x00;
    DDRC=0xff;
    //system init
    System_init(); 
    //LCD init
    LCD_Init(); 
    //usart_init
    USART_init() ;
    //UART_Printf(" \nnguyen hong phuc");  
    LCD_Printf("DISTANCE: (cm)"); 
    
 while (1)
      {    
        TCNT1 = 0;  //reset timer
        TRIGGER=1;
        delay_ms(10);     // tao 1 xung tren chan Trig toi thieu 10us
        TRIGGER=0;
        UART_putChar(1);     
        while(!ECHO_SRF05);          //doi chan echo duoc keo len cao  
        UART_putChar(2);          
        TCCR1B=0x02;                      // khoi dong timer scale /8
        while(ECHO_SRF05)                 // while echo pin is still high
        {   
         if(timer_value>34560)
            {
            LCD_Printf("ECHO_ERROR");  
            delay_ms(2);
            
            }
        }            
        TCCR1B =0x00;      // stop timer
        timer_value=TCNT1;  
        UART_putChar(3);  
          
            //THU TRUYEN DISTANCE
           timer1_value = (float)timer_value/1.382400; // [do rong xung]=[so dao dong]*12*[chu ki thach anh]     
           distance[i] = timer1_value/58;  // van toc song sieu am: v = 343.2m/s = 0.03432cm/us  
           
           for(i=0;i<30;i++)
           {
           sum_1+=distance[i];
           } 
           distance_1=sum_1/30;
           //TRUYEN LEN LCD  
            LCD_GotoXY(8,1); 
            LCD_Write_Int(distance_1); 
           // USART_ULTRASOUND
            USART_1();
            while (timer_value>34560&&timer_value<=14)       //note de nho
                 {
                     Byte_flag=1;
                 }
       // IR_ULTRASOUND
      if(Byte_flag==1)
            {      
                 delay_ms(10);
                 ADC[i]=(float)ADC_read(0);     
                 delay_ms(100); 
            }
        Byte_flag=0;   
        for(i=0;i<30;i++)
        {
        sum_2+=ADC[i];
        LCD_Write_Cmd(CLR_SCR);
        } 
        value=sum_2/30;  
        volts= (long int)(value*5)/1024 ; //ADC 10 bits
        distance_2= 65*(pow(volts,-1.1))  ;  
        // USART_ULTRASOUND    
            USART_2();
       //TRUYEN LEN LCD 
           LCD_GotoXY(8,1); 
           LCD_Write_Int(distance_2); 
           
 } 
 }
 
// READ ADC VALUE
unsigned int ADC_read(unsigned char ADC_CHANNEL)
{
//  chon dien ap tham chieu va kenh can doc
ADMUX= ADC_VREF_TYPE|ADC_CHANNEL;
delay_us(10);
// Start conversation
ADCSRA|=0x40;    
// wait for conversation end  (ADIF bit=1)   
while ((ADCSRA&0x10)==0);
//   ADC  WORD = ADCH+ADCL 
ADCSRA|=0x10;
return ADCW ; 
}

 
void USART_init(void)
{
// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x47;
}



#pragma used+
void UART_putChar(char c)
{
    while ((UCSRA & DATA_REGISTER_EMPTY)==0);
    UDR=c;
}

#pragma used-

void UART_Printf(char *s)       //DE TEST CHUONG TRINH
{
    // loop through entire string
    while (*s) 
    {
        UART_putChar(*s);
        delay_ms(20);
        s++;
    }
}


void LCD_Putc(char c)
{
   switch (c)
   
        //without "break" can't continue next step
   {  
      case '\f'   :  LCD_Write_Cmd(CLR_SCR);
                     delay_us(2);
                     break;   
                     
      // xuong dong               
      case '\n'   :  LCD_Write_Cmd(CURSOR_LINE2); 
                     break;
      
      // dich con tro
      case '\b'   :  LCD_Write_Cmd(0x10);  
                     break;
     
      default     :  LCD_Write_Data(c);     
                     break;
   }
}

void LCD_Printf(char *str)
{
    int i=0;
    while(str[i]!='\0')      // loop will go on till the NULL character in the string
    {
        delay_us(50);
        LCD_Putc(str[i]);    // sending data on LCD byte by byte
        i++;
    }
}

void LCD_Write_Int(unsigned int integer )
{
    unsigned char thousands,hundreds,tens,ones; 
    
    thousands = integer / 1000;
    LCD_Write_Data(thousands + 0x30);
    
    hundreds = ((integer - thousands*1000)) / 100;
    LCD_Write_Data(hundreds + 0x30); 
    
    tens=(integer%100)/10;
    LCD_Write_Data(tens + 0x30);
    
    ones=integer%10;
    LCD_Write_Data(ones + 0x30);
}

void LCD_Write_Nibble(char byte)
{
       LCD_E = 1;
    LCD_data_out(byte);
    LCD_E = 0;
}
// wait + read LCD
void LCD_Wait_Busy()
{
    unsigned char tempH,tempL;
    PORTB |= 0xF0;          // SET 4 BIT DATA (thap) duoc su dung
    LCD_RS = 0;             // 0 = Instruction input, 1 = Data input        
    LCD_RW = 1;             // 0 = Write to LCD module,1 = Read from LCD module       

    do 
    {   // che do 4 bit se truyen va nhan nibble cao truoc (thap sau)
        LCD_E = 1;          //che do 4 bit phai doc 2 lan 
        delay_us(2);
        DDRB  = 0x0f;        //set 4 bit cao cua PORTD LAM input     (doc ve)
        tempH = PINB;       //read in upper nybble  
        DDRB  = 0xff;       //out put (xuat ra LCD)
        LCD_E = 0;          //busy_flag
        delay_us(2);  
       // ==============================
       //không có phan nay khong hien LCD
        LCD_E = 1;                  
        delay_us(2);
        DDRB  = 0x0f;
        tempL = PINB;       //read in lower nybble.  
        DDRB  = 0xff;                    
        LCD_E = 0;          //BF = 1 is busy
        delay_us(2);
    } while (tempH&0x80);   //bit cuoi la busy
}

void LCD_Write_Cmd(char cmd)
{
    LCD_Wait_Busy();
    LCD_RS = 0;               // 0 = Instruction input
    LCD_RW = 0;               // 0 = Write to LCD module
    LCD_Write_Nibble(cmd>>4);  // send high byte first
    LCD_Write_Nibble(cmd);
}

void LCD_Write_Data(char chr)
{ 
    LCD_Wait_Busy();
    LCD_RS = 1;                    // 1 = Data input
    LCD_RW = 0;                    // 0 = Write to LCD module
    LCD_Write_Nibble(chr>>4);     // nibble cao truoc
    LCD_Write_Nibble(chr);    
}

void LCD_Init()
{
    LCD_RS = 0;
    LCD_RW = 0;
    LCD_Write_Nibble(MODE_4_BIT>>4);   //lan dau tien truyen du lieu, LCD mac dinh la` 8 bit
    LCD_Write_Cmd(MODE_4_BIT);         //nen phai set function 2 lan de dieu chinh theo che do
    LCD_Write_Cmd(DISP_ON);            //mong muon: 4 bit, 2 line, 5x7 dot
    //LCD_Write_Cmd(CURSOR_ON);        // tat con 
    LCD_Write_Cmd(CLR_SCR);
}


void LCD_GotoXY(unsigned char x, unsigned char y)
{
    if(x<40) 
    
    {   
    //Sets the specified value (AAAAAA) into the address counter
      if(y) x |= 0x40;    //0x40:  64D
      // di chuyen toi vi tri mong muon neu y=0 (DDRAM)
      x |=0x80; 
      LCD_Write_Cmd(x);
    }
}

void USART_1(void)
{
            //USART TRANMISTER
            USART_packet[0]=0x55;
            USART_packet[1]=0xaa;
            High_byte=(distance_1&0xff00)>>8; 
            Low_byte=(distance_1&0x00ff);
            USART_packet[2]=High_byte;
            USART_packet[3]=Low_byte; 
            
            for (i=0;i<4;i++)
            {
            UART_putChar(USART_packet[i]);
            }  
}
void USART_2(void)
{
   //USART TRANMISTER
            USART_packet[0]=0x55;
            USART_packet[1]=0xaa;
            High_byte=(distance_2&0xff00)>>8; 
            Low_byte=(distance_2&0x00ff);
            USART_packet[2]=High_byte;
            USART_packet[3]=Low_byte; 
            
            for (i=0;i<4;i++)
            {
            UART_putChar(USART_packet[i]);
            }        
}

void System_init(void)
{
    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 1382.400 kHz
    // Mode: Normal top=0xFFFF
    // OC1A output: Discon.
    // OC1B output: Discon.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=0x00;
    TCCR1B=0x00;//0x02;
    TCNT1=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00; 
    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x00;
    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR=0x80;
    SFIOR=0x00;
}

//void Speak(void)
//{
////SPEAKING     
//           if(distance==10)      
//           {
//                for(index=0;index<4;index++)
//                    {   
//                        //SPEAKING 
//                        PORTA;
//
//                    }  
//           }      
//        else if(distance==20)
//        {
//                for(index=0;index<4;index++)
//                      {    
//                       //SPEAKING 
//                        PORTA;
//                                        
//        } 
//       else if (distance==50)   
//       {     
//            for(index=0;index<4;index++)
//               {
//               //SPEAKING 
//                 PORTA ;
//               }
//                
//
//      }
//}
//}






