
$include (SI_EFM8BB3_Defs.inc)







ADC_OV	    equ   	P0.1
ADC_UV	    equ   	P0.2
AUTOZ_IN    equ   	P0.3
UART_TX	    equ   	P0.4
UART_RX     equ   	P0.5
SPI_CLK	    equ   	P0.6
SPI_MISO    equ   	P0.7

SPI_MOSI	equ		P1.0
CS_PDA		equ		P1.1
S2			equ		P1.2
S1			equ		P1.3
ENCODER_A	equ		P1.4
ENCODER_B	equ		P1.5
ENCODER_MID	equ		P1.6
E			equ		P1.7

CS_DISPLAY	equ		P2.0
RST_DISPLAY	equ		P2.1
ADC_LP_FILTER	equ	P2.2
DE_RE		equ		P2.3
LED_GREEN	equ		P2.4
LED_RED		equ		P2.5
LED_WHITE	equ		P2.6

VREF		equ		P3.0
DAC_OUT		equ		P3.1
OVERLOAD    equ   	P3.2







FLAGS2          SEGMENT BIT
                RSEG    FLAGS2
ERROR:   		DBIT    1
Auto_zero_on:	DBIT	1
ADC_Pos:		DBIT	1
ADC_Neg:		DBIT	1
ADC_warten:		DBIT	1
GAIN_SET:		DBIT	1
OVERRANGE_P:	DBIT	1
OVERRANGE_N:	DBIT	1
DAC0_max:		DBIT	1
DAC0_min:		DBIT	1
BIT_OVERVOLT:	DBIT	1
BIT_OVERRANGE:	DBIT	1
BIT_AUTOZ:		DBIT	1
encoder_down:	DBIT	1
encoder_up:		DBIT	1
SPI_Display:	DBIT	1
wait_for_SPI:	DBIT	1
SONDERMENU:		DBIT	1
display_clr:	DBIT	1
Init_Display_OK:DBIT	1
display_clear:	DBIT	1
overheat:		DBIT	1
bootscreen_ok:	DBIT	1
write_ok:		DBIT	1
write_OH:		DBIT	1
output_on:		DBIT	1
output_off:		DBIT	1
erste_zeile:	DBIT	1
OutputVoltage:	DBIT	1
set_R3:			DBIT	1
R3_Overheat:	DBIT	1
write_MENU:		DBIT	1
R3_SONDERMENU:	DBIT	1
T1_blink:		DBIT	1
zweite_zeile:	DBIT	1
dritte_zeile:	DBIT	1
BIT_GAIN_500:	DBIT	1
BIT_GAIN_1K:	DBIT	1
BIT_GAIN_2K:	DBIT	1
BIT_GAIN_5K:	DBIT	1
BIT_GAIN_10K:	DBIT	1
BIT_GAIN_25K:	DBIT	1
BIT_GAIN_50K:	DBIT	1
BIT_GAIN_60K:	DBIT	1
LCD_fertig:		DBIT	1
SET_GAIN:		DBIT	1
SET_AUTOZERO:	DBIT	1
OVERVOLT_P:		DBIT	1
OVERVOLT_N:		DBIT	1
ADC_WC_SET:		DBIT	1
BLINK_LCD:		DBIT	1
OUTPUT_POSITIV:	DBIT	1
OUTPUT_NEGATIV:	DBIT	1
bootscreen_loading: DBIT	1
stufe1:			DBIT	1
stufe2:			DBIT	1
stufe3:			DBIT	1
stufe4:			DBIT	1
LP_1000HZ:		DBIT	1
LP_300HZ:		DBIT	1
LP_50HZ:		DBIT	1
LP_OFF:			DBIT	1
KALIBRIEREN:	DBIT	1
KALIB_end:		DBIT	1
standby:		DBIT	1
press_screen_ok:DBIT	1
settings_saved:	DBIT	1
selbsttest:		DBIT	1
option_menu:	DBIT	1
LOCKED:			DBIT	1
encoder_middle:	DBIT	1
Mittelwert_high:DBIT	1
ADC_messen:		DBIT	1
RS485_mode:		DBIT	1
RS485_ID:		DBIT	1
PAGE2:			DBIT 	1
RS485_DATA:		DBIT	1
UART_SENDEN:	DBIT	1






            cseg   	AT 0
            ljmp   	Init

            org		0x0b
			ljmp	Timer0




			org		0x2b
			ljmp	Timer2

			org		0x23
			ljmp	UART0_0

			org		33h
			ljmp	SPI_int

			org		0x43
			ljmp	Portmatch

			org		0x4b
			ljmp	ADC_WINDOW

			org		0x53
			ljmp	ADC_1

			org		0x73
			ljmp	T3_OVERFLOW





UART0_0:	push	ACC
			push	PSW
			mov		SFRPAGE, #00h
			mov		TMOD, #20h

			jb		UART_SENDEN, UART0_SEND
			ljmp	UART0_00


UART0_SEND:	mov		DPTR, #000Fh
UART0_SEND1:jnb		SCON0_TI, $
			clr		SCON0_TI
			inc		DPTR
			movx	A, @DPTR
			jz		UART0_SEND2
			mov		SBUF0, A
			jmp		UART0_SEND1
UART0_SEND2:clr		UART_SENDEN
			ljmp	UART0_END1


UART0_00:	mov		B, #16d
			mov		DPTR, #00h
UART0_01:	mov		A, #00h
			movx	@DPTR, A
			djnz	B, UART0_02
			jmp		UART0_03
UART0_02:	inc		DPTR
			jmp		UART0_01


UART0_03:	mov		DPTR, #00h
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_1:	jb		SCON0_RI, UART0_2
			jnb		TCON_TF0, UART0_1
			ljmp	UART0_40


UART0_2:	mov		DPTR, #01h
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_3:	jb		SCON0_RI, UART0_4
			jnb		TCON_TF0, UART0_3
			ljmp	UART0_40


UART0_4:	mov		DPTR, #02h
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_5:	jb		SCON0_RI, UART0_6
			jnb		TCON_TF0, UART0_5
			ljmp	UART0_40


UART0_6:	mov		DPTR, #03h
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_7:	jb		SCON0_RI, UART0_8
			jnb		TCON_TF0, UART0_7
			ljmp	UART0_40


UART0_8:	mov		DPTR, #04h
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_9:	jb		SCON0_RI, UART0_10
			jnb		TCON_TF0, UART0_9
			ljmp	UART0_40


UART0_10:	mov		DPTR, #05h
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_11:	jb		SCON0_RI, UART0_12
			jnb		TCON_TF0, UART0_11
			ljmp	UART0_40


UART0_12:	mov		DPTR, #06h
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_13:	jb		SCON0_RI, UART0_14
			jnb		TCON_TF0, UART0_13
			ljmp	UART0_40


UART0_14:	mov		DPTR, #07h
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_15:	jb		SCON0_RI, UART0_16
			jnb		TCON_TF0, UART0_15
			ljmp	UART0_40


UART0_16:	mov		DPTR, #08h
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_17:	jb		SCON0_RI, UART0_18
			jnb		TCON_TF0, UART0_17
			ljmp	UART0_40


UART0_18:	mov		DPTR, #09h
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_19:	jb		SCON0_RI, UART0_20
			jnb		TCON_TF0, UART0_19
			ljmp	UART0_40


UART0_20:	mov		DPTR, #0Ah
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_21:	jb		SCON0_RI, UART0_22
			jnb		TCON_TF0, UART0_21
			ljmp	UART0_40


UART0_22:	mov		DPTR, #0Bh
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_23:	jb		SCON0_RI, UART0_24
			jnb		TCON_TF0, UART0_23
			ljmp	UART0_40


UART0_24:	mov		DPTR, #0Ch
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_25:	jb		SCON0_RI, UART0_26
			jnb		TCON_TF0, UART0_25
			ljmp	UART0_40


UART0_26:	mov		DPTR, #0Dh
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_27:	jb		SCON0_RI, UART0_28
			jnb		TCON_TF0, UART0_27
			ljmp	UART0_40


UART0_28:	mov		DPTR, #0Eh
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_29:	jb		SCON0_RI, UART0_30
			jnb		TCON_TF0, UART0_29
			ljmp	UART0_40


UART0_30:	mov		DPTR, #0Fh
			mov		A,SBUF0
			movx	@DPTR, A
			clr		SCON0_RI

			mov		TH0, #1Dh
			mov		TL0, #00h
			clr		TCON_TF0
UART0_31:	jb		SCON0_RI, UART0_39
			jnb		TCON_TF0, UART0_31
			ljmp	UART0_40

UART0_39:	jmp		UART0_END
UART0_40:	nop
UART0_END:	setb	RS485_DATA
UART0_END1:	mov		SCON0, #70h
			mov		TMOD, #22h
			pop		PSW
			pop		ACC
			reti


Timer0:		push	ACC
			push	PSW
			clr		TCON_TF0

			pop		PSW
			pop		ACC
			reti













Timer2:		push	ACC
			push	PSW
			mov		TMR2CN0, #04h
			jb		kalibrieren, Timer2_4
			djnz	0x4A, Timer2_4
			mov		0x4A, #14d
			setb	ADC_messen
Timer2_4:	pop		PSW
			pop		ACC
			reti


T3_OVERFLOW:push	ACC
			push	PSW
			mov		TMR3H, #00h
			mov		TMR3L, #00h
			mov		TMR3CN0, #04h


			jnb		bootscreen_ok, Timer3_3
			jb		GAIN_SET, Timer3_0
			djnz	0x31, Timer3_0
			mov		0x31, #90h
			mov		A, 0x1F
			mov		R4, 0x1F
			clr		GAIN_SET
			setb	SET_GAIN
			mov		P0MASK, #08h



Timer3_0:	jb		Auto_zero_on, Timer3_2
			jb		BIT_OVERRANGE, Timer3_3
			jnb		BIT_OVERVOLT, Timer3_3
			djnz	0x08, Timer3_1
			mov		0x08, #20h
			cpl		BLINK_LCD

Timer3_1:	jb		BLINK_LCD, Timer3_2
			clr		LED_GREEN
			setb	LED_RED
			clr		LED_WHITE
			jmp		Timer3_3
Timer3_2:	clr		LED_GREEN
			clr		LED_RED
			setb	LED_WHITE
			jmp		Timer3_3

Timer3_3:	pop		PSW
			pop		ACC
			reti



SPI_int:	push	ACC
			push	PSW
			clr		SPI0CN0_SPIF       ;Clean Int bit
			mov		SFRPAGE, #20h
			mov		SPI0FCN0, #44h
			mov		SFRPAGE, #00h

			jnb		SPI_DISPLAY, SPI_end
			clr		CS_DISPLAY
			mov		TH0, #0FFh
			mov		TL0, #0FEh
			clr		TCON_TF0
			jnb		TCON_TF0, $

SPI1:		mov		SPI0DAT, 0x11
			mov		SFRPAGE, #20h
SPI2:		mov		A, SPI0FCT
			orl		A, #00001111b
			cjne	A, #0Fh, SPI2
			mov		SFRPAGE, #00h
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			mov		SPI0DAT, 0x12
			mov		SFRPAGE, #20h
SPI3:		mov		A, SPI0FCT
			orl		A, #00001111b
			cjne	A, #0Fh, SPI3
			mov		SFRPAGE, #00h
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			mov		SPI0DAT, 0x13
			mov		SFRPAGE, #20h
SPI4:		mov		A, SPI0FCT
			orl		A, #00001111b
			cjne	A, #0Fh, SPI4
			mov		SFRPAGE, #00h
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
SPI5:		mov		A, SPI0CFG
			orl		A, #01111111b
			cjne	A, #7Fh, SPI5
SPI6:		setb	CS_DISPLAY
			clr		SPI_Display
			setb	wait_for_SPI
SPI_end:	pop		PSW
			pop		ACC
			reti



Portmatch:	push	ACC
			push	PSW
			mov		P0MAT, #0FFh
			mov		A, P1MAT
			cjne	A, #0FFh, help
			jb		bootscreen_ok, Portmatch0
			ljmp	Portmatch22

help:		ljmp	Portmatch6

Portmatch0:	jb		AUTOZ_IN,Portmatch01
			jb		LOCKED, Portmatch00
			jb		RS485_mode, Portmatch00
			setb	SET_AUTOZERO
			mov		P0MAT, #0F7h
Portmatch00:jmp		Portmatch22

Portmatch01:jnb		ENCODER_MID, Portmatch5
			jb		RS485_mode, Portmatch00
			jnb		ENCODER_B, Portmatch1
			jnb		ENCODER_A, Portmatch2
			jmp		Portmatch22
Portmatch1:	jnb		ENCODER_B, Portmatch1
			jnb		ENCODER_A, Portmatch1
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			jnb		ENCODER_B, Portmatch1
			jnb		ENCODER_A, Portmatch1

			setb	encoder_down
			clr		encoder_up
			clr		encoder_middle
			mov		P0MASK, #00h
			mov		0x31, #90h
			mov		0x47, #01h
			jmp		Portmatch6

Portmatch2:	jnb		ENCODER_A, Portmatch2
			jnb		ENCODER_B, Portmatch2
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			jnb		ENCODER_A, Portmatch2
			jnb		ENCODER_B, Portmatch2

			setb	encoder_up
			clr		encoder_down
			clr		encoder_middle
			mov		P0MASK, #00h
			mov		0x31, #90h
			mov		0x47, #01h

			jmp		Portmatch22

Portmatch5:	mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			jb		ENCODER_MID, Portmatch22
			jb		option_menu, Portmatch51
			setb	SET_GAIN
			mov		0x47, #70h
			jmp		Portmatch6

Portmatch51:setb	encoder_middle


Portmatch6:	mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			djnz	0x47, Portmatch6
			mov		0x47, #0FFh
			mov		0x48, #0Fh
			mov		P1MAT, #0FFh
			jmp		Portmatch20


Portmatch20:jnb		ENCODER_mid, Portmatch21
			jmp		Portmatch22
Portmatch21:jnb		TCON_TF0, Portmatch20
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			mov		A, 0x47
			djnz	0x47, Portmatch20
			mov		0x47, #0FFh
			djnz	0x48, Portmatch20

			jnb		GAIN_SET, Portmatch22
			setb	option_menu
			mov		R3, #00h
			clr		Init_Display_OK
			mov		P1MAT, #0BFh

				mov		0x47, #05h
				mov		TMOD, #21h
Portmatch21_1:	mov		TH0, #00h
				mov		TL0, #00h
				clr		TCON_TF0
				jnb		TCON_TF0, $
				djnz	0x47, Portmatch21_1
				mov		TMOD, #22h

Portmatch22:pop		PSW
			pop		ACC
			reti



ADC_WINDOW:	push	ACC
			push	PSW
			setb	ADC_WC_SET
			clr		ADC0CN0_ADWINT
			pop		PSW
			pop		ACC
			reti

ADC_1:		push	ACC
			push	PSW
			clr 	ADC0CN0_ADINT
			mov		R1, ADC0H
			mov		R2, ADC0L
ADC_end:	setb	ADC_warten
			pop		PSW
			pop		ACC
			reti





