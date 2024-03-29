
;CodeVisionAVR C Compiler V4.00a Evaluation
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega128A
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128A
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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
	.EQU SPMCSR=0x68
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x80

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

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
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

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
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

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
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

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
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
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
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
	.DEF _cnt=R4
	.DEF _cnt_msb=R5
	.DEF _cnt2=R6
	.DEF _cnt2_msb=R7
	.DEF _mode=R8
	.DEF _mode_msb=R9
	.DEF _msec=R10
	.DEF _msec_msb=R11
	.DEF _sec=R12
	.DEF _sec_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  _ext_int4_isr
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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_ocr1a:
	.DB  0x71,0x77,0xBC,0x70,0x68,0x6A,0x6F,0x64
	.DB  0xCC,0x5E,0x7A,0x59,0x74,0x54,0xB7,0x4F
	.DB  0x3D,0x4B,0x4,0x47,0x8,0x43,0x45,0x3F
	.DB  0xB8,0x3B,0x5D,0x38,0x33,0x35,0x37,0x32
	.DB  0x65,0x2F,0xBC,0x2C,0x39,0x2A,0xDB,0x27
	.DB  0x9E,0x25,0x81,0x23,0x83,0x21,0x17,0xFD
	.DB  0xE3,0xEE,0x7A,0xE1,0xD2,0xD4,0xE0,0xC8
	.DB  0x9A,0xBD,0xF6,0xB2,0xEA,0xA8,0x6F,0x9F
	.DB  0x7C,0x96,0xA,0x8E,0x11,0x86,0x8B,0x7E
	.DB  0x71,0x77,0xBC,0x70,0x68,0x6A,0x6F,0x64
	.DB  0xCC,0x5E,0x7A,0x59,0x74,0x54,0xB7,0x4F
	.DB  0x3D,0x4B,0x4,0x47,0x8,0x43,0x45,0x3F
	.DB  0xB8,0x3B,0x5D,0x38,0x33,0x35,0x37,0x32
	.DB  0x65,0x2F,0xBC,0x2C,0x39,0x2A,0xDB,0x27
	.DB  0x9E,0x25,0x81,0x23,0x83,0x21,0xA2,0x1F
	.DB  0xDB,0x1D,0x2E,0x1C,0x99,0x1A,0x1B,0x19
	.DB  0xB2,0x17,0x5D,0x16,0x1C,0x15,0xED,0x13
	.DB  0xCE,0x12,0xC0,0x11,0xC1,0x10,0xD0,0xF
	.DB  0xED,0xE,0x16,0xE,0x4C,0xD,0x8D,0xC
	.DB  0xD8,0xB,0x2E,0xB,0x8D,0xA,0xF6,0x9
	.DB  0x66,0x9,0xDF,0x8,0x60,0x8,0xE7,0x7
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x1
_0x0:
	.DB  0x73,0x65,0x74,0x61,0x6B,0x21,0x21,0x0
	.DB  0x77,0x61,0x73,0x68,0x21,0x21,0x0,0x64
	.DB  0x65,0x77,0x61,0x74,0x65,0x72,0x21,0x21
	.DB  0x0,0x46,0x49,0x4E,0x49,0x53,0x48,0x45
	.DB  0x44,0x21,0x21,0x0,0x73,0x74,0x61,0x72
	.DB  0x74,0x0,0x70,0x61,0x75,0x73,0x65,0x0
	.DB  0x70,0x6F,0x77,0x65,0x72,0x20,0x6F,0x66
	.DB  0x66,0x2E,0x2E,0x0,0x4D,0x4F,0x44,0x45
	.DB  0x20,0x3A,0x20,0x25,0x64,0x0,0x44,0x45
	.DB  0x57,0x41,0x54,0x45,0x52,0x20,0x43,0x4F
	.DB  0x55,0x4E,0x54,0x3A,0x25,0x64,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _res_cnt
	.DW  _0x3*2

	.DW  0x08
	.DW  _0xE
	.DW  _0x0*2

	.DW  0x07
	.DW  _0x21
	.DW  _0x0*2+8

	.DW  0x0A
	.DW  _0x34
	.DW  _0x0*2+15

	.DW  0x0B
	.DW  _0x34+10
	.DW  _0x0*2+25

	.DW  0x06
	.DW  _0x4B
	.DW  _0x0*2+36

	.DW  0x06
	.DW  _0x4B+6
	.DW  _0x0*2+42

	.DW  0x0C
	.DW  _0x55
	.DW  _0x0*2+48

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI

	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

	OUT  RAMPZ,R24

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
	.ORG 0x00

	.DSEG
	.ORG 0x500

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG
;unsigned int getEcho(void)
; 0000 0025 {

	.CSEG
_getEcho:
; .FSTART _getEcho
; 0000 0026 Trigger_ON; delay_us(10); Trigger_OFF;
	LDS  R30,98
	ORI  R30,1
	STS  98,R30
	__DELAY_USB 53
	LDS  R30,98
	ANDI R30,0xFE
	STS  98,R30
; 0000 0027 while(!Echo);              // Wait for echo pin to go high
_0x4:
	SBIS 0x0,2
	RJMP _0x4
; 0000 0028 TCNT1=0x00; TCCR1B=0x02;         // 1: 8 prescaler=0.5us
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 0029 while(Echo);               // Wait for echo pin to go low
_0x7:
	SBIC 0x0,2
	RJMP _0x7
; 0000 002A TCCR1B=0x08;
	LDI  R30,LOW(8)
	OUT  0x2E,R30
; 0000 002B return(TCNT1/116); // the range in CM
	IN   R30,0x2C
	IN   R31,0x2C+1
	MOVW R26,R30
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	RCALL __DIVW21U
	RET
; 0000 002C }
; .FEND
;void sound(char octave, char pitch){
; 0000 002E void sound(char octave, char pitch){
_sound:
; .FSTART _sound
; 0000 002F if(octave>6)
	RCALL SUBOPT_0x0
;	octave -> R16
;	pitch -> R17
	CPI  R16,7
	BRLO _0xA
; 0000 0030 {
; 0000 0031 octave=6;
	LDI  R16,LOW(6)
; 0000 0032 }
; 0000 0033 if(pitch>11)pitch=11;
_0xA:
	CPI  R17,12
	BRLO _0xB
	LDI  R17,LOW(11)
; 0000 0034 {
_0xB:
; 0000 0035 TCCR1B&=~7;
	IN   R30,0x2E
	ANDI R30,LOW(0xF8)
	OUT  0x2E,R30
; 0000 0036 }
; 0000 0037 if((octave*12+pitch)<23)
	LDI  R30,LOW(12)
	MUL  R30,R16
	MOVW R30,R0
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,23
	BRGE _0xC
; 0000 0038 {
; 0000 0039 TCCR1B|=2;
	IN   R30,0x2E
	ORI  R30,2
	RJMP _0x5D
; 0000 003A }
; 0000 003B else
_0xC:
; 0000 003C {
; 0000 003D TCCR1B|=1;
	IN   R30,0x2E
	ORI  R30,1
_0x5D:
	OUT  0x2E,R30
; 0000 003E }
; 0000 003F OCR1A=ocr1a[octave][pitch];
	LDI  R26,LOW(24)
	MUL  R16,R26
	MOVW R30,R0
	SUBI R30,LOW(-_ocr1a*2)
	SBCI R31,HIGH(-_ocr1a*2)
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETW1PF
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0040 }
	JMP  _0x2080002
; .FEND
;void bgm(){
; 0000 0042 void bgm(){
_bgm:
; .FSTART _bgm
; 0000 0043 TCCR1A=0x40; TCCR1B=9; TCCR1C=0x80; OCR1A=0;
	LDI  R30,LOW(64)
	OUT  0x2F,R30
	LDI  R30,LOW(9)
	OUT  0x2E,R30
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x1
; 0000 0044 
; 0000 0045 sound(4,0);    //도
	RCALL SUBOPT_0x2
; 0000 0046 delay_ms(500);
; 0000 0047 
; 0000 0048 sound(4,5);    //파
	RCALL SUBOPT_0x3
; 0000 0049 delay_ms(166);
; 0000 004A sound(4,4);    //미
; 0000 004B delay_ms(166);
; 0000 004C sound(4,2);    //레
; 0000 004D delay_ms(166);
; 0000 004E sound(4,0);    //도
; 0000 004F delay_ms(500);
; 0000 0050 
; 0000 0051 sound(3,9);    //라
	RCALL SUBOPT_0x4
; 0000 0052 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL SUBOPT_0x5
; 0000 0053 
; 0000 0054 sound(3,11);   //시
; 0000 0055 delay_ms(166);
; 0000 0056 sound(4,0);    //도
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x6
; 0000 0057 delay_ms(166);
; 0000 0058 sound(4,2);    //레
	RCALL SUBOPT_0x7
; 0000 0059 delay_ms(166);
; 0000 005A 
; 0000 005B sound(3,7);    //솔
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL SUBOPT_0x6
; 0000 005C delay_ms(166);
; 0000 005D sound(3,9);    //라
	RCALL SUBOPT_0x4
; 0000 005E delay_ms(166);
	LDI  R26,LOW(166)
	LDI  R27,0
	RCALL SUBOPT_0x5
; 0000 005F sound(3,11);   //시
; 0000 0060 delay_ms(166);
; 0000 0061 sound(3,9);    //라
	RCALL SUBOPT_0x4
; 0000 0062 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0063 
; 0000 0064 sound(4,0);
	RCALL SUBOPT_0x2
; 0000 0065 delay_ms(500);
; 0000 0066 
; 0000 0067 sound(4,0);
	RCALL SUBOPT_0x2
; 0000 0068 delay_ms(500);
; 0000 0069 
; 0000 006A sound(4,5);    //파
	RCALL SUBOPT_0x3
; 0000 006B delay_ms(166);
; 0000 006C sound(4,4);    //미
; 0000 006D delay_ms(166);
; 0000 006E sound(4,2);    //레
; 0000 006F delay_ms(166);
; 0000 0070 sound(4,0);    //도
; 0000 0071 delay_ms(500);
; 0000 0072 
; 0000 0073 sound(4,5);    //파
	RCALL SUBOPT_0x8
; 0000 0074 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0075 
; 0000 0076 sound(4,5);    //파
	RCALL SUBOPT_0x9
; 0000 0077 delay_ms(166);
; 0000 0078 sound(4,7);    //솔
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL SUBOPT_0x6
; 0000 0079 delay_ms(166);
; 0000 007A sound(4,5);    //파
	RCALL SUBOPT_0x9
; 0000 007B delay_ms(166);
; 0000 007C sound(4,4);    //미
	RCALL SUBOPT_0xA
; 0000 007D delay_ms(166);
; 0000 007E sound(4,2);    //레
	RCALL SUBOPT_0x7
; 0000 007F delay_ms(166);
; 0000 0080 sound(4,4);    //미
	RCALL SUBOPT_0xA
; 0000 0081 delay_ms(166);
; 0000 0082 
; 0000 0083 sound(4,5);    //파
	RCALL SUBOPT_0x8
; 0000 0084 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0085 // PORTB=0xff;      //버저 포트 OFF     0b11101111
; 0000 0086 TCCR1A=0x00; TCCR1B=0; TCCR1C=0x00; OCR1A=0;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
	OUT  0x2E,R30
	RCALL SUBOPT_0x1
; 0000 0087 }
	RET
; .FEND
;void setak(void){
; 0000 0089 void setak(void){
_setak:
; .FSTART _setak
; 0000 008A lcd_clear();
	RCALL SUBOPT_0xB
; 0000 008B lcd_gotoxy(0,0);
; 0000 008C lcd_puts("setak!!");
	__POINTW2MN _0xE,0
	RCALL _lcd_puts
; 0000 008D sec=0;
	CLR  R12
	CLR  R13
; 0000 008E while(sec<=1){OCR0=0; }
_0xF:
	RCALL SUBOPT_0xC
	BRLT _0x11
	LDI  R30,LOW(0)
	OUT  0x31,R30
	RJMP _0xF
_0x11:
; 0000 008F while(sec<=3){while(pause!=1){OCR0=0;} PORTB=0x90; OCR0=150;}
_0x12:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R12
	CPC  R31,R13
	BRLT _0x14
_0x15:
	RCALL SUBOPT_0xD
	BREQ _0x17
	LDI  R30,LOW(0)
	OUT  0x31,R30
	RJMP _0x15
_0x17:
	LDI  R30,LOW(144)
	OUT  0x18,R30
	LDI  R30,LOW(150)
	OUT  0x31,R30
	RJMP _0x12
_0x14:
; 0000 0090 while(sec<=4){OCR0=0;}
_0x18:
	RCALL SUBOPT_0xE
	BRLT _0x1A
	LDI  R30,LOW(0)
	OUT  0x31,R30
	RJMP _0x18
_0x1A:
; 0000 0091 while(sec<=6){while(pause!=1){OCR0=0;} PORTB=0x50; OCR0=150;}
_0x1B:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R12
	CPC  R31,R13
	BRLT _0x1D
_0x1E:
	RCALL SUBOPT_0xD
	BREQ _0x20
	LDI  R30,LOW(0)
	OUT  0x31,R30
	RJMP _0x1E
_0x20:
	LDI  R30,LOW(80)
	OUT  0x18,R30
	LDI  R30,LOW(150)
	OUT  0x31,R30
	RJMP _0x1B
_0x1D:
; 0000 0092 }
	RET
; .FEND

	.DSEG
_0xE:
	.BYTE 0x8
;void wash(void){
; 0000 0094 void wash(void){

	.CSEG
_wash:
; .FSTART _wash
; 0000 0095 lcd_clear();
	RCALL SUBOPT_0xB
; 0000 0096 lcd_gotoxy(0,0);
; 0000 0097 lcd_puts("wash!!");
	__POINTW2MN _0x21,0
	RCALL _lcd_puts
; 0000 0098 sec=0;
	CLR  R12
	CLR  R13
; 0000 0099 while(sec<=1){OCR0=0; }
_0x22:
	RCALL SUBOPT_0xC
	BRLT _0x24
	LDI  R30,LOW(0)
	OUT  0x31,R30
	RJMP _0x22
_0x24:
; 0000 009A while(sec<=4){while(pause!=1){OCR0=0;} PORTB=0x90; OCR0=200;}
_0x25:
	RCALL SUBOPT_0xE
	BRLT _0x27
_0x28:
	RCALL SUBOPT_0xD
	BREQ _0x2A
	LDI  R30,LOW(0)
	OUT  0x31,R30
	RJMP _0x28
_0x2A:
	LDI  R30,LOW(144)
	OUT  0x18,R30
	LDI  R30,LOW(200)
	OUT  0x31,R30
	RJMP _0x25
_0x27:
; 0000 009B while(sec<=5){OCR0=0;}
_0x2B:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R12
	CPC  R31,R13
	BRLT _0x2D
	LDI  R30,LOW(0)
	OUT  0x31,R30
	RJMP _0x2B
_0x2D:
; 0000 009C while(sec<=8){while(pause!=1){OCR0=0;} PORTB=0x50; OCR0=200;}
_0x2E:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R12
	CPC  R31,R13
	BRLT _0x30
_0x31:
	RCALL SUBOPT_0xD
	BREQ _0x33
	LDI  R30,LOW(0)
	OUT  0x31,R30
	RJMP _0x31
_0x33:
	LDI  R30,LOW(80)
	OUT  0x18,R30
	LDI  R30,LOW(200)
	OUT  0x31,R30
	RJMP _0x2E
_0x30:
; 0000 009D }
	RET
; .FEND

	.DSEG
_0x21:
	.BYTE 0x7
;void dewater(void){
; 0000 009F void dewater(void){

	.CSEG
_dewater:
; .FSTART _dewater
; 0000 00A0 lcd_clear();
	RCALL SUBOPT_0xB
; 0000 00A1 lcd_gotoxy(0,0);
; 0000 00A2 lcd_puts("dewater!!");
	__POINTW2MN _0x34,0
	RCALL _lcd_puts
; 0000 00A3 for(i=0;i<res_cnt;i++){
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x36:
	RCALL SUBOPT_0xF
	LDS  R26,_i
	LDS  R27,_i+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x37
; 0000 00A4 sec=0;
	CLR  R12
	CLR  R13
; 0000 00A5 while(sec<=2){while(pause!=1){OCR0=0;} PORTB=0x90; OCR0=250;}
_0x38:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R12
	CPC  R31,R13
	BRLT _0x3A
_0x3B:
	RCALL SUBOPT_0xD
	BREQ _0x3D
	LDI  R30,LOW(0)
	OUT  0x31,R30
	RJMP _0x3B
_0x3D:
	LDI  R30,LOW(144)
	OUT  0x18,R30
	LDI  R30,LOW(250)
	OUT  0x31,R30
	RJMP _0x38
_0x3A:
; 0000 00A6 while(sec<=7){while(pause!=1){OCR0=0;} PORTB=0x50; OCR0=250;}
_0x3E:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R12
	CPC  R31,R13
	BRLT _0x40
_0x41:
	RCALL SUBOPT_0xD
	BREQ _0x43
	LDI  R30,LOW(0)
	OUT  0x31,R30
	RJMP _0x41
_0x43:
	LDI  R30,LOW(80)
	OUT  0x18,R30
	LDI  R30,LOW(250)
	OUT  0x31,R30
	RJMP _0x3E
_0x40:
; 0000 00A7 }
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	RCALL SUBOPT_0x10
	RJMP _0x36
_0x37:
; 0000 00A8 OCR0=0;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 00A9 lcd_clear();
	RCALL SUBOPT_0xB
; 0000 00AA lcd_gotoxy(0,0);
; 0000 00AB lcd_puts("FINISHED!!");
	__POINTW2MN _0x34,10
	RCALL _lcd_puts
; 0000 00AC delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 00AD cnt++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 00AE }
	RET
; .FEND

	.DSEG
_0x34:
	.BYTE 0x15
;interrupt [2] void ext_int0_isr(void)
; 0000 00B1 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	RCALL SUBOPT_0x11
; 0000 00B2 range=getEcho();
	RCALL _getEcho
	STS  _range,R30
	STS  _range+1,R31
; 0000 00B3 if(range<20) {cnt++;} // 일정거리 안에 들어와야만 전원이 켜진다.
	LDS  R26,_range
	LDS  R27,_range+1
	SBIW R26,20
	BRSH _0x44
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 00B4 if(cnt>=2) {cnt=0;}
_0x44:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x45
	CLR  R4
	CLR  R5
; 0000 00B5 delay_ms(55);
_0x45:
	RJMP _0x5F
; 0000 00B6 }
; .FEND
;interrupt [3] void ext_int1_isr(void)
; 0000 00B9 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x11
; 0000 00BA if(cnt==0){OCR0=0;}
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x46
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 00BB if(cnt==1){ // 전원버튼이 눌렀을 때에만 동작
_0x46:
	RCALL SUBOPT_0x12
	BRNE _0x47
; 0000 00BC mode++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 00BD if(mode>3) mode=0;
	RCALL SUBOPT_0x13
	BRGE _0x48
	CLR  R8
	CLR  R9
; 0000 00BE }
_0x48:
; 0000 00BF delay_ms(55);
_0x47:
	RJMP _0x5F
; 0000 00C0 }
; .FEND
;interrupt [4] void ext_int2_isr(void)
; 0000 00C3 {
_ext_int2_isr:
; .FSTART _ext_int2_isr
	RCALL SUBOPT_0x11
; 0000 00C4 if(cnt==1){res_cnt++;} // 전원 버튼이 눌려진 상태에서만 동작
	RCALL SUBOPT_0x12
	BRNE _0x49
	LDI  R26,LOW(_res_cnt)
	LDI  R27,HIGH(_res_cnt)
	RCALL SUBOPT_0x10
; 0000 00C5 delay_ms(50);
_0x49:
	LDI  R26,LOW(50)
	RJMP _0x5E
; 0000 00C6 }
; .FEND
;interrupt [6] void ext_int4_isr(void)
; 0000 00C9 {
_ext_int4_isr:
; .FSTART _ext_int4_isr
	RCALL SUBOPT_0x11
; 0000 00CA pause++;
	LDI  R26,LOW(_pause)
	LDI  R27,HIGH(_pause)
	RCALL SUBOPT_0x10
; 0000 00CB if(pause==1) {lcd_gotoxy(0,1); lcd_puts("start");}
	RCALL SUBOPT_0xD
	BRNE _0x4A
	RCALL SUBOPT_0x14
	__POINTW2MN _0x4B,0
	RCALL _lcd_puts
; 0000 00CC if(pause>=2) {lcd_gotoxy(0,1); lcd_puts("pause"); pause=0;}
_0x4A:
	LDS  R26,_pause
	LDS  R27,_pause+1
	SBIW R26,2
	BRLT _0x4C
	RCALL SUBOPT_0x14
	__POINTW2MN _0x4B,6
	RCALL _lcd_puts
	LDI  R30,LOW(0)
	STS  _pause,R30
	STS  _pause+1,R30
; 0000 00CD delay_ms(55);
_0x4C:
_0x5F:
	LDI  R26,LOW(55)
_0x5E:
	LDI  R27,0
	RCALL _delay_ms
; 0000 00CE }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.DSEG
_0x4B:
	.BYTE 0xC
;interrupt [30] void timer3_ovf_isr(void)
; 0000 00D1 {

	.CSEG
_timer3_ovf_isr:
; .FSTART _timer3_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00D2 TCNT3H=0xb1;
	RCALL SUBOPT_0x15
; 0000 00D3 TCNT3L=0xe0;
; 0000 00D4 if(cnt==1 && pause==1){msec++; if(msec==100){sec++; msec=0;}}
	RCALL SUBOPT_0x12
	BRNE _0x4E
	RCALL SUBOPT_0xD
	BREQ _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x50
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	CLR  R10
	CLR  R11
_0x50:
; 0000 00D5 }
_0x4D:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;void main(void)
; 0000 00D8 {
_main:
; .FSTART _main
; 0000 00D9 DDRA=0xff; // LED
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 00DA PORTA=0xff;
	OUT  0x1B,R30
; 0000 00DB DDRB=0xff; // motor   11010000   pb4 = ENA(OC0) ,  pb6 = IN1  , pb7 = IN2
	OUT  0x17,R30
; 0000 00DC PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00DD DDRC=0xff; // LCD
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00DE PORTC=0xff;
	OUT  0x15,R30
; 0000 00DF DDRD=0xf0; // 버튼
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 00E0 PORTD=0xff;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 00E1 DDRE=0xef;
	LDI  R30,LOW(239)
	OUT  0x2,R30
; 0000 00E2 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 00E3 DDRF=3; // PORTF.0 Trigger  PORTF.2 Echo
	LDI  R30,LOW(3)
	STS  97,R30
; 0000 00E4 
; 0000 00E5 ASSR=0<<AS0;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00E6 
; 0000 00E7 TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(108)
	OUT  0x33,R30
; 0000 00E8 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00E9 OCR0=0x00;
	OUT  0x31,R30
; 0000 00EA 
; 0000 00EB TCCR3B=0x02;
	LDI  R30,LOW(2)
	STS  138,R30
; 0000 00EC TCNT3H=0xb1;
	RCALL SUBOPT_0x15
; 0000 00ED TCNT3L=0xe0;
; 0000 00EE 
; 0000 00EF TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x37,R30
; 0000 00F0 ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (1<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	STS  125,R30
; 0000 00F1 
; 0000 00F2 EICRA=(0<<ISC31) | (0<<ISC30) | (1<<ISC21) | (0<<ISC20) | (1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(42)
	STS  106,R30
; 0000 00F3 EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (1<<ISC41) | (0<<ISC40);
	LDI  R30,LOW(2)
	OUT  0x3A,R30
; 0000 00F4 EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (1<<INT4) | (0<<INT3) | (1<<INT2) | (1<<INT1) | (1<<INT0);
	LDI  R30,LOW(23)
	OUT  0x39,R30
; 0000 00F5 EIFR=(0<<INTF7) | (0<<INTF6) | (0<<INTF5) | (1<<INTF4) | (0<<INTF3) | (1<<INTF2) | (1<<INTF1) | (1<<INTF0);
	OUT  0x38,R30
; 0000 00F6 
; 0000 00F7 
; 0000 00F8 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00F9 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00FA #asm("sei")
	SEI
; 0000 00FB while (1)
_0x51:
; 0000 00FC {
; 0000 00FD 
; 0000 00FE if(cnt%2==0)
	RCALL SUBOPT_0x16
	SBIW R30,0
	BRNE _0x54
; 0000 00FF {
; 0000 0100 cnt=cnt2=mode=msec=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	MOVW R10,R30
	MOVW R8,R30
	MOVW R6,R30
	MOVW R4,R30
; 0000 0101 OCR0=0;
	OUT  0x31,R30
; 0000 0102 res_cnt=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _res_cnt,R30
	STS  _res_cnt+1,R31
; 0000 0103 lcd_clear();
	RCALL SUBOPT_0xB
; 0000 0104 lcd_gotoxy(0,0);
; 0000 0105 lcd_puts("power off..");
	__POINTW2MN _0x55,0
	RCALL _lcd_puts
; 0000 0106 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0107 lcd_clear();
	RCALL _lcd_clear
; 0000 0108 }
; 0000 0109 if(cnt%2==1){
_0x54:
	RCALL SUBOPT_0x16
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x56
; 0000 010A lcd_clear();
	RCALL _lcd_clear
; 0000 010B sprintf(data,"MODE : %d",mode);
	LDI  R30,LOW(_data)
	LDI  R31,HIGH(_data)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,60
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	RCALL SUBOPT_0x17
; 0000 010C lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 010D lcd_puts(data);
	LDI  R26,LOW(_data)
	LDI  R27,HIGH(_data)
	RCALL _lcd_puts
; 0000 010E sprintf(data2,"DEWATER COUNT:%d",res_cnt);
	LDI  R30,LOW(_data2)
	LDI  R31,HIGH(_data2)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,70
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x17
; 0000 010F lcd_gotoxy(0,1);
	RCALL SUBOPT_0x14
; 0000 0110 lcd_puts(data2);
	LDI  R26,LOW(_data2)
	LDI  R27,HIGH(_data2)
	RCALL _lcd_puts
; 0000 0111 if(pause==1)
	RCALL SUBOPT_0xD
	BRNE _0x57
; 0000 0112 {
; 0000 0113 if(mode==0){PORTB=0x00; OCR0=0;}
	MOV  R0,R8
	OR   R0,R9
	BRNE _0x58
	LDI  R30,LOW(0)
	OUT  0x18,R30
	OUT  0x31,R30
; 0000 0114 if(mode==1){setak(); wash(); dewater();bgm(); }
_0x58:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x59
	RCALL _setak
	RCALL _wash
	RCALL _dewater
	RCALL _bgm
; 0000 0115 if(mode==2){wash();dewater();bgm();}
_0x59:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x5A
	RCALL _wash
	RCALL _dewater
	RCALL _bgm
; 0000 0116 if(mode==3){dewater();bgm();}
_0x5A:
	RCALL SUBOPT_0x13
	BRNE _0x5B
	RCALL _dewater
	RCALL _bgm
; 0000 0117 }
_0x5B:
; 0000 0118 }
_0x57:
; 0000 0119 }
_0x56:
	RJMP _0x51
; 0000 011A }
_0x5C:
	RJMP _0x5C
; .FEND

	.DSEG
_0x55:
	.BYTE 0xC
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	RCALL __SAVELOCR6
	MOVW R18,R26
	LDD  R21,Y+6
	ADIW R26,2
	__GETW1P
	SBIW R30,0
	BREQ _0x2000010
	MOVW R26,R18
	RCALL SUBOPT_0x18
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1RNS 18,4
_0x2000012:
	MOVW R26,R18
	ADIW R26,2
	RCALL SUBOPT_0x10
	SBIW R30,1
	ST   Z,R21
_0x2000013:
	MOVW R26,R18
	__GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x10
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	MOVW R26,R18
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x19
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x19
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x1A
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x1B
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1C
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1C
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x1A
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x1A
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RCALL SUBOPT_0x18
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x19
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x1B
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR6
	MOVW R30,R28
	__ADDW1R15
	__GETWRZ 20,21,14
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080003
_0x2000072:
	MOVW R26,R28
	ADIW R26,8
	__ADDW2R15
	MOVW R16,R26
	__PUTWSR 20,21,8
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
	MOVW R26,R28
	ADIW R26,12
	__ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,12
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080003:
	RCALL __LOADLOCR6
	ADIW R28,12
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 27
	SBI  0x15,2
	__DELAY_USB 27
	CBI  0x15,2
	__DELAY_USB 27
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	RCALL SUBOPT_0x0
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	STS  __lcd_x,R16
	STS  __lcd_y,R17
_0x2080002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2020005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	CPI  R17,10
	BRNE _0x2020007
	RJMP _0x2080001
_0x2020007:
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x2020008:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	STS  __lcd_maxx,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1E
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	LD   R17,Y+
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_res_cnt:
	.BYTE 0x2
_i:
	.BYTE 0x2
_pause:
	.BYTE 0x2
_range:
	.BYTE 0x2
_data:
	.BYTE 0x50
_data2:
	.BYTE 0x50
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	STS  122,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _sound
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _sound
	LDI  R26,LOW(166)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _sound
	LDI  R26,LOW(166)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _sound
	LDI  R26,LOW(166)
	LDI  R27,0
	RCALL _delay_ms
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(9)
	RJMP _sound

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	RCALL _delay_ms
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(11)
	RCALL _sound
	LDI  R26,LOW(166)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x6:
	RCALL _sound
	LDI  R26,LOW(166)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(5)
	RJMP _sound

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(5)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xB:
	RCALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0xD:
	LDS  R26,_pause
	LDS  R27,_pause+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDS  R30,_res_cnt
	LDS  R31,_res_cnt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x10:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x11:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(177)
	STS  137,R30
	LDI  R30,LOW(224)
	STS  136,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	MOVW R26,R4
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	__CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	ADIW R26,4
	__GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x19:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 400
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
