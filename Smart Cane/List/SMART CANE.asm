
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32A
;Program type             : Application
;Clock frequency          : 11.059200 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _timer1_value=R4
	.DEF _i=R6
	.DEF _sum_1=R8
	.DEF _sum_2=R10
	.DEF _distance_1=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x59:
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x44,0x49,0x53,0x54,0x41,0x4E,0x43,0x45
	.DB  0x3A,0x20,0x28,0x63,0x6D,0x29,0x0,0x45
	.DB  0x43,0x48,0x4F,0x5F,0x45,0x52,0x52,0x4F
	.DB  0x52,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0F
	.DW  _0x3
	.DW  _0x0*2

	.DW  0x0B
	.DW  _0x3+15
	.DW  _0x0*2+15

	.DW  0x04
	.DW  0x08
	.DW  _0x59*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.6
;Automatic Program Generator
;© Copyright 1998-2012 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :   SMART CANE
;Version :  2
;Date    : 5/7/2017
;Author  : NGUYEN THI HONG PHUC (Evaluation)V1.0 - SonSivRi.to
;Company :   BME_IU
;Comments:   MICRO PROJECT
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <math.h>
;#include <delay.h>
;
;#define  TRIGGER                   PORTD.5
;#define  ECHO_SRF05                PIND.2
;#define  DATA_REGISTER_EMPTY       (1<<UDRE)
;#define     powf   pow
;#define  ADC_VREF_TYPE              0x00
;
;// define Ultrasound sensor
;unsigned int timer1_value;
;unsigned int i;
;unsigned int sum_1=0,sum_2=0;
;unsigned int distance[30];
;unsigned int distance_1;
;unsigned int distance_2;
;unsigned long int value;
;float  volts;
;
;//define ADC for IR
;unsigned char High_byte, Low_byte;
;unsigned char USART_packet[4]={0};
;unsigned char ADC[30]={0};
;volatile unsigned char Byte_flag=0;
;unsigned int ADC_read(unsigned char ADC_CHANNEL);
;
;//define cho usart
;void UART_putChar(char c );
;void USART_init(void);
;void UART_Printf(char *s);
;void System_init(void);
;//void Speak(void);    CHUA SU DUNG
;
;//LCD DEFINE
;
;//Declare LCD
;#define   LCD_RS  PORTB.0
;#define   LCD_RW  PORTB.1 //PORTA1
;#define   LCD_E   PORTB.2 //PORTA2   // enable LCD
;
;#define   LCD_B4  PORTB.4 //PORTA4
;#define   LCD_B5  PORTB.5 //PORTA5
;#define   LCD_B6  PORTB.6 //PORTA6
;#define   LCD_B7  PORTB.7 //PORTA7
;
;#define   LCD_data_out(data) (PORTB = (PORTB&0x0F)|((data<<4)&0xF0))
;
;#define   MODE_4_BIT     0x28
;#define   CLR_SCR        0x01
;#define   DISP_ON        0x0C
;#define   CURSOR_ON      0x0E
;#define   CURSOR_HOME    0x80
;#define   CURSOR_LINE1   0x80
;#define   CURSOR_LINE2   0xC0
;
;
;//hien thi len LCD
;void LCD_Write_Nibble(char byte);
;void LCD_Wait_Busy();
;void LCD_Write_Cmd(char cmd);
;void LCD_Write_Data(char chr);
;void LCD_Putc(char c);
;void LCD_GotoXY(unsigned char x, unsigned char y);
;void LCD_Init();
;void LCD_Write_Int(unsigned int integer );
;void LCD_Printf(char *str);
;void USART_1(void);
;void USART_2(void);
;
;
;
;// Declare your global variables here
;void main(void)
; 0000 0062 {

	.CSEG
_main:
; 0000 0063     unsigned int timer_value=0;
; 0000 0064     //Port A speaking
; 0000 0065     PORTA=0x00;
;	timer_value -> R16,R17
	__GETWRN 16,17,0
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0066     DDRA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0067     // Port D sensor
; 0000 0068     PORTD=0xff;
	OUT  0x12,R30
; 0000 0069     DDRD=0xf0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 006A     // PORTB Declare LCD
; 0000 006B     PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 006C     DDRB=0x00;
	OUT  0x17,R30
; 0000 006D     //portc-analog-IR
; 0000 006E     PORTC=0x00;
	OUT  0x15,R30
; 0000 006F     DDRC=0xff;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0070     //system init
; 0000 0071     System_init();
	RCALL _System_init
; 0000 0072     //LCD init
; 0000 0073     LCD_Init();
	RCALL _LCD_Init
; 0000 0074     //usart_init
; 0000 0075     USART_init() ;
	RCALL _USART_init
; 0000 0076     //UART_Printf(" \nnguyen hong phuc");
; 0000 0077     LCD_Printf("DISTANCE: (cm)");
	__POINTW1MN _0x3,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _LCD_Printf
; 0000 0078 
; 0000 0079  while (1)
_0x4:
; 0000 007A       {
; 0000 007B         TCNT1 = 0;  //reset timer
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 007C         TRIGGER=1;
	SBI  0x12,5
; 0000 007D         delay_ms(10);     // tao 1 xung tren chan Trig toi thieu 10us
	CALL SUBOPT_0x0
; 0000 007E         TRIGGER=0;
	CBI  0x12,5
; 0000 007F         UART_putChar(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _UART_putChar
; 0000 0080         while(!ECHO_SRF05);          //doi chan echo duoc keo len cao
_0xB:
	SBIS 0x10,2
	RJMP _0xB
; 0000 0081         UART_putChar(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _UART_putChar
; 0000 0082         TCCR1B=0x02;                      // khoi dong timer scale /8
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 0083         while(ECHO_SRF05)                 // while echo pin is still high
_0xE:
	SBIS 0x10,2
	RJMP _0x10
; 0000 0084         {
; 0000 0085          if(timer_value>34560)
	__CPWRN 16,17,-30975
	BRLO _0x11
; 0000 0086             {
; 0000 0087             LCD_Printf("ECHO_ERROR");
	__POINTW1MN _0x3,15
	ST   -Y,R31
	ST   -Y,R30
	RCALL _LCD_Printf
; 0000 0088             delay_ms(2);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0089 
; 0000 008A             }
; 0000 008B         }
_0x11:
	RJMP _0xE
_0x10:
; 0000 008C         TCCR1B =0x00;      // stop timer
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 008D         timer_value=TCNT1;
	__INWR 16,17,44
; 0000 008E         UART_putChar(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _UART_putChar
; 0000 008F 
; 0000 0090             //THU TRUYEN DISTANCE
; 0000 0091            timer1_value = (float)timer_value/1.382400; // [do rong xung]=[so dao dong]*12*[chu ki thach anh]
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3FB0F27C
	CALL __DIVF21
	CALL __CFD1U
	MOVW R4,R30
; 0000 0092            distance[i] = timer1_value/58;  // van toc song sieu am: v = 343.2m/s = 0.03432cm/us
	MOVW R30,R6
	LDI  R26,LOW(_distance)
	LDI  R27,HIGH(_distance)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R26,R4
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	CALL __DIVW21U
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
; 0000 0093 
; 0000 0094            for(i=0;i<30;i++)
	CLR  R6
	CLR  R7
_0x13:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R6,R30
	CPC  R7,R31
	BRSH _0x14
; 0000 0095            {
; 0000 0096            sum_1+=distance[i];
	MOVW R30,R6
	LDI  R26,LOW(_distance)
	LDI  R27,HIGH(_distance)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	__ADDWRR 8,9,30,31
; 0000 0097            }
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0x13
_0x14:
; 0000 0098            distance_1=sum_1/30;
	MOVW R26,R8
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __DIVW21U
	MOVW R12,R30
; 0000 0099            //TRUYEN LEN LCD
; 0000 009A             LCD_GotoXY(8,1);
	CALL SUBOPT_0x1
; 0000 009B             LCD_Write_Int(distance_1);
	ST   -Y,R13
	ST   -Y,R12
	RCALL _LCD_Write_Int
; 0000 009C            // USART_ULTRASOUND
; 0000 009D             USART_1();
	RCALL _USART_1
; 0000 009E             while (timer_value>34560&&timer_value<=14)       //note de nho
_0x15:
	__CPWRN 16,17,-30975
	BRLO _0x18
	__CPWRN 16,17,15
	BRLO _0x19
_0x18:
	RJMP _0x17
_0x19:
; 0000 009F                  {
; 0000 00A0                      Byte_flag=1;
	LDI  R30,LOW(1)
	STS  _Byte_flag,R30
; 0000 00A1                  }
	RJMP _0x15
_0x17:
; 0000 00A2        // IR_ULTRASOUND
; 0000 00A3       if(Byte_flag==1)
	LDS  R26,_Byte_flag
	CPI  R26,LOW(0x1)
	BRNE _0x1A
; 0000 00A4             {
; 0000 00A5                  delay_ms(10);
	CALL SUBOPT_0x0
; 0000 00A6                  ADC[i]=(float)ADC_read(0);
	MOVW R30,R6
	SUBI R30,LOW(-_ADC)
	SBCI R31,HIGH(-_ADC)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _ADC_read
	CLR  R22
	CLR  R23
	CALL __CDF1
	POP  R26
	POP  R27
	CALL __CFD1U
	ST   X,R30
; 0000 00A7                  delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00A8             }
; 0000 00A9         Byte_flag=0;
_0x1A:
	LDI  R30,LOW(0)
	STS  _Byte_flag,R30
; 0000 00AA         for(i=0;i<30;i++)
	CLR  R6
	CLR  R7
_0x1C:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R6,R30
	CPC  R7,R31
	BRSH _0x1D
; 0000 00AB         {
; 0000 00AC         sum_2+=ADC[i];
	LDI  R26,LOW(_ADC)
	LDI  R27,HIGH(_ADC)
	ADD  R26,R6
	ADC  R27,R7
	LD   R30,X
	LDI  R31,0
	__ADDWRR 10,11,30,31
; 0000 00AD         LCD_Write_Cmd(CLR_SCR);
	CALL SUBOPT_0x2
; 0000 00AE         }
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0x1C
_0x1D:
; 0000 00AF         value=sum_2/30;
	MOVW R26,R10
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __DIVW21U
	CLR  R22
	CLR  R23
	STS  _value,R30
	STS  _value+1,R31
	STS  _value+2,R22
	STS  _value+3,R23
; 0000 00B0         volts= (long int)(value*5)/1024 ; //ADC 10 bits
	__GETD2N 0x5
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x400
	CALL __DIVD21
	LDI  R26,LOW(_volts)
	LDI  R27,HIGH(_volts)
	CALL __CDF1
	CALL __PUTDP1
; 0000 00B1         distance_2= 65*(pow(volts,-1.1))  ;
	LDS  R30,_volts
	LDS  R31,_volts+1
	LDS  R22,_volts+2
	LDS  R23,_volts+3
	CALL __PUTPARD1
	__GETD1N 0xBF8CCCCD
	CALL __PUTPARD1
	CALL _pow
	__GETD2N 0x42820000
	CALL __MULF12
	LDI  R26,LOW(_distance_2)
	LDI  R27,HIGH(_distance_2)
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
; 0000 00B2         // USART_ULTRASOUND
; 0000 00B3             USART_2();
	RCALL _USART_2
; 0000 00B4        //TRUYEN LEN LCD
; 0000 00B5            LCD_GotoXY(8,1);
	CALL SUBOPT_0x1
; 0000 00B6            LCD_Write_Int(distance_2);
	LDS  R30,_distance_2
	LDS  R31,_distance_2+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _LCD_Write_Int
; 0000 00B7 
; 0000 00B8  }
	RJMP _0x4
; 0000 00B9  }
_0x1E:
	RJMP _0x1E

	.DSEG
_0x3:
	.BYTE 0x1A
;
;// READ ADC VALUE
;unsigned int ADC_read(unsigned char ADC_CHANNEL)
; 0000 00BD {

	.CSEG
_ADC_read:
; 0000 00BE //  chon dien ap tham chieu va kenh can doc
; 0000 00BF ADMUX= ADC_VREF_TYPE|ADC_CHANNEL;
;	ADC_CHANNEL -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 00C0 delay_us(10);
	__DELAY_USB 37
; 0000 00C1 // Start conversation
; 0000 00C2 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 00C3 // wait for conversation end  (ADIF bit=1)
; 0000 00C4 while ((ADCSRA&0x10)==0);
_0x1F:
	SBIS 0x6,4
	RJMP _0x1F
; 0000 00C5 //   ADC  WORD = ADCH+ADCL
; 0000 00C6 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 00C7 return ADCW ;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x2080006
; 0000 00C8 }
;
;
;void USART_init(void)
; 0000 00CC {
_USART_init:
; 0000 00CD // USART initialization
; 0000 00CE // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00CF // USART Receiver: On
; 0000 00D0 // USART Transmitter: On
; 0000 00D1 // USART Mode: Asynchronous
; 0000 00D2 // USART Baud Rate: 9600
; 0000 00D3 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00D4 UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 00D5 UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 00D6 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00D7 UBRRL=0x47;
	LDI  R30,LOW(71)
	OUT  0x9,R30
; 0000 00D8 }
	RET
;
;
;
;#pragma used+
;void UART_putChar(char c)
; 0000 00DE {
_UART_putChar:
; 0000 00DF     while ((UCSRA & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
_0x22:
	SBIS 0xB,5
	RJMP _0x22
; 0000 00E0     UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00E1 }
	RJMP _0x2080006
;
;#pragma used-
;
;void UART_Printf(char *s)       //DE TEST CHUONG TRINH
; 0000 00E6 {
; 0000 00E7     // loop through entire string
; 0000 00E8     while (*s)
;	*s -> Y+0
; 0000 00E9     {
; 0000 00EA         UART_putChar(*s);
; 0000 00EB         delay_ms(20);
; 0000 00EC         s++;
; 0000 00ED     }
; 0000 00EE }
;
;
;void LCD_Putc(char c)
; 0000 00F2 {
_LCD_Putc:
; 0000 00F3    switch (c)
;	c -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 00F4 
; 0000 00F5         //without "break" can't continue next step
; 0000 00F6    {
; 0000 00F7       case '\f'   :  LCD_Write_Cmd(CLR_SCR);
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x2B
	CALL SUBOPT_0x2
; 0000 00F8                      delay_us(2);
	__DELAY_USB 7
; 0000 00F9                      break;
	RJMP _0x2A
; 0000 00FA 
; 0000 00FB       // xuong dong
; 0000 00FC       case '\n'   :  LCD_Write_Cmd(CURSOR_LINE2);
_0x2B:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x2C
	LDI  R30,LOW(192)
	ST   -Y,R30
	RCALL _LCD_Write_Cmd
; 0000 00FD                      break;
	RJMP _0x2A
; 0000 00FE 
; 0000 00FF       // dich con tro
; 0000 0100       case '\b'   :  LCD_Write_Cmd(0x10);
_0x2C:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2E
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _LCD_Write_Cmd
; 0000 0101                      break;
	RJMP _0x2A
; 0000 0102 
; 0000 0103       default     :  LCD_Write_Data(c);
_0x2E:
	LD   R30,Y
	ST   -Y,R30
	RCALL _LCD_Write_Data
; 0000 0104                      break;
; 0000 0105    }
_0x2A:
; 0000 0106 }
	RJMP _0x2080006
;
;void LCD_Printf(char *str)
; 0000 0109 {
_LCD_Printf:
; 0000 010A     int i=0;
; 0000 010B     while(str[i]!='\0')      // loop will go on till the NULL character in the string
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x2F:
	CALL SUBOPT_0x3
	CPI  R30,0
	BREQ _0x31
; 0000 010C     {
; 0000 010D         delay_us(50);
	__DELAY_USB 184
; 0000 010E         LCD_Putc(str[i]);    // sending data on LCD byte by byte
	CALL SUBOPT_0x3
	ST   -Y,R30
	RCALL _LCD_Putc
; 0000 010F         i++;
	__ADDWRN 16,17,1
; 0000 0110     }
	RJMP _0x2F
_0x31:
; 0000 0111 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2080004
;
;void LCD_Write_Int(unsigned int integer )
; 0000 0114 {
_LCD_Write_Int:
; 0000 0115     unsigned char thousands,hundreds,tens,ones;
; 0000 0116 
; 0000 0117     thousands = integer / 1000;
	CALL __SAVELOCR4
;	integer -> Y+4
;	thousands -> R17
;	hundreds -> R16
;	tens -> R19
;	ones -> R18
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	MOV  R17,R30
; 0000 0118     LCD_Write_Data(thousands + 0x30);
	MOV  R30,R17
	CALL SUBOPT_0x4
; 0000 0119 
; 0000 011A     hundreds = ((integer - thousands*1000)) / 100;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MULW12
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOV  R16,R30
; 0000 011B     LCD_Write_Data(hundreds + 0x30);
	MOV  R30,R16
	CALL SUBOPT_0x4
; 0000 011C 
; 0000 011D     tens=(integer%100)/10;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOV  R19,R30
; 0000 011E     LCD_Write_Data(tens + 0x30);
	MOV  R30,R19
	CALL SUBOPT_0x4
; 0000 011F 
; 0000 0120     ones=integer%10;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOV  R18,R30
; 0000 0121     LCD_Write_Data(ones + 0x30);
	MOV  R30,R18
	CALL SUBOPT_0x4
; 0000 0122 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;void LCD_Write_Nibble(char byte)
; 0000 0125 {
_LCD_Write_Nibble:
; 0000 0126        LCD_E = 1;
;	byte -> Y+0
	SBI  0x18,2
; 0000 0127     LCD_data_out(byte);
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
; 0000 0128     LCD_E = 0;
	CBI  0x18,2
; 0000 0129 }
	RJMP _0x2080006
;// wait + read LCD
;void LCD_Wait_Busy()
; 0000 012C {
_LCD_Wait_Busy:
; 0000 012D     unsigned char tempH,tempL;
; 0000 012E     PORTB |= 0xF0;          // SET 4 BIT DATA (thap) duoc su dung
	ST   -Y,R17
	ST   -Y,R16
;	tempH -> R17
;	tempL -> R16
	IN   R30,0x18
	ORI  R30,LOW(0xF0)
	OUT  0x18,R30
; 0000 012F     LCD_RS = 0;             // 0 = Instruction input, 1 = Data input
	CBI  0x18,0
; 0000 0130     LCD_RW = 1;             // 0 = Write to LCD module,1 = Read from LCD module
	SBI  0x18,1
; 0000 0131 
; 0000 0132     do
_0x3B:
; 0000 0133     {   // che do 4 bit se truyen va nhan nibble cao truoc (thap sau)
; 0000 0134         LCD_E = 1;          //che do 4 bit phai doc 2 lan
	CALL SUBOPT_0x5
; 0000 0135         delay_us(2);
; 0000 0136         DDRB  = 0x0f;        //set 4 bit cao cua PORTD LAM input     (doc ve)
; 0000 0137         tempH = PINB;       //read in upper nybble
	IN   R17,22
; 0000 0138         DDRB  = 0xff;       //out put (xuat ra LCD)
	CALL SUBOPT_0x6
; 0000 0139         LCD_E = 0;          //busy_flag
; 0000 013A         delay_us(2);
; 0000 013B        // ==============================
; 0000 013C        //không có phan nay khong hien LCD
; 0000 013D         LCD_E = 1;
	CALL SUBOPT_0x5
; 0000 013E         delay_us(2);
; 0000 013F         DDRB  = 0x0f;
; 0000 0140         tempL = PINB;       //read in lower nybble.
	IN   R16,22
; 0000 0141         DDRB  = 0xff;
	CALL SUBOPT_0x6
; 0000 0142         LCD_E = 0;          //BF = 1 is busy
; 0000 0143         delay_us(2);
; 0000 0144     } while (tempH&0x80);   //bit cuoi la busy
	SBRC R17,7
	RJMP _0x3B
; 0000 0145 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void LCD_Write_Cmd(char cmd)
; 0000 0148 {
_LCD_Write_Cmd:
; 0000 0149     LCD_Wait_Busy();
;	cmd -> Y+0
	RCALL _LCD_Wait_Busy
; 0000 014A     LCD_RS = 0;               // 0 = Instruction input
	CBI  0x18,0
; 0000 014B     LCD_RW = 0;               // 0 = Write to LCD module
	RJMP _0x2080005
; 0000 014C     LCD_Write_Nibble(cmd>>4);  // send high byte first
; 0000 014D     LCD_Write_Nibble(cmd);
; 0000 014E }
;
;void LCD_Write_Data(char chr)
; 0000 0151 {
_LCD_Write_Data:
; 0000 0152     LCD_Wait_Busy();
;	chr -> Y+0
	RCALL _LCD_Wait_Busy
; 0000 0153     LCD_RS = 1;                    // 1 = Data input
	SBI  0x18,0
; 0000 0154     LCD_RW = 0;                    // 0 = Write to LCD module
_0x2080005:
	CBI  0x18,1
; 0000 0155     LCD_Write_Nibble(chr>>4);     // nibble cao truoc
	LD   R30,Y
	LDI  R31,0
	CALL __ASRW4
	ST   -Y,R30
	RCALL _LCD_Write_Nibble
; 0000 0156     LCD_Write_Nibble(chr);
	LD   R30,Y
	ST   -Y,R30
	RCALL _LCD_Write_Nibble
; 0000 0157 }
_0x2080006:
	ADIW R28,1
	RET
;
;void LCD_Init()
; 0000 015A {
_LCD_Init:
; 0000 015B     LCD_RS = 0;
	CBI  0x18,0
; 0000 015C     LCD_RW = 0;
	CBI  0x18,1
; 0000 015D     LCD_Write_Nibble(MODE_4_BIT>>4);   //lan dau tien truyen du lieu, LCD mac dinh la` 8 bit
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _LCD_Write_Nibble
; 0000 015E     LCD_Write_Cmd(MODE_4_BIT);         //nen phai set function 2 lan de dieu chinh theo che do
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL _LCD_Write_Cmd
; 0000 015F     LCD_Write_Cmd(DISP_ON);            //mong muon: 4 bit, 2 line, 5x7 dot
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL _LCD_Write_Cmd
; 0000 0160     //LCD_Write_Cmd(CURSOR_ON);        // tat con
; 0000 0161     LCD_Write_Cmd(CLR_SCR);
	CALL SUBOPT_0x2
; 0000 0162 }
	RET
;
;
;void LCD_GotoXY(unsigned char x, unsigned char y)
; 0000 0166 {
_LCD_GotoXY:
; 0000 0167     if(x<40)
;	x -> Y+1
;	y -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0x28)
	BRSH _0x51
; 0000 0168 
; 0000 0169     {
; 0000 016A     //Sets the specified value (AAAAAA) into the address counter
; 0000 016B       if(y) x |= 0x40;    //0x40:  64D
	LD   R30,Y
	CPI  R30,0
	BREQ _0x52
	LDD  R30,Y+1
	ORI  R30,0x40
	STD  Y+1,R30
; 0000 016C       // di chuyen toi vi tri mong muon neu y=0 (DDRAM)
; 0000 016D       x |=0x80;
_0x52:
	LDD  R30,Y+1
	ORI  R30,0x80
	STD  Y+1,R30
; 0000 016E       LCD_Write_Cmd(x);
	ST   -Y,R30
	RCALL _LCD_Write_Cmd
; 0000 016F     }
; 0000 0170 }
_0x51:
	ADIW R28,2
	RET
;
;void USART_1(void)
; 0000 0173 {
_USART_1:
; 0000 0174             //USART TRANMISTER
; 0000 0175             USART_packet[0]=0x55;
	CALL SUBOPT_0x7
; 0000 0176             USART_packet[1]=0xaa;
; 0000 0177             High_byte=(distance_1&0xff00)>>8;
	MOVW R30,R12
	ANDI R30,LOW(0xFF00)
	MOV  R30,R31
	LDI  R31,0
	STS  _High_byte,R30
; 0000 0178             Low_byte=(distance_1&0x00ff);
	MOV  R30,R12
	CALL SUBOPT_0x8
; 0000 0179             USART_packet[2]=High_byte;
; 0000 017A             USART_packet[3]=Low_byte;
; 0000 017B 
; 0000 017C             for (i=0;i<4;i++)
_0x54:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R6,R30
	CPC  R7,R31
	BRSH _0x55
; 0000 017D             {
; 0000 017E             UART_putChar(USART_packet[i]);
	CALL SUBOPT_0x9
; 0000 017F             }
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0x54
_0x55:
; 0000 0180 }
	RET
;void USART_2(void)
; 0000 0182 {
_USART_2:
; 0000 0183    //USART TRANMISTER
; 0000 0184             USART_packet[0]=0x55;
	CALL SUBOPT_0x7
; 0000 0185             USART_packet[1]=0xaa;
; 0000 0186             High_byte=(distance_2&0xff00)>>8;
	LDS  R30,_distance_2
	LDS  R31,_distance_2+1
	ANDI R30,LOW(0xFF00)
	MOV  R30,R31
	LDI  R31,0
	STS  _High_byte,R30
; 0000 0187             Low_byte=(distance_2&0x00ff);
	LDS  R30,_distance_2
	CALL SUBOPT_0x8
; 0000 0188             USART_packet[2]=High_byte;
; 0000 0189             USART_packet[3]=Low_byte;
; 0000 018A 
; 0000 018B             for (i=0;i<4;i++)
_0x57:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R6,R30
	CPC  R7,R31
	BRSH _0x58
; 0000 018C             {
; 0000 018D             UART_putChar(USART_packet[i]);
	CALL SUBOPT_0x9
; 0000 018E             }
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0x57
_0x58:
; 0000 018F }
	RET
;
;void System_init(void)
; 0000 0192 {
_System_init:
; 0000 0193     // Timer/Counter 1 initialization
; 0000 0194     // Clock source: System Clock
; 0000 0195     // Clock value: 1382.400 kHz
; 0000 0196     // Mode: Normal top=0xFFFF
; 0000 0197     // OC1A output: Discon.
; 0000 0198     // OC1B output: Discon.
; 0000 0199     // Noise Canceler: Off
; 0000 019A     // Input Capture on Falling Edge
; 0000 019B     // Timer1 Overflow Interrupt: Off
; 0000 019C     // Input Capture Interrupt: Off
; 0000 019D     // Compare A Match Interrupt: Off
; 0000 019E     // Compare B Match Interrupt: Off
; 0000 019F     TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 01A0     TCCR1B=0x00;//0x02;
	OUT  0x2E,R30
; 0000 01A1     TCNT1=0x00;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 01A2     ICR1H=0x00;
	OUT  0x27,R30
; 0000 01A3     ICR1L=0x00;
	OUT  0x26,R30
; 0000 01A4     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01A5     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01A6     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01A7     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01A8     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01A9     TIMSK=0x00;
	OUT  0x39,R30
; 0000 01AA     // Analog Comparator initialization
; 0000 01AB     // Analog Comparator: Off
; 0000 01AC     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01AD     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01AE     SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01AF }
	RET
;
;//void Speak(void)
;//{
;////SPEAKING
;//           if(distance==10)
;//           {
;//                for(index=0;index<4;index++)
;//                    {
;//                        //SPEAKING
;//                        PORTA;
;//
;//                    }
;//           }
;//        else if(distance==20)
;//        {
;//                for(index=0;index<4;index++)
;//                      {
;//                       //SPEAKING
;//                        PORTA;
;//
;//        }
;//       else if (distance==50)
;//       {
;//            for(index=0;index<4;index++)
;//               {
;//               //SPEAKING
;//                 PORTA ;
;//               }
;//
;//
;//      }
;//}
;//}
;
;
;
;
;
;

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0xA
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0xA
	RJMP _0x2080004
__floor1:
    brtc __floor0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
_0x2080004:
	ADIW R28,4
	RET
_log:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0xC
	CALL __CPD02
	BRLT _0x200000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x2080003
_0x200000C:
	CALL SUBOPT_0xD
	CALL __PUTPARD1
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x200000D
	CALL SUBOPT_0xF
	CALL __ADDF12
	CALL SUBOPT_0xE
	__SUBWRN 16,17,1
_0x200000D:
	CALL SUBOPT_0xD
	CALL SUBOPT_0xB
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL SUBOPT_0x11
	CALL SUBOPT_0xC
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x2080003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
_exp:
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x13
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x200000F
	CALL SUBOPT_0x14
	RJMP _0x2080002
_0x200000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x2000010
	__GETD1N 0x3F800000
	RJMP _0x2080002
_0x2000010:
	CALL SUBOPT_0x13
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000011
	__GETD1N 0x7F7FFFFF
	RJMP _0x2080002
_0x2000011:
	CALL SUBOPT_0x13
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL __PUTPARD1
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	MOVW R30,R16
	CALL SUBOPT_0x13
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x11
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x11
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0xC
	CALL __MULF12
	CALL SUBOPT_0xE
	CALL SUBOPT_0x12
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0xD
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	CALL SUBOPT_0x12
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	ST   -Y,R17
	ST   -Y,R16
	CALL _ldexp
_0x2080002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
_pow:
	SBIW R28,4
	CALL SUBOPT_0x15
	CALL __CPD10
	BRNE _0x2000012
	CALL SUBOPT_0x14
	RJMP _0x2080001
_0x2000012:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x2000013
	CALL SUBOPT_0x16
	CALL __CPD10
	BRNE _0x2000014
	__GETD1N 0x3F800000
	RJMP _0x2080001
_0x2000014:
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	RJMP _0x2080001
_0x2000013:
	CALL SUBOPT_0x16
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0xA
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x16
	CALL __CPD12
	BREQ _0x2000015
	CALL SUBOPT_0x14
	RJMP _0x2080001
_0x2000015:
	CALL SUBOPT_0x15
	CALL __ANEGF1
	CALL SUBOPT_0x17
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2000016
	CALL SUBOPT_0x15
	RJMP _0x2080001
_0x2000016:
	CALL SUBOPT_0x15
	CALL __ANEGF1
_0x2080001:
	ADIW R28,12
	RET

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_distance:
	.BYTE 0x3C
_distance_2:
	.BYTE 0x2
_value:
	.BYTE 0x4
_volts:
	.BYTE 0x4
_High_byte:
	.BYTE 0x1
_Low_byte:
	.BYTE 0x1
_USART_packet:
	.BYTE 0x4
_ADC:
	.BYTE 0x1E
_Byte_flag:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _LCD_GotoXY

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _LCD_Write_Cmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	SUBI R30,-LOW(48)
	ST   -Y,R30
	JMP  _LCD_Write_Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	SBI  0x18,2
	__DELAY_USB 7
	LDI  R30,LOW(15)
	OUT  0x17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(255)
	OUT  0x17,R30
	CBI  0x18,2
	__DELAY_USB 7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(85)
	STS  _USART_packet,R30
	LDI  R30,LOW(170)
	__PUTB1MN _USART_packet,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	STS  _Low_byte,R30
	LDS  R30,_High_byte
	__PUTB1MN _USART_packet,2
	LDS  R30,_Low_byte
	__PUTB1MN _USART_packet,3
	CLR  R6
	CLR  R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_USART_packet)
	LDI  R27,HIGH(_USART_packet)
	ADD  R26,R6
	ADC  R27,R7
	LD   R30,X
	ST   -Y,R30
	JMP  _UART_putChar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__GETD2N 0x3F800000
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xC:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0xD
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	CALL __PUTPARD1
	CALL _log
	__GETD2S 4
	CALL __MULF12
	CALL __PUTPARD1
	JMP  _exp


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

_frexp:
	LD   R26,Y+
	LD   R27,Y+
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R26,Y+
	LD   R27,Y+
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