Init:

           	CLR IE_EA
			MOV WDTCN,#0DEh
			MOV WDTCN,#0ADh
			SETB IE_EA

			mov		SP, #60h

			mov		CLKSEL, #00h


            mov		XBR0, #03h
            mov		XBR1, #00h
            mov   	XBR2, #0C0h

			mov		P0SKIP, #0Fh
           	mov 	P0MDIN, #0F9h
            mov   	P0MDOUT, #51h

            mov   	P1MDIN,  #0FFh
            mov		P1MDOUT, #08Fh
			mov		P1MASK, #70h

            mov		SFRPAGE, #20h
            mov   	P2MDIN,  #0FBh
            mov		P2MDOUT, #7Bh
            mov		SFRPAGE, #00h

            mov		SFRPAGE, #20h
            mov   	P3MDIN,  #0FFh
            mov		P3MDOUT, #0Ch
            mov		SFRPAGE, #00h

            mov		REF0CN, #40h
            mov		SFRPAGE, #30h
			mov		DAC0CF0, #80h
			mov		DAC1CF0, #80h
			mov		DAC0CF1, #01h
			mov		DAC1CF1, #01h
			mov		DAC0L, #00h
			mov		DAC0H, #08h
			mov		DAC1L, #00h
			mov		DAC1H, #08h
			mov		DACGCF0, #88h
			mov		SFRPAGE, #00h


			mov		SCON0, #70h


            mov		CKCON0, #02h
			mov		TCON, #0D2h
			mov		TMOD, #22h
			mov		TH1, #0E4h


			mov		TMR2CN0, #04h
			mov		TMR2RLH, #00h
			mov		TMR2RLL, #00h


			mov		TMR3CN0, #04h



			mov		IE, #0E0h

			mov		EIE1, #0Ah


			mov		SPI0CFG, #47h
			mov		SPI0CKR, #01h
			mov		SPI0CN0, #03h
			mov		SFRPAGE,#20h
			mov		SPI0FCN0, #00h
			mov		SFRPAGE, #00h


			mov		ADC0CN0, #0A0h
			mov		ADC0CF2, #1Fh
			clr 	ADC0CN0_ADWINT
			clr 	ADC0CN0_ADINT
			mov		REF0CN, #80h


			mov		R0,#01h
			mov		R1, #00h
			mov		R2, #00h
			mov		R3, #00h
			mov		R4,	#00h
			mov		R5,	#08h
			mov		R6,	#00h
			mov		R7, #0FFh
			mov		0x08, #20h

			mov		0x0A, #00h
			mov		0x0B, #00h
			mov		0x0C, #00h
			mov		0x0D, #00h
			mov		0x0E, #00h
			mov		0x0F, #2d


			mov		0x10,#00h
			mov		0x11,#00h
			mov		0x12,#00h
			mov		0x13,#00h


			mov		0x15,#00h
			mov		0x16,#00h
			mov		0x17,#00h
			mov		0x18,#00h
			mov		0x19,#00h
			mov		0x1A,#00h


			mov		0x1D, #1d



















			mov		0x31, #90h
			mov		0x32, #00h
			mov		0x33, #00h
			mov		0x34, #00h
			mov		0x35, #00h
			mov		0x36, #00h
			mov		0x37, #00h
			mov		0x38, #00h
			mov		0x39, #00h
			mov		0x3A, #00h
			mov		0x3B, #00h
			mov		0x3C, #00h
			mov		0x3D, #00h
			mov		0x3E, #00h
			mov		0x3F, #00h
			mov		0x40, #00h
			mov		0x41, #00h

			mov		0x42, #00h
			mov		0x43, #00h
			mov		0x44, #00h
			mov		0x45, #00h
			mov		0x46, #00h
			mov		0x47, #00h
			mov		0x48, #00h
			mov		0x49, #00h
			mov		0x4A, #01h
			mov		0x4B, #01d
			mov		0x4C, #00h



			mov		0x50, #00h
			mov		0x51, #00h
			mov		0x52, #00h
			mov		0x53, #00h
			mov		0x54, #00h
			mov		0x55, #00h
			mov		0x56, #00h
			mov		0x57, #00h
			mov		0x58, #00h
			mov		0x59, #00h
			mov		0x5A, #00h
			mov		0x5B, #00h
			mov		0x5C, #00h
			mov		0x5D, #00h
			mov		0x5E, #00h
			mov		0x5F, #00h










			mov		0x6A, #0FFh
			mov		0x6B, #03h
			mov		0x6C, #00h
			mov		0x6D, #00h
			mov		0x6E, #00h
			mov		0x6F, #00h
			mov		0x70, #00h
			mov		0x71, #00h
			mov		0x72, #00h
			mov		0x73, #00h
			mov		0x74, #00h
			mov		0x75, #00h
			mov		0x76, #00h
			mov		0x77, #00h
			mov		0x78, #00h
			mov		0x79, #00h
			mov		0x7A, #00h






			clr		ERROR

			clr		S1
			clr		S2
			;clr		S3








			mov		R7, #06h
start0:		jb		TCON_TF0, start1
			jmp		start0
start1:		clr 		TCON_TF0
			djnz	R7, start0
			clr		Auto_zero_on
			clr		ADC_Pos
			clr		ADC_Neg
			clr		ADC_warten
			clr		BIT_OVERVOLT
			clr		BIT_OVERRANGE
			setb	E
			clr		RST_DISPLAY
			clr		GAIN_SET
			clr		OVERRANGE_N
			clr		OVERRANGE_P
			clr		OVERLOAD
			clr		DAC0_max
			clr		DAC0_min
			clr		BIT_GAIN_500
			clr		BIT_GAIN_1K
			clr		BIT_GAIN_2K
			clr		BIT_GAIN_5K
			clr		BIT_GAIN_10K
			clr		BIT_GAIN_25K
			clr		BIT_GAIN_50K
			clr		BIT_GAIN_60K
			clr		press_screen_ok
			clr		LED_GREEN
			clr		LED_RED
			setb	LED_WHITE
			clr		display_clr
			clr		SET_AUTOZERO
			clr		wait_for_SPI
			clr		SPI_Display
			clr		Init_Display_OK
			setb	CS_DISPLAY
			clr		write_ok
			clr		bootscreen_ok
			clr		write_OH
			clr		display_clear
			clr		overheat
			setb	output_off
			clr		output_on
			clr		set_R3
			clr		encoder_up
			clr		encoder_down
			clr		RST_DISPLAY
			clr		display_clr
			clr		LCD_fertig
			clr		SET_GAIN
			mov		ADC0H, #00h
			mov		ADC0L, #00h
			clr		ADC_WC_SET
			clr		bootscreen_loading
			clr		KALIBRIEREN
			clr		standby
			clr		settings_saved
			clr		selbsttest
			clr		option_menu
			clr		LOCKED
			clr		Mittelwert_high
			clr		RS485_mode
			clr		PAGE2
			clr		RS485_ID
			clr		UART_SENDEN

			mov		SFRPAGE, #30h
			mov		R5, DAC0H
			mov		R6, DAC0L
			mov		SFRPAGE, #00h

			clr		SONDERMENU
			clr		write_MENU
			clr		R3_SONDERMENU
			setb	OutputVoltage


			mov		TMOD, #21h
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		TMOD, #22h
			setb	RST_DISPLAY

			jb		AUTOZ_IN, start_01
			;setb	KALIBRIEREN
			clr		KALIB_end
			ljmp	main50


start_01:
			clr		A
			MOV 	DPTR,#0F000h
			MOVC 	A, @A+DPTR
			cjne	A, #04h, start_02
			setb	RS485_mode

			setb	IE_ES0
			clr		DE_RE
			mov		0x1D, #04h
			setb	PAGE2
			setb	SET_GAIN

start_02:	clr		A
			MOV 	DPTR,#0F001h
			MOVC 	A, @A+DPTR
			clr		C
			cjne	A, #09h, start_03
start_03:	jc		start_04
			mov		0x4B, #01h
			jmp		start_05
start_04:	mov		0x4B, A


start_05:	mov		P0MASK, #08h
			clr		A
			MOV 	DPTR,#0F910h
			MOVC 	A, @A+DPTR
			mov		0x32, A
			clr		A
			MOV 	DPTR,#0F911h
			MOVC 	A, @A+DPTR
			mov		0x33, A
			clr		A

			MOV 	DPTR,#0F912h
			MOVC 	A, @A+DPTR
			mov		0x34, A
			clr		A
			MOV 	DPTR,#0F913h
			MOVC 	A, @A+DPTR
			mov		0x35, A
			clr		A

			MOV 	DPTR,#0F914h
			MOVC 	A, @A+DPTR
			mov		0x36, A
			clr		A
			MOV 	DPTR,#0F915h
			MOVC 	A, @A+DPTR
			mov		0x37, A
			clr		A

			MOV 	DPTR,#0F916h
			MOVC 	A, @A+DPTR
			mov		0x38, A
			clr		A
			MOV 	DPTR,#0F917h
			MOVC 	A, @A+DPTR
			mov		0x39, A
			clr		A

			MOV 	DPTR,#0F918h
			MOVC 	A, @A+DPTR
			mov		0x3A, A
			clr		A
			MOV 	DPTR,#0F919h
			MOVC 	A, @A+DPTR
			mov		0x3B, A
			clr		A

			MOV 	DPTR,#0F91Ah
			MOVC 	A, @A+DPTR
			mov		0x3C, A
			clr		A
			MOV 	DPTR,#0F91Bh
			MOVC 	A, @A+DPTR
			mov		0x3D, A
			clr		A

			MOV 	DPTR,#0F91Ch
			MOVC 	A, @A+DPTR
			mov		0x3E, A
			clr		A
			MOV 	DPTR,#0F91Dh
			MOVC 	A, @A+DPTR
			mov		0x3F, A
			clr		A

			MOV 	DPTR,#0F91Eh
			MOVC 	A, @A+DPTR
			mov		0x40, A
			clr		A
			MOV 	DPTR,#0F91Fh
			MOVC 	A, @A+DPTR
			mov		0x41, A
			clr		A



			MOV 	DPTR,#0F920h
			MOVC 	A, @A+DPTR
			mov		0x52, A
			clr		A
			MOV 	DPTR,#0F921h
			MOVC 	A, @A+DPTR
			mov		0x53, A
			clr		A

			MOV 	DPTR,#0F922h
			MOVC 	A, @A+DPTR
			mov		0x54, A
			clr		A
			MOV 	DPTR,#0F923h
			MOVC 	A, @A+DPTR
			mov		0x55, A
			clr		A

			MOV 	DPTR,#0F924h
			MOVC 	A, @A+DPTR
			mov		0x56, A
			clr		A
			MOV 	DPTR,#0F925h
			MOVC 	A, @A+DPTR
			mov		0x57, A
			clr		A

			MOV 	DPTR,#0F926h
			MOVC 	A, @A+DPTR
			mov		0x58, A
			clr		A
			MOV 	DPTR,#0F927h
			MOVC 	A, @A+DPTR
			mov		0x59, A
			clr		A

			MOV 	DPTR,#0F928h
			MOVC 	A, @A+DPTR
			mov		0x5A, A
			clr		A
			MOV 	DPTR,#0F929h
			MOVC 	A, @A+DPTR
			mov		0x5B, A
			clr		A

			MOV 	DPTR,#0F92Ah
			MOVC 	A, @A+DPTR
			mov		0x5C, A
			clr		A
			MOV 	DPTR,#0F92Bh
			MOVC 	A, @A+DPTR
			mov		0x5D, A
			clr		A

			MOV 	DPTR,#0F92Ch
			MOVC 	A, @A+DPTR
			mov		0x5E, A
			clr		A
			MOV 	DPTR,#0F92Dh
			MOVC 	A, @A+DPTR
			mov		0x5F, A
			clr		A

			MOV 	DPTR,#0F92Eh
			MOVC 	A, @A+DPTR
			mov		0x50, A
			clr		A
			MOV 	DPTR,#0F92Fh
			MOVC 	A, @A+DPTR
			mov		0x51, A
			clr		A

			MOV 	DPTR,#0F200h
			MOVC 	A, @A+DPTR

			cjne	A, #1d, start_06
			setb	BIT_GAIN_500
			clr		BIT_GAIN_1K
			clr		BIT_GAIN_2K
			clr		BIT_GAIN_5K
			clr		BIT_GAIN_10K
			clr		BIT_GAIN_25K
			clr		BIT_GAIN_50K
			clr		BIT_GAIN_60K
			mov		R4,	#00h
			mov		0x1F, R4
			ljmp	main50
start_06:	cjne	A, #2d, start_07
			clr		BIT_GAIN_500
			setb	BIT_GAIN_1K
			clr		BIT_GAIN_2K
			clr		BIT_GAIN_5K
			clr		BIT_GAIN_10K
			clr		BIT_GAIN_25K
			clr		BIT_GAIN_50K
			clr		BIT_GAIN_60K
			mov		R4,	#01h
			mov		0x1F, R4
			ljmp	main50
start_07:	cjne	A, #3d, start_08
			clr		BIT_GAIN_500
			clr		BIT_GAIN_1K
			setb	BIT_GAIN_2K
			clr		BIT_GAIN_5K
			clr		BIT_GAIN_10K
			clr		BIT_GAIN_25K
			clr		BIT_GAIN_50K
			clr		BIT_GAIN_60K
			mov		R4,	#02h
			mov		0x1F, R4
			ljmp	main50
start_08:	cjne	A, #4d, start_09
			clr		BIT_GAIN_500
			clr		BIT_GAIN_1K
			clr		BIT_GAIN_2K
			setb	BIT_GAIN_5K
			clr		BIT_GAIN_10K
			clr		BIT_GAIN_25K
			clr		BIT_GAIN_50K
			clr		BIT_GAIN_60K
			mov		R4,	#03h
			mov		0x1F, R4
			ljmp	main50
start_09:	cjne	A, #5d, start_10
			clr		BIT_GAIN_500
			clr		BIT_GAIN_1K
			clr		BIT_GAIN_2K
			clr		BIT_GAIN_5K
			setb	BIT_GAIN_10K
			clr		BIT_GAIN_25K
			clr		BIT_GAIN_50K
			clr		BIT_GAIN_60K
			mov		R4,	#04h
			mov		0x1F, R4
			ljmp	main50
start_10:	cjne	A, #6d, start_11
			clr		BIT_GAIN_500
			clr		BIT_GAIN_1K
			clr		BIT_GAIN_2K
			clr		BIT_GAIN_5K
			clr		BIT_GAIN_10K
			setb	BIT_GAIN_25K
			clr		BIT_GAIN_50K
			clr		BIT_GAIN_60K
			mov		R4,	#05h
			mov		0x1F, R4
			ljmp	main50
start_11:	cjne	A, #7d, start_12
			clr		BIT_GAIN_500
			clr		BIT_GAIN_1K
			clr		BIT_GAIN_2K
			clr		BIT_GAIN_5K
			clr		BIT_GAIN_10K
			clr		BIT_GAIN_25K
			setb	BIT_GAIN_50K
			clr		BIT_GAIN_60K
			mov		R4,	#06h
			mov		0x1F, R4
			ljmp	main50
start_12:	cjne	A, #8d, start_13
			clr		BIT_GAIN_500
			clr		BIT_GAIN_1K
			clr		BIT_GAIN_2K
			clr		BIT_GAIN_5K
			clr		BIT_GAIN_10K
			clr		BIT_GAIN_25K
			clr		BIT_GAIN_50K
			setb	BIT_GAIN_60K
			mov		R4,	#07h
			mov		0x1F, R4
start_13:	ljmp	main50





main:		jnb		RS485_DATA, UART_00
			clr		RS485_DATA
			jmp		UART_500
UART_00:	ljmp	main0

UART_500:	mov		0x7F, #1d
			mov		DPTR, #0000h
UART_500_1:	mov		A, 0x7F
			cjne	A, #4d, UART_500_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, UART_1K
			jmp		UART_500_3
UART_500_2:	call 	UART_500_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, UART_1K
UART_500_3:	inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,UART_500_1
			ljmp	set_Gain500
UART_500_4:	movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		35h
			DB		30h
			DB		30h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


UART_1K:	mov		0x7F, #1d
			mov		DPTR, #0000h
UART_1K_1:	mov		A, 0x7F
			cjne	A, #4d, UART_1K_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, UART_2K
			jmp		UART_1K_3
UART_1K_2:	call 	UART_1K_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, UART_2K
UART_1K_3:	inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,UART_1K_1
			ljmp	set_Gain1K
UART_1K_4:	movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		31h
			DB		30h
			DB		30h
			DB		30h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


UART_2K:	mov		0x7F, #1d
			mov		DPTR, #0000h
UART_2K_1:	mov		A, 0x7F
			cjne	A, #4d, UART_2K_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, UART_5K
			jmp		UART_2K_3
UART_2K_2:	call 	UART_2K_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, UART_5K
UART_2K_3:	inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,UART_2K_1
			ljmp	set_Gain2K
UART_2K_4:	movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		32h
			DB		30h
			DB		30h
			DB		30h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


UART_5K:	mov		0x7F, #1d
			mov		DPTR, #0000h
UART_5K_1:	mov		A, 0x7F
			cjne	A, #4d, UART_5K_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, UART_10K
			jmp		UART_5K_3
UART_5K_2:	call 	UART_5K_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, UART_10K
UART_5K_3:	inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,UART_5K_1
			ljmp	set_Gain5K
UART_5K_4:	movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		35h
			DB		30h
			DB		30h
			DB		30h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


UART_10K:	mov		0x7F, #1d
			mov		DPTR, #0000h
UART_10K_1:	mov		A, 0x7F
			cjne	A, #4d, UART_10K_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, UART_25K
			jmp		UART_10K_3
UART_10K_2:	call 	UART_10K_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, UART_25K
UART_10K_3:	inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,UART_10K_1
			ljmp	set_Gain10K
UART_10K_4:	movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		31h
			DB		30h
			DB		30h
			DB		30h
			DB		30h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


UART_25K:	mov		0x7F, #1d
			mov		DPTR, #0000h
UART_25K_1:	mov		A, 0x7F
			cjne	A, #4d, UART_25K_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, UART_50K
			jmp		UART_25K_3
UART_25K_2:	call 	UART_25K_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, UART_50K
UART_25K_3:	inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,UART_25K_1
			ljmp	set_Gain25K
UART_25K_4:	movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		32h
			DB		30h
			DB		30h
			DB		30h
			DB		30h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


UART_50K:	mov		0x7F, #1d
			mov		DPTR, #0000h
UART_50K_1:	mov		A, 0x7F
			cjne	A, #4d, UART_50K_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, Voltage
			jmp		UART_50K_3
UART_50K_2:	call 	UART_50K_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, Voltage
UART_50K_3:	inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,UART_50K_1
			ljmp	set_Gain50K
UART_50K_4:	movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		34h
			DB		30h
			DB		30h
			DB		30h
			DB		30h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


Voltage:	mov		0x7F, #1d
			mov		DPTR, #0000h
Voltage_1:	mov		A, 0x7F
			cjne	A, #4d, Voltage_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, AUTOZERO
			jmp		Voltage_3
Voltage_2:	call 	Voltage_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, AUTOZERO
Voltage_3:	inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,Voltage_1
			ljmp	UART_VOLT_1
Voltage_4:	movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		56h
			DB		4Fh
			DB		4Ch
			DB		54h
			DB		3Fh
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


AUTOZERO:	mov		0x7F, #1d
			mov		DPTR, #0000h
AUTOZERO_1:	mov		A, 0x7F
			cjne	A, #4d, AUTOZERO_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, RESET
			jmp		AUTOZERO_3
AUTOZERO_2:	call 	AUTOZERO_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, RESET
AUTOZERO_3:	inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,AUTOZERO_1
			setb	SET_AUTOZERO
			ljmp	main
AUTOZERO_4:	movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		41h
			DB		5Ah
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


RESET:		mov		0x7F, #1d
			mov		DPTR, #0000h
RESET_1:	mov		A, 0x7F
			cjne	A, #4d, RESET_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, QUESTION
			jmp		RESET_3
RESET_2:	call 	RESET_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, QUESTION
RESET_3:	inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,RESET_1

			mov		LFO0CN, #0FFh
			mov		WDTCN, #0A5h
			mov		WDTCN, #01h
			jmp		$
RESET_4:	movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		52h
			DB		53h
			DB		54h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


QUESTION:	mov		0x7F, #1d
			mov		DPTR, #0000h
QUESTION_1:	mov		A, 0x7F
			cjne	A, #4d, QUESTION_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, SWV
			jmp		QUESTION_3
QUESTION_2:	call 	QUESTION_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, SWV
QUESTION_3:	inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,QUESTION_1
			ljmp	UART_WO_0
QUESTION_4:	movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		3Fh
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


SWV:		mov		0x7F, #1d
			mov		DPTR, #0000h
SWV_1:		mov		A, 0x7F
			cjne	A, #4d, SWV_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, SER
			jmp		SWV_3
SWV_2:		call 	SWV_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, SER
SWV_3:		inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,SWV_1
			ljmp	UART_SWV
SWV_4:		movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		53h
			DB		57h
			DB		56h
			DB		3Fh
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


SER:		mov		0x7F, #1d
			mov		DPTR, #0000h
SER_1:		mov		A, 0x7F
			cjne	A, #4d, SER_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, IDN
			jmp		SER_3
SER_2:		call 	SER_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, IDN
SER_3:		inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,SER_1
			ljmp	UART_SER
SER_4:		movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		53h
			DB		45h
			DB		52h
			DB		3Fh
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


IDN:		mov		0x7F, #1d
			mov		DPTR, #0000h
IDN_1:		mov		A, 0x7F
			cjne	A, #4d, IDN_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, SET_SER
			jmp		IDN_3
IDN_2:		call 	IDN_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, SET_SER
IDN_3:		inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #17d,IDN_1
			ljmp	UART_ID
IDN_4:		movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		20h
			DB		49h
			DB		44h
			DB		4Eh
			DB		3Fh
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


SET_SER:	mov		0x7F, #1d
			mov		DPTR, #0000h
SET_SER_1:	mov		A, 0x7F
			cjne	A, #4d, SET_SER_2
			mov		A, 0x4B
			call	TAB_HEX
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, SET_SER_5
			jmp		SET_SER_3
SET_SER_2:	call 	SET_SER_4
			mov		B, A
			movx	A, @DPTR
			cjne	A, B, SET_SER_5
SET_SER_3:	inc		DPTR
			inc		0x7F
			mov		A, 0x7F
			cjne	A, #11d,SET_SER_1
			ljmp	SET_SER_6
SET_SER_4:	movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		5Fh
			DB		40h
			DB		3Dh
			DB		53h
			DB		45h
			DB		52h
			ret

SET_SER_5:	ljmp	main
SET_SER_6: 	mov		DPTR, #0Fh
			movx	A, @DPTR
			cjne	A, #00h, SET_SER_5

			clr		IE_EA

			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000011b
			MOV 	DPTR,#0E000h
			clr		A
			movx	@DPTR, A
			mov		PSCTL, #00000000b


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b

			mov		DPTR, #0Ah
			movx	A, @DPTR

			MOV 	DPTR,#0E000h
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A

			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b

			mov		DPTR, #0Bh
			movx	A, @DPTR

			MOV 	DPTR,#0E001h
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A

			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b

			mov		DPTR, #0Ch
			movx	A, @DPTR

			MOV 	DPTR,#0E002h
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A

			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b

			mov		DPTR, #0Dh
			movx	A, @DPTR

			MOV 	DPTR,#0E003h
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A

			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b

			mov		DPTR, #0Eh
			movx	A, @DPTR

			MOV 	DPTR,#0E004h
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A
			setb	IE_EA
UART_10:	ljmp	main0



UART_WO_0:	mov		DPTR, #0010h
			mov		A, #44h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #56h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #3Ah
			movx	@DPTR, A
			inc		DPTR
			mov		A, 0x4B
			call	TAB_HEX
			movx	@DPTR, A
			inc		DPTR
			mov		A, #3Dh
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A


			mov		A, R4
			cjne	A, #0d, UART_WO_1

			mov		DPTR, #0015h
			mov		A, #35h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #30h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #30h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A
			jmp		UART_SEND

UART_WO_1:	cjne	A, #1d, UART_WO_2
			mov		DPTR, #0015h
			mov		A, #31h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #4Bh
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A
			jmp		UART_SEND

UART_WO_2:	cjne	A, #2d, UART_WO_3
			mov		DPTR, #0015h
			mov		A, #32h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #4Bh
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A
			jmp		UART_SEND

UART_WO_3:	cjne	A, #3d, UART_WO_4
			mov		DPTR, #0015h
			mov		A, #35h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #4Bh
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A
			jmp		UART_SEND

UART_WO_4:	cjne	A, #4d, UART_WO_5
			mov		DPTR, #0015h
			mov		A, #31h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #30h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #4Bh
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A
			jmp		UART_SEND

UART_WO_5:	cjne	A, #5d, UART_WO_6
			mov		DPTR, #0015h
			mov		A, #32h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #30h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #4Bh
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A
			jmp		UART_SEND

UART_WO_6:	mov		DPTR, #0015h
			mov		A, #34h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #30h
			movx	@DPTR, A
			inc		DPTR
			mov		A, #4Bh
			movx	@DPTR, A
			inc		DPTR
			mov		A, #00h
			movx	@DPTR, A
			jmp		UART_SEND


UART_AZ_OK:	mov		B, #1d
			mov		DPTR, #0010h
UART_AZ_OK1:mov		A, B
			cjne	A, #4d, UART_AZ_OK2
			mov		A, 0x4B
			call	TAB_HEX
			jmp		UART_AZ_OK3
UART_AZ_OK2:call	TAB_AZ_OK
			cjne	A, #00h, UART_AZ_OK3
			movx	@DPTR, A
			jmp		UART_SEND
UART_AZ_OK3:movx	@DPTR, A
			inc		DPTR
			inc		B
			jmp		UART_AZ_OK1


TAB_AZ_OK:	movc	A,@A+PC
			ret

			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		3Dh
			DB		41h
			DB		55h
			DB		54h
			DB		4Fh
			DB		5Ah
			DB		45h
			DB		52h
			DB		4Fh
			DB		3Dh
			DB		4Fh
			DB		4Bh
			DB		00h
			ret









UART_VOLT_1:mov		B, #1d
			mov		DPTR, #0010h
UART_VOLT_2:mov		A, B
			cjne	A, #4d, UART_VOLT_3
			mov		A, 0x4B
			call	TAB_HEX
			jmp		UART_VOLT_18
UART_VOLT_3:cjne	A, #6d, UART_VOLT_12
			jnb		OUTPUT_POSITIV, UART_VOLT_4
			mov		A, #2Bh
			jmp		UART_VOLT_18
UART_VOLT_4:clr		C
			mov		A, 0x0A
			jnz		UART_VOLT_10
			mov		A, 0x0B
			jnz		UART_VOLT_10
			mov		A, 0x0C
			jnz		UART_VOLT_10
			mov		A, 0x0D
			jnz		UART_VOLT_10
			mov		A, 0x0E
			jnz		UART_VOLT_10
			jmp		UART_VOLT_11
UART_VOLT_10:mov		A, #2Dh
			jmp		UART_VOLT_18
UART_VOLT_11:mov		A, #20h
			jmp		UART_VOLT_18
UART_VOLT_12:cjne	A, #7d, UART_VOLT_13
			mov		A, 0x0A
			call	TAB_HEX
			jmp		UART_VOLT_18
UART_VOLT_13:cjne	A, #8d, UART_VOLT_14
			mov		A, 0x0B
			call	TAB_HEX
			jmp		UART_VOLT_18
UART_VOLT_14:cjne	A, #10d, UART_VOLT_15
			mov		A, 0x0C
			call	TAB_HEX
			jmp		UART_VOLT_18
UART_VOLT_15:cjne	A, #11d, UART_VOLT_16
			mov		A, 0x0D
			call	TAB_HEX
			jmp		UART_VOLT_18
UART_VOLT_16:cjne	A, #12d, UART_VOLT_17
			mov		A, 0x0E
			call	TAB_HEX
			jmp		UART_VOLT_18
UART_VOLT_17:call	UART_VOLT_19
			cjne	A, #00h, UART_VOLT_18
			movx	@DPTR, A
			jmp		UART_SEND
UART_VOLT_18:movx	@DPTR, A
			inc		DPTR
			inc		B
			jmp		UART_VOLT_2
UART_VOLT_19:movc	A,@A+PC
			ret
			DB		44h
			DB		56h
			DB		3Ah
			DB		20h
			DB		3Dh
			DB		2Bh
			DB		30h
			DB		30h
			DB		2Eh
			DB		30h
			DB		30h
			DB		30h
			DB		56h
			DB		00h
			DB		00h
			DB		00h
			DB		00h
			ret


UART_ID:	mov		B, #1d
			mov		DPTR, #0010h
UART_ID1:	mov		A, B
			cjne	A, #71d, UART_ID2
			clr		A
			MOV 	DPTR,#0E000h
			MOVC 	A, @A+DPTR
			mov		DPTR, #0056h
			jmp		UART_ID7
UART_ID2:	cjne	A, #72d, UART_ID3
			clr		A
			MOV 	DPTR,#0E001h
			MOVC 	A, @A+DPTR
			mov		DPTR, #0057h
			jmp		UART_ID7
UART_ID3:	cjne	A, #73d, UART_ID4
			clr		A
			MOV 	DPTR,#0E002h
			MOVC 	A, @A+DPTR
			mov		DPTR, #0058h
			jmp		UART_ID7
UART_ID4:	cjne	A, #74d, UART_ID5
			clr		A
			MOV 	DPTR,#0E003h
			MOVC 	A, @A+DPTR
			mov		DPTR, #0059h
			jmp		UART_ID7
UART_ID5:	cjne	A, #75d, UART_ID6
			clr		A
			MOV 	DPTR,#0E004h
			MOVC 	A, @A+DPTR
			mov		DPTR, #005Ah
			jmp		UART_ID7
UART_ID6:	call	TAB_ID
			cjne	A, #00h, UART_ID7
			movx	@DPTR, A
			jmp		UART_SEND
UART_ID7:	movx	@DPTR, A
			inc		DPTR
			inc		B
			jmp		UART_ID1
TAB_ID:		movc	A,@A+PC
			ret
			DB		56h
			DB		46h
			DB		54h
			DB		20h
			DB		56h
			DB		65h
			DB		63h
			DB		74h
			DB		6Fh
			DB		72h
			DB		66h
			DB		6Fh
			DB		72h
			DB		63h
			DB		65h
			DB		2Dh
			DB		54h
			DB		65h
			DB		63h
			DB		68h
			DB		6Eh
			DB		6Fh
			DB		6Ch
			DB		6Fh
			DB		67h
			DB		69h
			DB		65h
			DB		73h
			DB		20h
			DB		44h
			DB		56h
			DB		34h
			DB		30h
			DB		4Bh
			DB		20h
			DB		53h
			DB		6Fh
			DB		66h
			DB		74h
			DB		77h
			DB		61h
			DB		72h
			DB		65h
			DB		76h
			DB		65h
			DB		72h
			DB		73h
			DB		69h
			DB		6Fh
			DB		6Eh
			DB		3Ah
			DB		56h
			DB		31h
			DB		2Eh
			DB		30h
			DB		37h
			DB		20h
			DB		53h
			DB		65h
			DB		72h
			DB		69h
			DB		61h
			DB		6Ch
			DB		6Eh
			DB		75h
			DB		6Dh
			DB		62h
			DB		65h
			DB		72h
			DB		3Ah
			DB		78h
			DB		78h
			DB		78h
			DB		78h
			DB		78h
			DB		00h
			ret


UART_SWV:	mov		B, #1d
			mov		DPTR, #0010h
UART_SWV1:	mov		A, B
UART_SWV2:	call	UART_SWV4
			cjne	A, #00h, UART_SWV3
			movx	@DPTR, A
			jmp		UART_SEND
UART_SWV3:	movx	@DPTR, A
			inc		DPTR
			inc		B
			jmp		UART_SWV1


UART_SWV4:	movc	A,@A+PC
			ret
			DB		53h
			DB		6Fh
			DB		66h
			DB		74h
			DB		77h
			DB		61h
			DB		72h
			DB		65h
			DB		76h
			DB		65h
			DB		72h
			DB		73h
			DB		69h
			DB		6Fh
			DB		6Eh
			DB		3Ah
			DB		56h
			DB		31h
			DB		2Eh
			DB		30h
			DB		37h
			DB		00h
			ret


UART_SER:	mov		B, #1d
			mov		DPTR, #0010h
UART_SER1:	mov		A, B
			cjne	A, #14d, UART_SER2
			clr		A
			MOV 	DPTR,#0E000h
			MOVC 	A, @A+DPTR
			mov		DPTR, #001Dh
			jmp		UART_SER7
UART_SER2:	cjne	A, #15d, UART_SER3
			clr		A
			MOV 	DPTR,#0E001h
			MOVC 	A, @A+DPTR
			mov		DPTR, #001Eh
			jmp		UART_SER7
UART_SER3:	cjne	A, #16d, UART_SER4
			clr		A
			MOV 	DPTR,#0E002h
			MOVC 	A, @A+DPTR
			mov		DPTR, #001Fh
			jmp		UART_SER7
UART_SER4:	cjne	A, #17d, UART_SER5
			clr		A
			MOV 	DPTR,#0E003h
			MOVC 	A, @A+DPTR
			mov		DPTR, #0020h
			jmp		UART_SER7
UART_SER5:	cjne	A, #18d, UART_SER6
			clr		A
			MOV 	DPTR,#0E004h
			MOVC 	A, @A+DPTR
			mov		DPTR, #0021h
			jmp		UART_SER7
UART_SER6:	call	UART_SER8
			cjne	A, #00h, UART_SER7
			movx	@DPTR, A
			jmp		UART_SEND
UART_SER7:	movx	@DPTR, A
			inc		DPTR
			inc		B
			jmp		UART_SER1
UART_SER8:	movc	A,@A+PC
			ret
			DB		53h
			DB		65h
			DB		72h
			DB		69h
			DB		61h
			DB		6Ch
			DB		6Eh
			DB		75h
			DB		6Dh
			DB		62h
			DB		65h
			DB		72h
			DB		3Ah
			DB		78h
			DB		78h
			DB		78h
			DB		78h
			DB		78h
			DB		00h
			ret


UART_SEND:	setb	DE_RE
			setb	UART_SENDEN
			setb	SCON0_TI
			jb		UART_SENDEN, $
			clr		DE_RE
			nop

main0:		jnb		standby, main1
			ljmp	write001
main1:		jnb		Auto_zero_on, main2
			ljmp	Zero
main2:		jnb		SET_AUTOZERO, main3
			jmp		main6
main3:		jb		BIT_OVERRANGE, main4
			jb		BIT_OVERVOLT, main6
			jmp		main5
main4:		clr		LED_GREEN
			setb	LED_RED
			clr 	LED_WHITE
			jmp		main6
main5:		jb		KALIBRIEREN, main6  ;?
			clr		LED_GREEN
			clr		LED_RED
			setb	LED_WHITE

main6:		jb		KALIBRIEREN, main8 ;?
			jnb		bootscreen_ok, 	main7
			jnb		press_screen_ok, main7
			jb		ADC_messen, main8
main7:		ljmp	main48



main8:		mov		EIE1, #86h
			mov		ADC0MX, #15d
			mov		ADC0CF2, #3Fh
			mov		ADC0CN1, #40h

			mov		ADC0LTH, #04h
			mov		ADC0LTL, #65h

			mov		ADC0GTH, #02h
			mov		ADC0GTL, #71h

			setb	ADC0CN0_ADBUSY

			mov		TH0, #0FFh
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		R1, ADC0H
			mov		R2, ADC0L
			jnb		ADC_WC_SET, main9
			setb	LP_1000HZ
			clr		LP_300HZ
			clr		LP_50HZ
			clr		LP_OFF
			clr		ADC_WC_SET
			jmp		main13



main9:		mov		EIE1, #86h
			mov		ADC0MX, #15d
			mov		ADC0CF2, #3Fh
			mov		ADC0CN1, #40h

			mov		ADC0LTH, #07h
			mov		ADC0LTL, #0D0h

			mov		ADC0GTH, #05h
			mov		ADC0GTL, #0DCh

			setb	ADC0CN0_ADBUSY

			mov		TH0, #0FFh
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		R1, ADC0H
			mov		R2, ADC0L
			jnb		ADC_WC_SET, main10
			clr		LP_1000HZ
			setb	LP_300HZ
			clr		LP_50HZ
			clr		LP_OFF
			clr		ADC_WC_SET
			jmp		main13



main10:		mov		EIE1, #86h
			mov		ADC0MX, #15d
			mov		ADC0CF2, #3Fh
			mov		ADC0CN1, #40h

			mov		ADC0LTH, #0Bh
			mov		ADC0LTL, #3Bh

			mov		ADC0GTH, #09h
			mov		ADC0GTL, #47h

			setb	ADC0CN0_ADBUSY

			mov		TH0, #0FFh
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		R1, ADC0H
			mov		R2, ADC0L
			jnb		ADC_WC_SET, main11
			clr		LP_1000HZ
			clr		LP_300HZ
			setb	LP_50HZ
			clr		LP_OFF
			clr		ADC_WC_SET
			jmp		main13



main11:		mov		EIE1, #86h
			mov		ADC0MX, #15d
			mov		ADC0CF2, #3Fh
			mov		ADC0CN1, #40h

			mov		ADC0LTH, #0Eh
			mov		ADC0LTL, #0A6h

			mov		ADC0GTH, #07h
			mov		ADC0GTL, #0D0h

			setb	ADC0CN0_ADBUSY

			mov		TH0, #0FFh
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		R1, ADC0H
			mov		R2, ADC0L
			jnb		ADC_WC_SET, main12
			clr		LP_1000HZ
			clr		LP_300HZ
			clr		LP_50HZ
			setb	LP_OFF
			clr		ADC_WC_SET
			jmp		main13


main12:		clr		LP_1000HZ
			clr		LP_300HZ
			clr		LP_50HZ
			clr		LP_OFF


main13:		mov		EIE1, #86h
			mov		ADC0MX, #00h
			mov		ADC0CF2, #3Fh
			mov		ADC0CN1, #40h
			mov		ADC0LTH, #00h
			mov		ADC0LTL, #00h
			mov		ADC0GTH, #0Eh
			mov		ADC0GTL, #0D8h
			setb	ADC0CN0_ADBUSY
			jnb		ADC0CN0_ADBUSY, $
			mov		TH0, #0FFh
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		R1, ADC0H
			mov		R2, ADC0L
			jnb		ADC_WC_SET, main14
			setb	BIT_OVERVOLT
			clr		ADC_WC_SET
			jmp		main15
main14:


main15:		mov		ADC0MX, #00h
			mov		ADC0LTH, #00h
			mov		ADC0LTL, #00h
			mov		ADC0GTH, #0Fh
			mov		ADC0GTL, #0A0h
			setb	ADC0CN0_ADBUSY
			jnb		ADC0CN0_ADBUSY, $
			mov		TH0, #0FFh
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		R1, ADC0H
			mov		R2, ADC0L
			jnb		ADC_WC_SET, main16
			setb	BIT_OVERRANGE
			setb	BIT_OVERVOLT
			clr		ADC_WC_SET
			jmp		main20
main16:		nop




main20:		clr		C
			cjne	R1, #01h, main21
main21:		jnc		main23
			clr		C
			cjne	R2, #01h, main22
main22:		jnc		main23
			jmp		main23_1
main23:		setb	OUTPUT_POSITIV
			clr		OUTPUT_NEGATIV
			jmp		main29



main23_1:	mov		ADC0MX, #01h
			mov		ADC0LTH, #00h
			mov		ADC0LTL, #00h
			mov		ADC0GTH, #0Eh
			mov		ADC0GTL, #0D8h
			setb	ADC0CN0_ADBUSY
			jnb		ADC0CN0_ADBUSY, $
			mov		TH0, #0FFh
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		R1, ADC0H
			mov		R2, ADC0L
			clr		OUTPUT_POSITIV
			setb	OUTPUT_NEGATIV
			jnb		ADC_WC_SET, main24
			setb	BIT_OVERVOLT
			clr		ADC_WC_SET
			jmp		main25
main24:


main25:		mov		ADC0MX, #01h
			mov		R1, #00h
			mov		R2, #00h
			mov		ADC0LTH, #00h
			mov		ADC0LTL, #00h
			mov		ADC0GTH, #0Fh
			mov		ADC0GTL, #0A0h
			setb	ADC0CN0_ADBUSY
			jnb		ADC0CN0_ADBUSY, $
			mov		TH0, #0FFh
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		R1, ADC0H
			mov		R2, ADC0L
			jnb		ADC_WC_SET, main29
			setb	BIT_OVERVOLT
			setb	BIT_OVERRANGE
			clr		ADC_WC_SET
			jmp		main29





main29:		clr		ADC_messen




main30:			jnb		GAIN_SET, main30_00
				jmp		main30_01
main30_00:		ljmp	main48
main30_01:		mov		0x15, R1
				mov		0x16, R2
				mov		0x17, R1
				mov		0x18, R2
				mov		0x19, #00h
				mov		0x1A, #00h
				mov		0x1B, R1
				mov		0x1C, R2



main30_02:		mov		B, #2d

main30_03:		mov		A, 0x18
				cjne	A, #00h, main30_04
				mov		A, 0x17
				cjne	A, #00h, main30_05
				jmp		main30_08

main30_04:		dec		0x18
				jmp		main30_06

main30_05:		dec		0x17
				mov		0x18, #0FFh
				jmp		main30_06

main30_06:		djnz	B, main30_03
				mov		B, #2d
				mov		A, 0x1A
				cjne	A, #0FFh, main30_07
				inc		0x19
				mov		0x1A, #00h
				jmp		main30_03
main30_07:		inc 	0x1A
				jmp		main30_03



main30_08:		MOV A,R2
    			ADD A,0x16
    			MOV R2,A


    			MOV A,R1
    			ADDC A,0x15
    			MOV R1,A




				MOV A,R2
    			ADD A,0x1A
    			MOV R2,A


    			MOV A,R1
    			ADDC A,0x19
    			MOV R1,A


				mov		0x0A, #00h
				mov		0x0B, #00h
				mov		0x0C, #00h
				mov		0x0D, #00h
				mov		0x0E, #00h

main31:			mov		A, R2
				cjne	A, #00d, main33
				mov		A, R1
				cjne	A, #00d, main32
				jmp		main48
main32:			dec		R1
				mov		R2, #0FFh
				jmp		main34

main33:			dec		R2

main34:			mov		A, 0x0E
				cjne	A, #09d, main35
				mov		0x0E, #00d

				mov		A, 0x0D
				cjne	A, #09d, main36
				mov		0x0D, #00d

				mov		A, 0x0C
				cjne	A, #09d, main37
				mov		0x0C, #00d

				mov		A, 0x0B
				cjne	A, #09d, main38
				mov		0x0B, #00d

				mov		A, 0x0A
				cjne	A, #09d, main39
				jmp		main48

main35:			inc		0x0E
				jmp		main31
main36:			inc		0x0D
				jmp		main31
main37:			inc		0x0C
				jmp		main31
main38:			inc		0x0B
				jmp		main31
main39:			inc		0x0A
				jmp		main31


main48:		jnb		LCD_fertig, main50

			jb		option_menu, main49
			jb		LOCKED, main49
			jb		RS485_mode, main49
			jb		encoder_up, gain_up
			jb		encoder_down, gain_down
main49:		jb		GAIN_SET, main50
			jnb		SET_GAIN, main50
			ljmp	set_Gain_1

main50:		jmp		write001


gain_up:	cjne	R4, #6d, gain_up2
			mov		R4, #0d
			jmp		gain_delay
gain_up2:	inc		R4
			jmp		gain_delay
gain_down:	cjne	R4, #0d, gain_down2
			mov		R4, #6d
			jmp		gain_delay
gain_down2:	dec		R4
			jmp		gain_delay

gain_delay:	clr		GAIN_SET
			clr		SET_GAIN
			clr		encoder_up
			clr		encoder_down
			setb	display_clr
			mov		R3, #00h
			ljmp	DISPLAY



write001:	jnb		display_clr, write0001
			ljmp	DISPLAY
write0001:	jb		Init_Display_OK, write002
			ljmp	DISPLAY
write002:	jnb		KALIBRIEREN, write002_0
			ljmp	KALIBRIER1
write002_0:	jnb		standby, write002_1
			ljmp	write025_1
write002_1:	jnb		bootscreen_ok, write003
			jnb		option_menu, write002_2
			ljmp	option
write002_2:	jnb		ERROR, write002_3
			ljmp	ERROR1
write002_3:	ljmp	betrieb

write003:	jnb		bootscreen_loading, write003_1
			ljmp	write020
write003_1:	clr		LED_GREEN
			clr		LED_RED
			setb	LED_WHITE


write004:	cjne	R3, #76d, write010

			mov		R3, #15h
			mov		TMOD, #21h

write005:	mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
write006:	jnb		TCON_TF0, $
			dec		R3
			cjne	R3, #00d, write005
write007:	setb	bootscreen_loading
			mov		TMOD, #22h
			mov		R3, #00h
			setb	display_clr
			jmp		main


write010:	cjne	R3, #63d, write011
			MOV 	DPTR,#0E000h
			clr		A
			MOVC 	A, @A+DPTR
			mov		R0, A
			inc		R3
			jmp		DISPLAY

write011:	cjne	R3, #64d, write012
			clr		A
			MOV 	DPTR,#0E001h
			MOVC 	A, @A+DPTR
			mov		R0, A
			inc		R3
			jmp		DISPLAY

write012:	cjne	R3, #65d, write013
			clr		A
			MOV 	DPTR,#0E002h
			MOVC 	A, @A+DPTR
			mov		R0, A
			inc		R3
			jmp		DISPLAY

write013:	cjne	R3, #66d, write014
			clr		A
			MOV 	DPTR,#0E003h
			MOVC 	A, @A+DPTR
			mov		R0, A
			inc		R3
			jmp		DISPLAY

write014:	cjne	R3, #67d, write015
			clr		A
			MOV 	DPTR,#0E004h
			MOVC 	A, @A+DPTR
			mov		R0, A
			inc		R3
			jmp		DISPLAY

write015:	inc		R3
			mov		A, R3
			call	TAB_WRITE
			mov		R0, A
			jmp		DISPLAY

TAB_WRITE:	movc	A,@A+PC
			ret

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h


			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		46h
			DB		52h
			DB		41h
			DB		43h
			DB		54h
			DB		55h
			DB		52h
			DB		45h
			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h


			DB		20h
			DB		20h
			DB		20h
			DB		54h
			DB		45h
			DB		43h
			DB		48h
			DB		4Eh
			DB		4Fh
			DB		4Ch
			DB		4Fh
			DB		47h
			DB		59h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		53h
			DB		4Eh
			DB		3Ah
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		76h
			DB		31h
			DB		2Eh
			DB		30h
			DB		37h

			ret



write020:	clr		LED_GREEN
			clr		LED_RED
			setb	LED_WHITE



write021:
			setb	bootscreen_ok
			setb	standby
			ljmp	write025_1

			cjne	R3, #76d, write027
			setb	bootscreen_ok
			clr		IE_EA

			mov		R3, #55h
			mov		TMOD, #21h
write023:	mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
write024:	jb		ENCODER_MID, write025
			jmp		write026
write025:	jnb		TCON_TF0, write024
			dec		R3
			cjne	R3, #00d, write023
			setb	standby


write025_1:	clr		RST_DISPLAY
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			setb	RST_DISPLAY


			clr		LED_GREEN
			clr		LED_RED
			clr		LED_WHITE
			jnb		ENCODER_mid, $
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		P1MASK, #70h
			setb	E
			clr		IE_EA
			jb		RS485_mode, write026
			jb		ENCODER_MID, $
write026:	setb	IE_EA
			clr		E
			setb	press_screen_ok
			mov		TMOD, #22h
			mov		R3, #00h
			mov		EIE1, #8Ah
			clr		standby
			clr		encoder_up
			clr		encoder_down
			clr		Init_Display_OK
			ljmp	main


write027:	inc		R3
			mov		A, R3
			call	TAB_PRESS
			mov		R0, A
			jmp		DISPLAY

TAB_PRESS:	movc	A,@A+PC
			ret

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h


			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		50h
			DB		72h
			DB		65h
			DB		73h
			DB		73h
			DB		20h
			DB		20h
			DB		41h
			DB		44h
			DB		4Ah
			DB		55h
			DB		53h
			DB		54h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h


			DB		20h
			DB		20h
			DB		74h
			DB		6Fh
			DB		20h
			DB		61h
			DB		63h
			DB		74h
			DB		69h
			DB		76h
			DB		61h
			DB		74h
			DB		65h
			DB		20h
			DB		20h
			DB		20h


			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h

			ret






betrieb:	clr		LCD_fertig



betrieb1:	jb		erste_zeile, betrieb5
			cjne	R3, #20d, betrieb2
			mov		R3, #00h
			setb	erste_zeile
			jmp		betrieb5
betrieb2:	jb		SET_AUTOZERO, betrieb3
			jb		LP_1000HZ, betrieb3_1
			jb		LP_300HZ, betrieb3_2
			jb		LP_50HZ, betrieb3_3
			jb		LP_OFF, betrieb3_4
			ljmp	betrieb800
betrieb3:


			ljmp	betrieb810

betrieb3_1:	ljmp	betrieb801
betrieb3_2:	ljmp	betrieb802
betrieb3_3:	ljmp	betrieb803
betrieb3_4:	ljmp	betrieb804


betrieb5:	jb		zweite_zeile, betrieb10
			cjne	R3, #20d, betrieb6
			mov		R3, #00h
			setb	zweite_zeile
			jmp		betrieb10

betrieb6:	jb		BIT_OVERVOLT, betrieb7
			jb		LOCKED, betrieb6_1
			jb		RS485_mode, betrieb8_2
			ljmp	betrieb820
betrieb6_1:	ljmp	betrieb832

betrieb7:	jb		BIT_OVERRANGE, betrieb8
			jb		LOCKED, betrieb7_1
			jb		RS485_mode, betrieb8_4
			ljmp	betrieb831
betrieb7_1:	ljmp	betrieb834

betrieb8:	jb		LOCKED, betrieb8_1
			jb		RS485_mode, betrieb8_3
			ljmp	betrieb830
betrieb8_1:	ljmp	betrieb833
betrieb8_2:	ljmp	betrieb835
betrieb8_3:	ljmp	betrieb836
betrieb8_4:	ljmp	betrieb837

betrieb10:	jb		dritte_zeile, betrieb20
			cjne	R3, #20d, betrieb11
			mov		R3, #00h
			setb	dritte_zeile
			jmp		betrieb20
betrieb11:	cjne	R4, #0d, betrieb12
			ljmp	GAIN500
betrieb12:	cjne	R4, #1d, betrieb13
			ljmp	GAIN1K
betrieb13:	cjne	R4, #2d, betrieb14
			ljmp	GAIN2K
betrieb14:	cjne	R4, #3d, betrieb15
			ljmp	GAIN5K
betrieb15:	cjne	R4, #4d, betrieb16
			ljmp	GAIN10K
betrieb16:	cjne	R4, #5d, betrieb17
			ljmp	GAIN25K
betrieb17:	cjne	R4, #6d, betrieb18
			ljmp	GAIN50K
betrieb18:	cjne	R4, #7d, betrieb20
			ljmp	GAIN60K



betrieb20:	cjne	R3, #16d, betrieb21
			mov		R3, #00h
			jmp		betrieb100
betrieb21:	jb		SET_AUTOZERO, betrieb21_1
			jnb		GAIN_SET, betrieb23
			jb		OutputVoltage, betrieb22
betrieb21_1:ljmp	betrieb840


betrieb22:	ljmp	betrieb860
betrieb23:	ljmp	betrieb850


betrieb100:	jnb		Auto_zero_on, betrieb101
			ljmp	ZERO
betrieb101:	mov		R3, #0cch
betrieb102:	mov		TH0, #00h
			mov		TL0, #00h
			jnb		TCON_TF0, $
			clr		TCON_TF0
			djnz	R3, betrieb102
			setb	display_clr

			clr		erste_zeile
			clr		zweite_zeile
			clr		dritte_zeile
			setb	LCD_fertig
			jb		SET_AUTOZERO, betrieb103
			ljmp	main

betrieb103:	djnz	0x0F,betrieb104
			mov		0x0F, #2d
			setb	Auto_zero_on
betrieb104:	ljmp	main


betrieb800:	inc		R3
			mov		A, R3
			call	TAB_1Z_1
			mov		R0, A
			ljmp	DISPLAY

TAB_1Z_1:	movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb801:	inc		R3
			mov		A, R3
			call	TAB_1Z_2
			mov		R0, A
			ljmp	DISPLAY

TAB_1Z_2:	movc	A,@A+PC
			ret

			DB		4Ch
			DB		50h
			DB		2Dh
			DB		46h
			DB		49h
			DB		4Ch
			DB		54h
			DB		45h
			DB		52h
			DB		20h
			DB		31h
			DB		30h
			DB		30h
			DB		30h
			DB		48h
			DB		7Ah

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb802:	inc		R3
			mov		A, R3
			call	TAB_1Z_3
			mov		R0, A
			ljmp	DISPLAY

TAB_1Z_3:	movc	A,@A+PC
			ret

			DB		4Ch
			DB		50h
			DB		2Dh
			DB		46h
			DB		49h
			DB		4Ch
			DB		54h
			DB		45h
			DB		52h
			DB		20h
			DB		20h
			DB		33h
			DB		30h
			DB		30h
			DB		48h
			DB		7Ah

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb803:	inc		R3
			mov		A, R3
			call	TAB_1Z_4
			mov		R0, A
			ljmp	DISPLAY

TAB_1Z_4:	movc	A,@A+PC
			ret

			DB		4Ch
			DB		50h
			DB		2Dh
			DB		46h
			DB		49h
			DB		4Ch
			DB		54h
			DB		45h
			DB		52h
			DB		20h
			DB		20h
			DB		20h
			DB		35h
			DB		30h
			DB		48h
			DB		7Ah

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb804:	inc		R3
			mov		A, R3
			call	TAB_1Z_5
			mov		R0, A
			ljmp	DISPLAY

TAB_1Z_5:	movc	A,@A+PC
			ret

			DB		4Ch
			DB		50h
			DB		2Dh
			DB		46h
			DB		49h
			DB		4Ch
			DB		54h
			DB		45h
			DB		52h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		4Fh
			DB		46h
			DB		46h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb810:	inc		R3
			mov		A, R3
			call	TAB_1Z_10
			mov		R0, A
			ljmp	DISPLAY

TAB_1Z_10:	movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		2Ah
			DB		2Ah
			DB		41h
			DB		55h
			DB		54h
			DB		4Fh
			DB		5Ah
			DB		45h
			DB		52h
			DB		4Fh
			DB		2Ah
			DB		2Ah
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb820:	inc		R3
			mov		A, R3
			call	TAB_2Z_1
			mov		R0, A
			ljmp	DISPLAY

TAB_2Z_1:	movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb830:	inc		R3
			mov		A, R3
			call	TAB_2Z_2
			mov		R0, A
			ljmp	DISPLAY

TAB_2Z_2:	movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		20h
			DB		4Fh
			DB		56h
			DB		45h
			DB		52h
			DB		52h
			DB		41h
			DB		4Eh
			DB		47h
			DB		45h
			DB		21h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb831:	inc		R3
			mov		A, R3
			call	TAB_2Z_3
			mov		R0, A
			ljmp	DISPLAY
TAB_2Z_3:	movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		4Fh
			DB		55h
			DB		54h
			DB		50h
			DB		55h
			DB		54h
			DB		20h
			DB		3Eh
			DB		39h
			DB		2Eh
			DB		35h
			DB		56h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb832:	inc		R3
			mov		A, R3
			call	TAB_2Z_4
			mov		R0, A
			ljmp	DISPLAY

TAB_2Z_4:	movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		2Ah
			DB		4Ch
			DB		4Fh
			DB		43h
			DB		4Bh
			DB		45h
			DB		44h
			DB		2Ah
			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb833:	inc		R3
			mov		A, R3
			call	TAB_2Z_5
			mov		R0, A
			ljmp	DISPLAY

TAB_2Z_5:	movc	A,@A+PC
			ret
			DB		2Ah
			DB		4Ch
			DB		4Fh
			DB		43h
			DB		4Bh
			DB		2Ah
			DB		4Fh
			DB		56h
			DB		45h
			DB		52h
			DB		52h
			DB		41h
			DB		4Eh
			DB		47h
			DB		45h
			DB		21h


			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb834:	inc		 R3
			mov		A, R3
			call	TAB_2Z_6
			mov		R0, A
			ljmp	DISPLAY
TAB_2Z_6:	movc	A,@A+PC
			ret
			DB		4Ch
			DB		4Fh
			DB		43h
			DB		4Bh
			DB		2Ah
			DB		4Fh
			DB		55h
			DB		54h
			DB		50h
			DB		55h
			DB		54h
			DB		3Eh
			DB		39h
			DB		2Eh
			DB		35h
			DB		56h


			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET



betrieb835:	inc		R3
			mov		A, R3
			cjne	A, #16d, betrieb835_1
			mov		A, 0x4B
			call	TAB_HEX
			mov		R0, A
			ljmp	DISPLAY
betrieb835_1:nop
			call	TAB_2Z_7
			mov		R0, A
			ljmp	DISPLAY

TAB_2Z_7:	movc	A,@A+PC
			ret
			DB		52h
			DB		65h
			DB		6Dh
			DB		6Fh
			DB		74h
			DB		65h
			DB		20h
			DB		52h
			DB		53h
			DB		34h
			DB		38h
			DB		35h
			DB		20h
			DB		49h
			DB		44h
			DB		2Dh



			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb836:	inc		R3
			mov		A, R3
			call	TAB_2Z_8
			mov		R0, A
			ljmp	DISPLAY

TAB_2Z_8:	movc	A,@A+PC
			ret
			DB		52h
			DB		53h
			DB		34h
			DB		38h
			DB		35h
			DB		20h
			DB		4Fh
			DB		56h
			DB		45h
			DB		52h
			DB		52h
			DB		41h
			DB		4Eh
			DB		47h
			DB		45h
			DB		21h


			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb837:	inc		R3
			mov		A, R3
			call	TAB_2Z_9
			mov		R0, A
			ljmp	DISPLAY
TAB_2Z_9:	movc	A,@A+PC
			ret
			DB		52h
			DB		53h
			DB		34h
			DB		38h
			DB		35h
			DB		20h
			DB		4Fh
			DB		55h
			DB		54h
			DB		50h
			DB		2Eh
			DB		3Eh
			DB		39h
			DB		2Eh
			DB		35h
			DB		56h


			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb840:	inc		R3
			mov		A, R3
			call	TAB_4Z_1
			mov		R0, A
			ljmp	DISPLAY

TAB_4Z_1:	movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


betrieb850:	inc		R3
			mov		A, R3
			call	TAB_4Z_2
			mov		R0, A
			ljmp	DISPLAY

TAB_4Z_2:	movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		50h
			DB		72h
			DB		65h
			DB		73h
			DB		73h
			DB		20h
			DB		74h
			DB		6Fh
			DB		20h
			DB		73h
			DB		65h
			DB		74h
			DB		20h
			DB		20h
			RET








betrieb860:	inc		R3
			mov		A, R3
			cjne	A, #9d, betrieb863
			jb		OUTPUT_NEGATIV, betrieb861
			mov		R0, #20h
			ljmp	DISPLAY

betrieb861:	mov		A, 0x0A
			cjne	A, #00h, betrieb862
			mov		A, 0x0B
			cjne	A, #00h, betrieb862
			mov		A, 0x0C
			cjne	A, #00h, betrieb862
			mov		A, 0x0D
			cjne	A, #00h, betrieb862
			mov		A, 0x0E
			cjne	A, #00h, betrieb862
			mov		R0, #20h
			ljmp	DISPLAY

betrieb862:	mov		R0, #2Dh
			ljmp	DISPLAY

betrieb863:	cjne	A, #10d, betrieb864
			mov		A, 0x0A
			cjne	A, #00h, betrieb863_1
			mov		A, #20h
			jmp		betrieb869
betrieb863_1:call	TAB_DEZIMAL
			jmp		betrieb869
betrieb864:	cjne	A, #11d, betrieb865
			mov		A, 0x0B
			call	TAB_DEZIMAL
			jmp		betrieb869
betrieb865:	cjne	A, #13d, betrieb866
			mov		A, 0x0C
			call	TAB_DEZIMAL
			jmp		betrieb869
betrieb866:	cjne	A, #14d, betrieb867
			mov		A, 0x0D
			call	TAB_DEZIMAL
			jmp		betrieb869
betrieb867:	cjne	A, #15d, betrieb868
			mov		A, 0x0E
			call	TAB_DEZIMAL
			jmp		betrieb869


betrieb868:	call	TAB_4Z_3
betrieb869:	mov		R0, A
			ljmp	DISPLAY

TAB_4Z_3:	movc	A,@A+PC
			ret

			DB		4Fh
			DB		55h
			DB		54h
			DB		50h
			DB		55h
			DB		54h
			DB		3Ah
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		2Eh
			DB		20h
			DB		20h
			DB		20h
			DB		56h

			RET

TAB_DEZIMAL:inc		A
			movc	A,@A+PC
			ret
			DB		30h
			DB		31h
			DB		32h
			DB		33h
			DB		34h
			DB		35h
			DB		36h
			DB		37h
			DB		38h
			DB		39h
			ret


GAIN500:	inc		R3
			mov		A, R3
			call	TAB_GAIN500
			mov		R0, A
			ljmp	DISPLAY
TAB_GAIN500:movc	A,@A+PC
			ret

			DB		20h
			DB		20h
			DB		47h
			DB		41h
			DB		49h
			DB		4Eh
			DB		3Ah
			DB		20h
			DB		20h
			DB		20h
			DB		35h
			DB		30h
			DB		30h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET

GAIN1K:		inc		R3
			mov		A, R3
			call	TAB_GAIN1K
			mov		R0, A
			ljmp	DISPLAY
TAB_GAIN1K:	movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		47h
			DB		41h
			DB		49h
			DB		4Eh
			DB		3Ah
			DB		20h
			DB		20h
			DB		20h
			DB		31h
			DB		6Bh
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET

GAIN2K:		inc		R3
			mov		A, R3
			call	TAB_GAIN2K
			mov		R0, A
			ljmp	DISPLAY
TAB_GAIN2K:	movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		47h
			DB		41h
			DB		49h
			DB		4Eh
			DB		3Ah
			DB		20h
			DB		20h
			DB		20h
			DB		32h
			DB		2Eh
			DB		35h
			DB		6Bh
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET


GAIN5K:		inc		R3
			mov		A, R3
			call	TAB_GAIN5K
			mov		R0, A
			ljmp	DISPLAY
TAB_GAIN5K:	movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		47h
			DB		41h
			DB		49h
			DB		4Eh
			DB		3Ah
			DB		20h
			DB		20h
			DB		20h
			DB		35h
			DB		6Bh
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET

GAIN10K:	inc		R3
			mov		A, R3
			call	TAB_GAIN10K
			mov		R0, A
			ljmp	DISPLAY
TAB_GAIN10K:movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		47h
			DB		41h
			DB		49h
			DB		4Eh
			DB		3Ah
			DB		20h
			DB		20h
			DB		20h
			DB		31h
			DB		30h
			DB		6Bh
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET

GAIN25K:	inc		R3
			mov		A, R3
			call	TAB_GAIN25K
			mov		R0, A
			ljmp	DISPLAY
TAB_GAIN25K:movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		47h
			DB		41h
			DB		49h
			DB		4Eh
			DB		3Ah
			DB		20h
			DB		20h
			DB		20h
			DB		32h
			DB		35h
			DB		6Bh
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET

GAIN50K:	inc		R3
			mov		A, R3
			call	TAB_GAIN50K
			mov		R0, A
			ljmp	DISPLAY
TAB_GAIN50K:movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		47h
			DB		41h
			DB		49h
			DB		4Eh
			DB		3Ah
			DB		20h
			DB		20h
			DB		20h
			DB		35h
			DB		30h
			DB		6Bh
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET

GAIN60K:	inc		R3
			mov		A, R3
			call	TAB_GAIN60K
			mov		R0, A
			ljmp	DISPLAY
TAB_GAIN60K:movc	A,@A+PC
			ret
			DB		20h
			DB		20h
			DB		47h
			DB		41h
			DB		49h
			DB		4Eh
			DB		3Ah
			DB		20h
			DB		20h
			DB		20h
			DB		36h
			DB		30h
			DB		6Bh
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			RET




set_Gain_1:	cjne	R4, #0d, set_Gain_2
			jmp		set_Gain500
set_Gain_2:	cjne	R4, #1d, set_Gain_3
			jmp		set_Gain1K
set_Gain_3:	cjne	R4, #2d, set_Gain_4
			jmp		set_Gain2K
set_Gain_4:	cjne	R4, #3d, set_Gain_5
			jmp		set_Gain5K
set_Gain_5:	cjne	R4, #4d, set_Gain_6
			jmp		set_Gain10K
set_Gain_6:	cjne	R4, #5d, set_Gain_7
			jmp		set_Gain25K
set_Gain_7:	cjne	R4, #6d, set_Gain_8
			jmp		set_Gain50K
set_Gain_8:	cjne	R4, #7d, set_Gain_9
			;jmp		set_Gain60K
set_Gain_9:	ljmp	Gain_ende

set_Gain500: clr    CS_PDA
             MOV    A, #0x00
             MOV    SPI0DAT, A

             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF
             MOV    A, #0x00
             MOV    SPI0DAT, A
             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF
             setb   CS_PDA
			mov		0x1F, #0d
			ljmp	Gain_ende

set_Gain1K:	 clr    CS_PDA

             MOV    SPI0DAT,#0d

             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF

             MOV    SPI0DAT,#0x01
             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF
             setb   CS_PDA
			mov		0x1F, #1d
			ljmp	Gain_ende


set_Gain2K:clr    CS_PDA

             MOV    SPI0DAT,#0d

             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF

             MOV    SPI0DAT, #0x02
             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF
             setb   CS_PDA
			 mov	0x1F, #2d
			ljmp	Gain_ende

set_Gain5K:	 clr    CS_PDA
             MOV    SPI0DAT,#0x00

             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF
             MOV    SPI0DAT,#0x03
             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF
             setb   CS_PDA
			 mov	0x1F, #3d
			 ljmp	Gain_ende

set_Gain10K: clr    CS_PDA

             MOV    SPI0DAT,#0d

             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF

             MOV    SPI0DAT,#0x04
             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF
             setb   CS_PDA
			mov		0x1F, #4d
			ljmp	Gain_ende

set_Gain25K: clr    CS_PDA

             MOV    SPI0DAT,#0d

             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF
             MOV    SPI0DAT,#0x05
             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF
             setb   CS_PDA
			mov		0x1F, #5d
			ljmp	Gain_ende

set_Gain50K: clr    CS_PDA

             MOV    SPI0DAT,#0x00
             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF
             MOV    SPI0DAT,#0x06
             JB     SPI0CN0_SPIF, $
             CLR    SPI0CN0_SPIF
             setb   CS_PDA
			 mov	0x1F, #6d
			 ljmp	Gain_ende


Gain_ende:	clr		OVERLOAD
			clr 	BIT_OVERRANGE
			clr		BIT_OVERVOLT
			mov		R7, #0FFh
Gain_ende_1:jnb		TCON_TF0, $
			clr		TCON_TF0
			djnz	R7, Gain_ende_1
			clr		SET_GAIN
			mov		P0MASK, #08h
			ljmp	main


Zero:		mov		0x6D, #0d



			mov		EIE1, #8Ah
			mov		ADC0CF2, #5Fh
			mov		R0, #0Fh

			setb	BIT_AUTOZ
			mov		ADC0MX, #00h
			setb	ADC0CN0_ADBUSY
			jnb		ADC_warten, $
			clr		ADC_warten
			mov		TH0, #99h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		R1, ADC0H
			mov		R2, ADC0L



			cjne	R1, #00h, Zero_P1
			cjne	R2, #00h, Zero_P1
			jmp		Zero_N1



Zero_P1:	mov		ADC0MX, #00h
			setb	ADC0CN0_ADBUSY
			jnb		ADC_warten, $
			clr		ADC_warten
			mov		TH0, #99h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		R1, ADC0H
			mov		R2, ADC0L
			cjne	R1, #00h, Zero_P2
			cjne	R2, #00h, Zero_P2
			jmp		Zero_slow

Zero_P2:	setb	Auto_zero_on
			setb	ADC_Pos
			mov		SFRPAGE, #30h
			mov		R1, DAC0H
			mov		R2, DAC0L
			mov		SFRPAGE, #00h
			cjne	R2, #0FFh, Zero_P3
			clr		C
			cjne	R1, #0Fh, Zero_P200
Zero_P200:	jc		Zero_P20
			setb	DAC0_max
			jmp		Zero_P5
Zero_P20:	clr		DAC0_max
			inc		R1
			mov		R2, #00h
			jmp		Zero_P4
Zero_P3:	clr		DAC0_max
			inc		R2
Zero_P4:	mov		SFRPAGE, #30h
			mov		DAC0L, R2
			mov		A, R2
			mov		R6, A
			mov		DAC0H, R1
			mov		A, R1
			mov		R5, A
			mov		SFRPAGE, #00h

Zero_P5:	mov		R7, #20h

Zero_P6:	jnb		TCON_TF0, $
			clr		TCON_TF0
			djnz	R7, Zero_P6
			jnb		DAC0_max, Zero_P8
			setb	BIT_OVERRANGE
			setb	GAIN_SET
			mov		R1, #0Fh
			jmp		Zero_ende
Zero_P8:	jmp		Zero_P1




Zero_N1:	mov		ADC0MX, #00h
			setb	ADC0CN0_ADBUSY
			jnb		ADC_warten, $
			clr		ADC_warten
			mov		TH0, #99h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			mov		R1, ADC0H
			mov		R2, ADC0L
			clr		C
			cjne	R2, #05h, Zero_N1_1
Zero_N1_1:	jnc		Zero_slow

Zero_N2:	setb	Auto_zero_on
			setb	ADC_Neg
			mov		SFRPAGE, #30h
			mov		R1, DAC0H
			mov		R2, DAC0L
			mov		SFRPAGE, #00h
			cjne	R2, #00h, Zero_N3
			clr		C
			cjne	R1, #00h, Zero_N200
Zero_N200:	jnc		Zero_N20
			setb	DAC0_min
			jmp		Zero_N5
Zero_N20:	clr		DAC0_min
			dec		R1
			mov		R2, #0FFh
			jmp		Zero_N4
Zero_N3:	clr		DAC0_min
			dec		R2
Zero_N4:	mov		SFRPAGE, #30h
			mov		DAC0L, R2
			mov		A, R2
			mov		R6, A
			mov		DAC0H, R1
			mov		A, R1
			mov		R5, A
			mov		SFRPAGE, #00h

Zero_N5:	mov		R7, #20h

Zero_N6:	jnb		TCON_TF0, $
			clr		TCON_TF0
			djnz	R7, Zero_N6
			jnb		DAC0_min, Zero_N8
			setb	BIT_OVERRANGE
			setb	GAIN_SET
			mov		R1, #0Fh
			jmp		Zero_ende
Zero_N8:	jmp		Zero_N1




Zero_slow:	setb	ADC0CN0_ADBUSY
			mov		R7, #88h
			jnb		ADC_warten, $
			clr		ADC_warten
Zero_slow0:	mov		TH0, #0FFh
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			clr		TCON_TF0
			djnz	R7, Zero_slow0
			mov		R1, ADC0H
			mov		R2, ADC0L
			mov		A, 0x6D

Zero_slow1:	cjne	A, #00d, Zero_slow2

			mov		0x6E, R1
			mov		0x6F, R2
			inc		0x6D
			jmp		Zero_slow10

Zero_slow2:	cjne	A, #01d, Zero_slow3

			mov		0x70, R1
			mov		0x71, R2
			inc		0x6D
			jmp		Zero_slow10

Zero_slow3:	cjne	A, #02d, Zero_slow4

			mov		0x72, R1
			mov		0x73, R2
			inc		0x6D
			jmp		Zero_slow10

Zero_slow4:	cjne	A, #03d, Zero_slow5

			mov		0x74, R1
			mov		0x75, R2
			inc		0x6D
			jmp		Zero_slow10

Zero_slow5:	mov		0x6D, #4d
			mov		0x76, R1
			mov		0x77, R2
			jmp		Zero_slow10

Zero_slow10:mov		0x78, #00h
			mov		0x79, #00h
			mov		0x7A, #00h


            MOV A,0x6F
            ADD A,0x71
            MOV 0x7A,A

            MOV A,0x6E
            ADDC A,0x70
            MOV 0x79,A

            MOV A,#00h
            ADDC A,#00h
            MOV 0x78,A


            MOV A,0x7A
            ADD A,0x73
            MOV 0x7A,A

            MOV A,0x79
            ADDC A,0x72
            MOV 0x79,A

            MOV A,#00h
            ADDC A, 0x78
            MOV 0x78,A


            MOV A,0x7A
            ADD A,0x75
            MOV 0x7A,A

            MOV A,0x79
            ADDC A,0x74
            MOV 0x79,A

            MOV A,#00h
            ADDC A, 0x78
            MOV 0x78,A


            MOV A,0x7A
            ADD A,0x77
            MOV 0x7A,A

            MOV A,0x79
            ADDC A,0x76
            MOV 0x79,A

            MOV A,#00h
            ADDC A, 0x78
            MOV 0x78,A


    		mov		A, 0x78
			mov		A, 0x79
			mov		A, 0x7A

			mov		R1, #00h
			mov		R2, #00h

			mov		0x6C, #5d

Zero_slow12:mov		A, 0x7A
			cjne	A, #00h, Zero_slow13
			mov		A, 0x79
			cjne	A, #00h, Zero_slow14
			mov		A, 0x78
			cjne	A, #00h, Zero_slow15
			jmp		Zero_slow18

Zero_slow13:dec		0x7A
			jmp		Zero_slow16

Zero_slow14:dec		0x79
			mov		0x7A, #0FFh
			jmp		Zero_slow16

Zero_slow15:dec		0x78
			mov		0x79, #0FFh
			mov		0x7A, #0FFh
			jmp		Zero_slow16

Zero_slow16:djnz	0x6C, Zero_slow12
			mov		0x6C, #5d
			mov		A, R2
			cjne	A, #0FFh, Zero_slow17
			inc		R1
			mov		R2, #00h
			jmp		Zero_slow12
Zero_slow17:inc 	R2
			jmp		Zero_slow12

Zero_slow18:mov		A, 0x6D
			cjne	A, #4d, Zero_slow19
			mov		0x6D, #0d
			jmp		Zero_slow20
Zero_slow19:ljmp	Zero_slow


Zero_slow20:jb		Mittelwert_high, Zero_slow31
			clr		C
			cjne	R2, #15d, Zero_slow21
Zero_slow21:jc		Zero_slow22
			jmp		Zero_slow30
Zero_slow22:mov		SFRPAGE, #30h
			mov		R1, DAC0H
			mov		R2, DAC0L
			mov		SFRPAGE, #00h
			cjne	R2, #00h, Zero_slow25
			clr		C
			cjne	R1, #00h, Zero_slow23
Zero_slow23:jnc		Zero_slow24
			setb	DAC0_min
			jmp		Zero_ende
Zero_slow24:clr		DAC0_min
			dec		R1
			mov		R2, #0FFh
			jmp		Zero_slow26
Zero_slow25:clr		DAC0_min
			dec		R2
Zero_slow26:mov		SFRPAGE, #30h
			mov		DAC0L, R2
			mov		A, R2
			mov		R6, A
			mov		DAC0H, R1
			mov		A, R1
			mov		R5, A
			mov		SFRPAGE, #00h
			ljmp	Zero_slow

Zero_slow30:setb	Mittelwert_high

Zero_slow31:clr		C
			cjne	R2, #1d, Zero_slow32
Zero_slow32:jc		Zero_ende
Zero_slow33:mov		SFRPAGE, #30h
			mov		R1, DAC0H
			mov		R2, DAC0L
			mov		SFRPAGE, #00h
			cjne	R2, #0FFh, Zero_slow36
			clr		C
			cjne	R1, #0Fh, Zero_slow34
Zero_slow34:jc		Zero_slow35
			setb	DAC0_min
			jmp		Zero_ende
Zero_slow35:clr		DAC0_min
			inc		R1
			mov		R2, #00h
			jmp		Zero_slow37
Zero_slow36:clr		DAC0_min
			inc		R2
Zero_slow37:mov		SFRPAGE, #30h
			mov		DAC0L, R2
			mov		A, R2
			mov		R6, A
			mov		DAC0H, R1
			mov		A, R1
			mov		R5, A
			mov		SFRPAGE, #00h
			ljmp	Zero_slow

Zero_ende:	clr		Mittelwert_high
			clr		Auto_zero_on
			mov		P1MASK, #70h
			clr		ADC_Pos
			clr		ADC_Neg
			clr		DAC0_min
			clr		DAC0_max
			clr		BIT_AUTOZ
			clr		SET_AUTOZERO
			mov		R7, #0F2h
Zero_ende3:	jb		TCON_TF0, Zero_ende4
			jmp		Zero_ende3
Zero_ende4:	clr		TCON_TF0
			djnz	R7, Zero_ende3

			clr		ADC0CN0_ADWINT
			clr		BIT_OVERRANGE
			clr		BIT_OVERVOLT
			mov		ADC0H, #00h
			mov		ADC0L, #00h
			clr		ADC_WC_SET

			mov		R2, #00d
			setb	display_clr
			clr		erste_zeile
			clr		zweite_zeile
			clr		dritte_zeile
			clr		LED_GREEN
			clr		LED_RED
			setb 	LED_WHITE
			setb	GAIN_SET


Zero_ende5:

			MOV 	DPTR,#0F200h
			clr		A
			MOVC 	A, @A+DPTR


			cjne	A, #1d, Zero_ende6
			mov		A, R6
			mov		B, 0x33
			subb	A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x32
			subb	A, B
			mov		R5, A
			clr		C
			mov		A, R6
			mov		B, 0x53
			add		A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x52
			addc	A, B
			mov		R5, A
			ljmp	Zero_ende20

Zero_ende6:	cjne	A, #2d, Zero_ende7
			mov		A, R6
			mov		B, 0x35
			subb	A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x34
			subb	A, B
			mov		R5, A
			clr		C
			mov		A, R6
			mov		B, 0x55
			add		A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x54
			addc	A, B
			mov		R5, A
			ljmp	Zero_ende20

Zero_ende7:	cjne	A, #3d, Zero_ende8
			mov		A, R6
			mov		B, 0x37
			subb	A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x36
			subb	A, B
			mov		R5, A
			clr		C
			mov		A, R6
			mov		B, 0x57
			add		A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x56
			addc	A, B
			mov		R5, A
			ljmp	Zero_ende20

Zero_ende8:	cjne	A, #4d, Zero_ende9
			mov		A, R6
			mov		B, 0x39
			subb	A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x38
			subb	A, B
			mov		R5, A
			clr		C
			mov		A, R6
			mov		B, 0x59
			add		A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x58
			addc	A, B
			mov		R5, A
			ljmp	Zero_ende20

Zero_ende9:	cjne	A, #5d, Zero_ende10
			mov		A, R6
			mov		B, 0x3B
			subb	A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x3A
			subb	A, B
			mov		R5, A
			clr		C
			mov		A, R6
			mov		B, 0x5B
			add		A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x5A
			addc	A, B
			mov		R5, A
			ljmp	Zero_ende20

Zero_ende10:cjne	A, #6d, Zero_ende11
			mov		A, R6
			mov		B, 0x3D
			subb	A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x3C
			subb	A, B
			mov		R5, A
			clr		C
			mov		A, R6
			mov		B, 0x5D
			add		A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x5C
			addc	A, B
			mov		R5, A
			ljmp	Zero_ende20

Zero_ende11:cjne	A, #7d, Zero_ende12
			mov		A, R6
			mov		B, 0x3F
			subb	A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x3E
			subb	A, B
			mov		R5, A
			clr		C
			mov		A, R6
			mov		B, 0x5F
			add		A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x5E
			addc	A, B
			mov		R5, A
			ljmp	Zero_ende20

Zero_ende12:cjne	A, #8d, Zero_ende20
			mov		A, R6
			mov		B, 0x41
			subb	A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x40
			subb	A, B
			mov		R5, A
			clr		C
			mov		A, R6
			mov		B, 0x51
			add		A, B
			mov		R6, A
			mov		A, R5
			mov		B, 0x50
			addc	A, B
			mov		R5, A
			ljmp	Zero_ende20

Zero_ende20:jb		RS485_mode, Zero_ende21
			ljmp	DISPLAY
Zero_ende21: ljmp	UART_AZ_OK



option:		cjne	R3, #76d, option1
			jmp		option4
option1:	ljmp	option100
option4:	mov		R3, #02h
option5:	mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
option6:	jnb		TCON_TF0, $
			djnz	R3, option5
option7:	mov		R3, #00h
			setb	LCD_fertig

			jb		encoder_up, option10
			jb		encoder_down, option12
			jb		encoder_middle, option20
			jmp		option98

option10:	clr		encoder_up
			jb		RS485_ID, option11_4
			mov		A, 0x1D
			clr		C
			cjne	A, #5d, option11
			mov		0x1D, #5d
			jmp		option97
option11:	inc 	0x1D
			mov		A, 0x1D
			clr		C
			cjne	A, #4d, option11_1
option11_1:	jc		option11_2
			jmp		option11_3
option11_2:	clr		PAGE2
			jmp		option97
option11_3:	setb	PAGE2
			jmp		option97
option11_4:	mov		A, 0x4B
			cjne	A, #8d, option11_5
			jmp		option97
option11_5:	inc		0x4B
			jmp		option97

option12:	clr		encoder_down
			jb		RS485_ID, option13_4
			mov		A, 0x1D
			cjne	A, #1d, option13
			mov		0x1D, #1d
			jmp		option97
option13:	dec 	0x1D
			mov		A, 0x1D
			clr		C
			cjne	A, #4d, option13_1
option13_1:	jc		option13_2
			jmp		option13_3
option13_2:	clr		PAGE2
			jmp		option97
option13_3:	setb	PAGE2
			jmp		option97

option13_4:	mov		A, 0x4B
			cjne	A, #1d, option13_5
			jmp		option97
option13_5:	dec		0x4B
			jmp		option97

option20:	clr		encoder_middle
			clr		Init_Display_OK
			mov		R3, #00h
			mov		A, 0x1D
			cjne	A, #1d, option25
			jb		LOCKED, option21
			setb	LOCKED
			mov		P1MASK, #40h
			clr		option_menu
			jmp		option97


option21:	clr		LOCKED
			mov		P1MASK, #70h
			clr		option_menu
			jmp		option97


option25:	mov		A, 0x1D
			cjne	A, #2d, option30
			clr		option_menu
			setb	standby
			jmp		option97


option30:	mov		A, 0x1D
			cjne	A, #3d, option31
			clr		option_menu

			jmp		option97


option31:	mov		A, 0x1D
			cjne	A, #4d, option32
			jmp		option34
option32:	ljmp	option38
option34:	clr		option_menu
			jb		RS485_mode, option35
			setb	RS485_mode

			setb	IE_ES0
			clr		DE_RE


			clr		IE_EA
			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000011b
			MOV 	DPTR,#0F000h
			clr		A
			movx	@DPTR, A
			mov		PSCTL, #00000000b

			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F000h
			mov		A, 0x1D
			movx	@DPTR, A
			mov		PSCTL, #00000000b

			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F001h
			mov		A, 0x4B
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			setb	IE_EA
			clr		A
			jmp		option97
option35:	clr		RS485_mode


			clr		IE_EA
			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000011b
			MOV 	DPTR,#0F000h
			clr		A
			movx	@DPTR, A
			mov		PSCTL, #00000000b

			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F000h
			mov		A, #0d
			movx	@DPTR, A
			mov		PSCTL, #00000000b

			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F001h
			mov		A, 0x4B
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			setb	IE_EA
			clr		A

			clr		IE_ES0
			jmp		option97


option38:	mov		A, 0x1D
			cjne	A, #5d, option97
			jb		RS485_ID, option39
			setb	RS485_ID
			jmp		option97
option39:	clr		RS485_ID


			clr		IE_EA
			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000011b
			MOV 	DPTR,#0F000h
			clr		A
			movx	@DPTR, A
			mov		PSCTL, #00000000b









			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F001h
			mov		A, 0x4B
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			setb	IE_EA

			jmp		option97

option97:	mov		0x1E, #15h
option98:	mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			djnz	0x1E, option98

option99:	setb	display_clr
			clr		SET_GAIN
			ljmp	main


option100:	inc		R3

			cjne	R3, #21d, option120

			mov		A, 0x1D
			cjne	A, #1d, option110
			mov		R0, #7Eh
			ljmp	DISPLAY
option110:	cjne	A, #4d, option111
			mov		R0, #7Eh
			ljmp	DISPLAY
option111:	mov		R0, #20h
			ljmp	DISPLAY

option120:	cjne	R3, #41d, option130

			mov		A, 0x1D
			cjne	A, #2d, option121
			mov		R0, #7Eh
			ljmp	DISPLAY
option121:	cjne	A, #5d, option122
			jb		RS485_ID, option122
			mov		R0, #7Eh
			ljmp	DISPLAY
option122:	mov		R0, #20h
			ljmp	DISPLAY

option130:	cjne	R3, #53d, option133
			jnb		RS485_ID, option132
			mov		R0, #7Eh
			ljmp	DISPLAY
option132:	mov		R0, #20h
			ljmp	DISPLAY

option133:	cjne	R3, #55d, option140
			jnb		PAGE2, option140
			jb		RS485_mode, option140
			mov		A, 0x4B
			call	TAB_HEX
			mov		R0, A
			ljmp	DISPLAY


option140:	cjne	R3, #61d, option200

			mov		A, 0x1D
			cjne	A, #3d, option150
			mov		R0, #7Eh
			ljmp	DISPLAY
option150:	mov		R0, #20h
			ljmp	DISPLAY



option200:	mov		A, R3
			jb		LOCKED, option250
			jb		PAGE2, option251
			call	TAB_option_S1
			mov		R0, A
			ljmp	DISPLAY

option250:	call	TAB_option_UL
			mov		R0, A
			ljmp	DISPLAY

option251:	jb		RS485_mode, option252
			call	TAB_option_S2
			mov		R0, A
			ljmp	DISPLAY

option252:	call	TAB_option_S3
			mov		R0, A
			ljmp	DISPLAY

TAB_option_S1:	movc	A,@A+PC
			ret

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		4Fh
			DB		50h
			DB		54h
			DB		49h
			DB		4Fh
			DB		4Eh
			DB		53h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h



			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		4Ch
			DB		6Fh
			DB		63h
			DB		6Bh
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h


			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		53h
			DB		74h
			DB		61h
			DB		6Eh
			DB		64h
			DB		62h
			DB		79h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		43h
			DB		61h
			DB		6Eh
			DB		63h
			DB		65h
			DB		6Ch
			DB		20h
			DB		20h
			DB		20h
			DB		31h
			DB		2Fh
			DB		32h
			ret

TAB_option_S2:	movc	A,@A+PC
			ret

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		4Fh
			DB		50h
			DB		54h
			DB		49h
			DB		4Fh
			DB		4Eh
			DB		53h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h



			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		45h
			DB		6Eh
			DB		61h
			DB		62h
			DB		6Ch
			DB		65h
			DB		20h
			DB		52h
			DB		53h
			DB		34h
			DB		38h
			DB		35h



			DB		20h
			DB		20h
			DB		20h
			DB		20h


			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		52h
			DB		53h
			DB		34h
			DB		38h
			DB		35h
			DB		2Dh
			DB		49h
			DB		44h
			DB		20h
			DB		5Bh
			DB		20h
			DB		5Dh

			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		32h
			DB		2Fh
			DB		32h
			ret

TAB_option_S3:	movc	A,@A+PC
			ret

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		4Fh
			DB		50h
			DB		54h
			DB		49h
			DB		4Fh
			DB		4Eh
			DB		53h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h



			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		44h
			DB		69h
			DB		73h
			DB		61h
			DB		62h
			DB		6Ch
			DB		65h
			DB		20h
			DB		52h
			DB		53h
			DB		34h
			DB		38h
			DB		35h



			DB		20h
			DB		20h
			DB		20h
			DB		20h


			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			ret

TAB_option_UL:	movc	A,@A+PC
			ret

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		4Fh
			DB		50h
			DB		54h
			DB		49h
			DB		4Fh
			DB		4Eh
			DB		53h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h



			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		55h
			DB		6Eh
			DB		6Ch
			DB		6Fh
			DB		63h
			DB		6Bh
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h


			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h

			ret



DISPLAY:
			setb	SPI_DISPLAY



			jb		display_clr, DISPLAY50
			jb		Init_Display_OK, DISPLAY100

init1:		cjne	R3, #13d, init2
			setb	Init_Display_OK
			mov		R3, #00h
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
init_delay:	jnb		TCON_TF0, $

			jb		overheat, init11
			jb		SONDERMENU, init11
			ljmp	main
init11:		setb	display_clear
			ljmp	main

init2:		inc		R3
			mov		A, R3
			call	TAB_INIT
			mov		R0, A
			jmp		DISPLAY100

TAB_INIT:	movc	A,@A+PC
			ret
			DB		3Ah
			DB		0Bh
			DB		06h
			DB		1Eh
			DB		39h
			DB		1Bh
			DB		6Ch
			DB		54h
			DB		70h
			DB		38h
			DB		0Eh
			DB		01h
			DB		02h
			ret


DISPLAY50:	cjne	R3, #1d, DISPLAY53
			mov		R3, #00h
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
DISPLAY51:	jnb		TCON_TF0, $
			mov		TMOD, #22h

DISPLAY52:	clr		display_clr
			ljmp	main

DISPLAY53:	inc		R3
			mov		A, R3
			call	TAB_CLR
			mov		R0, A
			jmp		DISPLAY100

TAB_CLR:	movc	A,@A+PC
			ret
			DB		03h
			ret




DISPLAY100:	jb			display_clr, DISPLAY101
			jb			Init_Display_OK, DISPLAY102
DISPLAY101:	mov			0x11, #0F8h
			jmp			DISPLAY103

DISPLAY102:	mov			0x11, #0FAh

DISPLAY103:	mov			A, R0
			rr			A
			anl			A, #10000000b
			mov			0x10, A
			mov			B, 0x10

			mov			A, R0
			rr			A
			rr			A
			rr			A
			anl			A, #01000000b
			add			A, 0x10
			mov			B, A
			mov			0x10, A

			mov			A, R0
			rr			A
			rr			A
			rr			A
			rr			A
			rr			A
			anl			A, #00100000b
			add		 	A, 0x10
			mov			B, A
			mov			0x10, A

			mov			A, R0
			rr			A
			rr			A
			rr			A
			rr			A
			rr			A
			rr			A
			rr			A
			anl			A, #00010000b
			add		 	A, 0x10
			mov			0x12, A



			mov			A, R0
			swap		A
			rr			A
			anl			A, #10000000b
			mov			0x10, A
			mov			B, 0x10

			mov			A, R0
			swap		A
			rr			A
			rr			A
			rr			A
			anl			A, #01000000b
			add			A, 0x10
			mov			B, A
			mov			0x10, A

			mov			A, R0
			swap		A
			rr			A
			rr			A
			rr			A
			rr			A
			rr			A
			anl			A, #00100000b
			add		 	A, 0x10
			mov			B, A
			mov			0x10, A

			mov			A, R0
			swap		A
			rr			A
			rr			A
			rr			A
			rr			A
			rr			A
			rr			A
			rr			A
			anl			A, #00010000b
			add		 	A, 0x10
			mov			0x13, A

			setb	SPI0CN0_SPIF
			jnb		wait_for_SPI, $
			clr		wait_for_SPI

DISPLAY200:	jmp		main


KALIBRIER1:	jnb		selbsttest, KALIBRIER2
			ljmp	KALIBRIER21

KALIBRIER2:	clr		LED_GREEN
			clr		LED_RED
			setb	LED_WHITE

			mov		TMOD, #21h
			mov		R0, #04h
KALIBRIER3:	mov		TL0, #00h
			mov		TH0, #00h
			jnb		TCON_TF0, $
			clr		TCON_TF0
			djnz	R0, KALIBRIER3

			clr		LED_GREEN
			setb	LED_RED
			clr		LED_WHITE

			mov		R0, #04h
KALIBRIER4:	mov		TL0, #00h
			mov		TH0, #00h
			jnb		TCON_TF0, $
			clr		TCON_TF0
			djnz	R0, KALIBRIER4

			setb	LED_GREEN
			clr		LED_RED
			clr		LED_WHITE

			mov		R0, #04h
KALIBRIER5:	mov		TL0, #00h
			mov		TH0, #00h
			jnb		TCON_TF0, $
			clr		TCON_TF0
			djnz	R0, KALIBRIER5

			clr		LED_GREEN
			clr		LED_RED
			setb	LED_WHITE
			setb	selbsttest
			mov		TMOD, #22h

KALIBRIER21:jnb		settings_saved, KALIBRIER22
			ljmp	saved_0
KALIBRIER22:cjne	R3, #76d, KALIBRIER30
			mov		R3, #0FFh
KALIBRIER23:mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			dec		R3
			cjne	R3, #00d, KALIBRIER23
			mov		TMOD, #22h
			setb	display_clr
			mov		R3, #00h
			ljmp	DISPLAY

















KALIBRIER30:jb		BIT_GAIN_500, KALIBRIER31
			ljmp	KALIB_500_0
KALIBRIER31:jb		BIT_GAIN_1K, KALIBRIER32
			ljmp	KALIB_1k_0
KALIBRIER32:jb		BIT_GAIN_2K, KALIBRIER33
			ljmp	KALIB_2k_0
KALIBRIER33:jb		BIT_GAIN_5K, KALIBRIER34
			ljmp	KALIB_5k_0
KALIBRIER34:jb		BIT_GAIN_10K, KALIBRIER35
			ljmp	KALIB_10k_0
KALIBRIER35:jb		BIT_GAIN_25K, KALIBRIER36
			ljmp	KALIB_25K_0
KALIBRIER36:jb		BIT_GAIN_50K, KALIBRIER37
			ljmp	KALIB_50K_0
KALIBRIER37:jb		BIT_GAIN_60K, KALIBRIER37_1
			ljmp	KALIB_60k_0
KALIBRIER37_1:	jb		KALIB_end, KALIBRIER38
			ljmp	KALIB_end_0

KALIBRIER38:
			setb	display_clr
			mov		R3, #00h

			ljmp	KALIBRIEREN_ENDE


KALIB_500_0:setb	E
			clr		S1
			clr		S2
			;clr		S3
			clr		E
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			djnz	0x6A, KALIB_500_1
			djnz	0x6B, KALIB_500_1
			jmp		KALIB_500_2
KALIB_500_1:ljmp	KALIB_500_6
KALIB_500_2:mov		0x6A, #0DDh
			mov		0x1B, R1
			mov		0x1C, R2
			mov		R1, #00h
			mov		R2, #00h
			mov		0x49, #00h
			mov		B, #2d
			clr		C
			mov		A, 0x1B
			mov		B, #2d
  			div		AB
  			mov		R1, A
  			mov		A, B
  			cjne	A, #1d, KALIB_500_3
			mov		0x49, #80h
KALIB_500_3:clr		C
			mov		A, 0x1C
			mov		B, #2d
  			div		AB
  			clr		C
			add		A, 0x49
			mov		R2, A
			clr		A
			addc	A, R1
			mov		R1, A
			jnb		OUTPUT_POSITIV, KALIB_500_4
			mov		0x32,R1
			mov		0x33,R2
			mov		0x52, #00h
			mov		0x53, #00h
			jmp		KALIB_500_5
KALIB_500_4:mov		0x52,R1
			mov		0x53,R2
			mov		0x32, #00h
			mov		0x33, #00h
KALIB_500_5:setb	BIT_GAIN_500
			jmp		KALIB_1k_0
KALIB_500_6:ljmp	KALIBRIER39



KALIB_1k_0:	setb	E
			setb	S1
			clr		S2
			;clr		S3
			clr		E
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			djnz	0x6A, KALIB_1k_1
			jmp		KALIB_1k_2
KALIB_1k_1:	ljmp	KALIB_1k_6
KALIB_1k_2:	mov		0x6A, #0DDh
			mov		0x1B, R1
			mov		0x1C, R2
			mov		R1, #00h
			mov		R2, #00h
			mov		0x49, #00h
			mov		B, #2d
			clr		C
			mov		A, 0x1B
			mov		B, #2d
  			div		AB
  			mov		R1, A
  			mov		A, B
  			cjne	A, #1d, KALIB_1k_3
			mov		0x49, #80h
KALIB_1k_3:	clr		C
			mov		A, 0x1C
			mov		B, #2d
  			div		AB
  			clr		C
			add		A, 0x49
			mov		R2, A
			clr		A
			addc	A, R1
			mov		R1, A
			jnb		OUTPUT_POSITIV, KALIB_1k_4
			mov		0x34,R1
			mov		0x35,R2
			mov		0x54, #00h
			mov		0x55, #00h
			jmp		KALIB_1k_5
KALIB_1k_4:	mov		0x54,R1
			mov		0x55,R2
			mov		0x34, #00h
			mov		0x35, #00h
KALIB_1k_5:	setb	BIT_GAIN_1K
			jmp		KALIB_2k_0
KALIB_1k_6:	ljmp	KALIBRIER39



KALIB_2k_0:	setb	E
			clr		S1
			setb	S2
			;clr		S3
			clr		E
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			djnz	0x6A, KALIB_2k_1
			jmp		KALIB_2k_2
KALIB_2k_1:	ljmp	KALIB_2k_6
KALIB_2k_2:	mov		0x6A, #0DDh
			mov		0x1B, R1
			mov		0x1C, R2
			mov		R1, #00h
			mov		R2, #00h
			mov		0x49, #00h
			mov		B, #2d
			clr		C
			mov		A, 0x1B
			mov		B, #2d
  			div		AB
  			mov		R1, A
  			mov		A, B
  			cjne	A, #1d, KALIB_2k_3
			mov		0x49, #80h
KALIB_2k_3:	clr		C
			mov		A, 0x1C
			mov		B, #2d
  			div		AB
  			clr		C
			add		A, 0x49
			mov		R2, A
			clr		A
			addc	A, R1
			mov		R1, A
			jnb		OUTPUT_POSITIV, KALIB_2k_4
			mov		0x36,R1
			mov		0x37,R2
			mov		0x56, #00h
			mov		0x57, #00h
			jmp		KALIB_2k_5
KALIB_2k_4:	mov		0x56,R1
			mov		0x57,R2
			mov		0x36, #00h
			mov		0x37, #00h
KALIB_2k_5:	setb	BIT_GAIN_2K
			jmp		KALIB_5k_0
KALIB_2k_6:	ljmp	KALIBRIER39


KALIB_5k_0:	setb	E
			setb	S1
			setb	S2
			;clr		S3
			clr		E
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			djnz	0x6A, KALIB_5k_1
			jmp		KALIB_5k_2
KALIB_5k_1:	ljmp	KALIB_5k_6
KALIB_5k_2:	mov		0x6A, #0DDh
			mov		0x1B, R1
			mov		0x1C, R2
			mov		R1, #00h
			mov		R2, #00h
			mov		0x49, #00h
			mov		B, #2d
			clr		C
			mov		A, 0x1B
			mov		B, #2d
  			div		AB
  			mov		R1, A
  			mov		A, B
  			cjne	A, #1d, KALIB_5k_3
			mov		0x49, #80h
KALIB_5k_3:	clr		C
			mov		A, 0x1C
			mov		B, #2d
  			div		AB
  			clr		C
			add		A, 0x49
			mov		R2, A
			clr		A
			addc	A, R1
			mov		R1, A
			jnb		OUTPUT_POSITIV, KALIB_5k_4
			mov		0x38,R1
			mov		0x39,R2
			mov		0x58, #00h
			mov		0x59, #00h
			jmp		KALIB_5k_5
KALIB_5k_4:	mov		0x58,R1
			mov		0x59,R2
			mov		0x38, #00h
			mov		0x39, #00h
KALIB_5k_5:	setb	BIT_GAIN_5K
			jmp		KALIB_10k_0
KALIB_5k_6:	ljmp	KALIBRIER39


KALIB_10k_0:setb	E
			clr 	S1
			clr		S2
			;setb	S3
			clr		E
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			djnz	0x6A, KALIB_10k_1
			jmp		KALIB_10k_2
KALIB_10k_1:ljmp	KALIB_10k_6
KALIB_10k_2:mov		0x6A, #0DDh
			mov		0x1B, R1
			mov		0x1C, R2
			mov		R1, #00h
			mov		R2, #00h
			mov		0x49, #00h
			mov		B, #2d
			clr		C
			mov		A, 0x1B
			mov		B, #2d
  			div		AB
  			mov		R1, A
  			mov		A, B
  			cjne	A, #1d, KALIB_10k_3
			mov		0x49, #80h
KALIB_10k_3:clr		C
			mov		A, 0x1C
			mov		B, #2d
  			div		AB
  			clr		C
			add		A, 0x49
			mov		R2, A
			clr		A
			addc	A, R1
			mov		R1, A
			jnb		OUTPUT_POSITIV, KALIB_10k_4
			mov		0x3A,R1
			mov		0x3B,R2
			mov		0x5A, #00h
			mov		0x5B, #00h
			jmp		KALIB_10k_5
KALIB_10k_4:mov		0x5A,R1
			mov		0x5B,R2
			mov		0x3A, #00h
			mov		0x3B, #00h
KALIB_10k_5:setb	BIT_GAIN_10K
			jmp		KALIB_25K_0
KALIB_10k_6:ljmp	KALIBRIER39


KALIB_25K_0:setb	E
			setb 	S1
			clr		S2
			;setb	S3
			clr		E
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			djnz	0x6A, KALIB_25K_1
			jmp		KALIB_25K_2
KALIB_25K_1:ljmp	KALIB_25K_6
KALIB_25K_2:mov		0x6A, #0DDh
			mov		0x1B, R1
			mov		0x1C, R2
			mov		R1, #00h
			mov		R2, #00h
			mov		0x49, #00h
			mov		B, #2d
			clr		C
			mov		A, 0x1B
			mov		B, #2d
  			div		AB
  			mov		R1, A
  			mov		A, B
  			cjne	A, #1d, KALIB_25K_3
			mov		0x49, #80h
KALIB_25K_3:clr		C
			mov		A, 0x1C
			mov		B, #2d
  			div		AB
  			clr		C
			add		A, 0x49
			mov		R2, A
			clr		A
			addc	A, R1
			mov		R1, A
			jnb		OUTPUT_POSITIV, KALIB_25K_4
			mov		0x3C,R1
			mov		0x3D,R2
			mov		0x5C, #00h
			mov		0x5D, #00h
			jmp		KALIB_25K_5
KALIB_25K_4:mov		0x5C,R1
			mov		0x5D,R2
			mov		0x3C, #00h
			mov		0x3D, #00h
KALIB_25K_5:setb	BIT_GAIN_25K
			jmp		KALIB_50K_0
KALIB_25K_6:ljmp	KALIBRIER39


KALIB_50K_0:setb	E
			clr 	S1
			setb	S2
			;setb	S3
			clr		E
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			djnz	0x6A, KALIB_50K_1
			jmp		KALIB_50K_2
KALIB_50K_1:ljmp	KALIB_50K_6
KALIB_50K_2:mov		0x6A, #0DDh
			mov		0x1B, R1
			mov		0x1C, R2
			mov		R1, #00h
			mov		R2, #00h
			mov		0x49, #00h
			mov		B, #2d
			clr		C
			mov		A, 0x1B
			mov		B, #2d
  			div		AB
  			mov		R1, A
  			mov		A, B
  			cjne	A, #1d, KALIB_50K_3
			mov		0x49, #80h
KALIB_50K_3:clr		C
			mov		A, 0x1C
			mov		B, #2d
  			div		AB
  			clr		C
			add		A, 0x49
			mov		R2, A
			clr		A
			addc	A, R1
			mov		R1, A
			jnb		OUTPUT_POSITIV, KALIB_50K_4
			mov		0x3E,R1
			mov		0x3F,R2
			mov		0x5E, #00h
			mov		0x5F, #00h
			jmp		KALIB_50K_5
KALIB_50K_4:mov		0x5E,R1
			mov		0x5F,R2
			mov		0x3E, #00h
			mov		0x3F, #00h
KALIB_50K_5:setb	BIT_GAIN_50K
			jmp		KALIB_60k_0
KALIB_50K_6:ljmp	KALIBRIER39


KALIB_60k_0:setb	E
			setb 	S1
			setb	S2
			;setb	S3
			clr		E
			mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			djnz	0x6A, KALIB_60k_1
			jmp		KALIB_60k_2
KALIB_60k_1:ljmp	KALIB_60k_6
KALIB_60k_2:mov		0x6A, #0DDh
			mov		0x1B, R1
			mov		0x1C, R2
			mov		R1, #00h
			mov		R2, #00h
			mov		0x49, #00h
			mov		B, #2d
			clr		C
			mov		A, 0x1B
			mov		B, #2d
  			div		AB
  			mov		R1, A
  			mov		A, B
  			cjne	A, #1d, KALIB_60k_3
			mov		0x49, #80h
KALIB_60k_3:clr		C
			mov		A, 0x1C
			mov		B, #2d
  			div		AB
  			clr		C
			add		A, 0x49
			mov		R2, A
			clr		A
			addc	A, R1
			mov		R1, A
			jnb		OUTPUT_POSITIV, KALIB_60k_4
			mov		0x40,R1
			mov		0x41,R2
			mov		0x50, #00h
			mov		0x51, #00h
			jmp		KALIB_60k_5
KALIB_60k_4:mov		0x50,R1
			mov		0x51,R2
			mov		0x40, #00h
			mov		0x41, #00h
KALIB_60k_5:setb	BIT_GAIN_60K
KALIB_60k_6:ljmp	KALIBRIER39


KALIB_end_0:mov		TH0, #00h
			mov		TL0, #00h
			clr		TCON_TF0
			jnb		TCON_TF0, $
			djnz	0x6A, KALIB_end_1
			setb	KALIB_end
KALIB_end_1:jmp		KALIBRIER39


KALIBRIER39:inc		R3
			cjne	R3, #61d, KALIBRIER40
			jnb		BIT_GAIN_500, KALIBRIER40
			mov		R0, #2Ah
			ljmp	DISPLAY
KALIBRIER40:cjne	R3, #62d, KALIBRIER45
			jnb		BIT_GAIN_500, KALIBRIER45
			mov		R0, #2Ah
			ljmp	DISPLAY


KALIBRIER45:cjne	R3, #63d, KALIBRIER50
			jnb		BIT_GAIN_1K, KALIBRIER50
			mov		R0, #2Ah
			ljmp	DISPLAY
KALIBRIER50:cjne	R3, #64d, KALIBRIER55
			jnb		BIT_GAIN_1K, KALIBRIER55
			mov		R0, #2Ah
			ljmp	DISPLAY


KALIBRIER55:cjne	R3, #65d, KALIBRIER60
			jnb		BIT_GAIN_2K, KALIBRIER60
			mov		R0, #2Ah
			ljmp	DISPLAY
KALIBRIER60:cjne	R3, #66d, KALIBRIER65
			jnb		BIT_GAIN_2K, KALIBRIER65
			mov		R0, #2Ah
			ljmp	DISPLAY


KALIBRIER65:cjne	R3, #67d, KALIBRIER70
			jnb		BIT_GAIN_5K, KALIBRIER70
			mov		R0, #2Ah
			ljmp	DISPLAY
KALIBRIER70:cjne	R3, #68d, KALIBRIER75
			jnb		BIT_GAIN_5K, KALIBRIER75
			mov		R0, #2Ah
			ljmp	DISPLAY


KALIBRIER75:cjne	R3, #69d, KALIBRIER80
			jnb		BIT_GAIN_10K, KALIBRIER80
			mov		R0, #2Ah
			ljmp	DISPLAY
KALIBRIER80:cjne	R3, #70d, KALIBRIER85
			jnb		BIT_GAIN_10K, KALIBRIER85
			mov		R0, #2Ah
			ljmp	DISPLAY


KALIBRIER85:cjne	R3, #71d, KALIBRIER90
			jnb		BIT_GAIN_25K, KALIBRIER90
			mov		R0, #2Ah
			ljmp	DISPLAY
KALIBRIER90:cjne	R3, #72d, KALIBRIER95
			jnb		BIT_GAIN_25K, KALIBRIER95
			mov		R0, #2Ah
			ljmp	DISPLAY

KALIBRIER95:cjne	R3, #73d, KALIBRIER100
			jnb		BIT_GAIN_50K, KALIBRIER100
			mov		R0, #2Ah
			ljmp	DISPLAY
KALIBRIER100:cjne	R3, #74d, KALIBRIER105
			jnb		BIT_GAIN_50K, KALIBRIER105
			mov		R0, #2Ah
			ljmp	DISPLAY


KALIBRIER105:cjne	R3, #75d, KALIBRIER110
			jnb		BIT_GAIN_60K, KALIBRIER110
			mov		R0, #2Ah
			ljmp	DISPLAY
KALIBRIER110:cjne	R3, #76d, KALIBRIER115
			jnb		BIT_GAIN_60K, KALIBRIER115
			mov		R0, #2Ah
			ljmp	DISPLAY
KALIBRIER115:nop

KALIBRIER165:mov		A, R3
			call	TAB_KALIBRIER
			mov		R0, A
			ljmp	DISPLAY

TAB_KALIBRIER:movc	A,@A+PC
			ret

			DB		20h
			DB		20h
			DB		20h
			DB		41h
			DB		54h
			DB		54h
			DB		45h
			DB		4Eh
			DB		54h
			DB		49h
			DB		4Fh
			DB		4Eh
			DB		21h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		46h
			DB		2Eh
			DB		2Dh
			DB		43h
			DB		61h
			DB		6Ch
			DB		69h
			DB		62h
			DB		72h
			DB		61h
			DB		74h
			DB		69h
			DB		6Fh
			DB		6Eh
			DB		20h


			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		70h
			DB		6Ch
			DB		65h
			DB		61h
			DB		73h
			DB		65h
			DB		20h
			DB		77h
			DB		61h
			DB		69h
			DB		74h
			DB		2Eh
			DB		2Eh
			DB		2Eh
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			ret



TAB_HEX:	inc		A
			movc	A,@A+PC
			ret
			DB		30h
			DB		31h
			DB		32h
			DB		33h
			DB		34h
			DB		35h
			DB		36h
			DB		37h
			DB		38h
			DB		39h
			DB		41h
			DB		42h
			DB		43h
			DB		44h
			DB		45h
			DB		46h
			ret























KALIBRIEREN_ENDE:

			clr		IE_EA


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000011b
			MOV 	DPTR,#0F910h
			clr		A
			movx	@DPTR, A
			mov		PSCTL, #00000000b


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F910h
			mov		A, 0x32
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F911h
			mov		A, 0x33
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F912h
			mov		A, 0x34
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F913h
			mov		A, 0x35
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F914h
			mov		A, 0x36
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F915h
			mov		A, 0x37
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F916h
			mov		A, 0x38
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F917h
			mov		A, 0x39
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F918h
			mov		A, 0x3A
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F919h
			mov		A, 0x3B
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F91Ah
			mov		A, 0x3C
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F91Bh
			mov		A, 0x3D
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F91Ch
			mov		A, 0x3E
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F91Dh
			mov		A, 0x3F
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F91Eh
			mov		A, 0x40
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F91Fh
			mov		A, 0x41
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A




			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F920h
			mov		A, 0x52
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F921h
			mov		A, 0x53
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F922h
			mov		A, 0x54
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F923h
			mov		A, 0x55
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F924h
			mov		A, 0x56
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F925h
			mov		A, 0x57
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F926h
			mov		A, 0x58
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F927h
			mov		A, 0x59
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F928h
			mov		A, 0x5A
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F929h
			mov		A, 0x5B
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F92Ah
			mov		A, 0x5C
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F92Bh
			mov		A, 0x5D
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F92Ch
			mov		A, 0x5E
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F92Dh
			mov		A, 0x5F
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F92Eh
			mov		A, 0x50
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			mov		FLKEY, #0A5h
			mov		FLKEY, #0F1h
			mov		PSCTL, #00000001b
			MOV 	DPTR,#0F92Fh
			mov		A, 0x51
			movx	@DPTR, A
			mov		PSCTL, #00000000b
			clr		A


			setb	settings_saved
			setb	display_clr
			mov		R3, #00h
			setb	IE_EA
			ljmp	DISPLAY

saved_0:	cjne	R3, #76d, saved_1

			setb	LED_GREEN
			clr		LED_RED
			clr		LED_WHITE
			clr		Kalibrieren
			mov		LFO0CN, #0FFh
			mov		WDTCN, #0A5h
			mov		WDTCN, #06h
			jmp		$
			nop


saved_1:	inc		R3
			mov		A, R3
			call	TAB_saved
			mov		R0, A
			ljmp	DISPLAY

TAB_saved:	movc	A,@A+PC
			ret

			DB		20h
			DB		20h
			DB		56h
			DB		61h
			DB		6Ch
			DB		75h
			DB		65h
			DB		73h
			DB		20h
			DB		73h
			DB		61h
			DB		76h
			DB		65h
			DB		64h
			DB		20h
			DB		20h


			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		73h
			DB		75h
			DB		63h
			DB		63h
			DB		65h
			DB		73h
			DB		73h
			DB		66h
			DB		75h
			DB		6Ch
			DB		6Ch
			DB		79h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		72h
			DB		65h
			DB		73h
			DB		74h
			DB		61h
			DB		72h
			DB		74h
			DB		69h
			DB		6Eh
			DB		67h
			DB		2Eh
			DB		2Eh
			DB		2Eh
			DB		20h
			DB		20h
			DB		20h
			ret



ERROR1:		cjne	R3, #76d, ERROR3
			clr		LED_GREEN
			setb	LED_RED
			clr		LED_WHITE
			jmp		$

ERROR3:		mov		IE, #0C0h
			inc		R3
			mov		A, R3
			call	TAB_ERROR
			mov		R0, A
			jmp		DISPLAY

TAB_ERROR:	movc	A,@A+PC
			ret

			DB		20h
			DB		20h
			DB		46h
			DB		41h
			DB		54h
			DB		41h
			DB		4Ch
			DB		20h
			DB		45h
			DB		52h
			DB		52h
			DB		4Fh
			DB		52h
			DB		21h
			DB		20h
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		70h
			DB		6Ch
			DB		65h
			DB		61h
			DB		73h
			DB		65h
			DB		20h
			DB		63h
			DB		6Fh
			DB		6Eh
			DB		74h
			DB		61h
			DB		63h
			DB		74h
			DB		3Ah
			DB		20h

			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		69h
			DB		6Eh
			DB		66h
			DB		6Fh
			DB		40h
			DB		76h
			DB		65h
			DB		63h
			DB		74h
			DB		6Fh
			DB		72h
			DB		66h
			DB		6Fh
			DB		72h
			DB		63h
			DB		65h

			DB		20h
			DB		20h
			DB		20h
			DB		20h

			DB		2Eh
			DB		64h
			DB		65h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			DB		20h
			ret


END
