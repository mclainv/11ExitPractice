;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Bottom Status Bar v1.1
;by Ice Man
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lorom							;\ ROM is LoRom
	header							;/ and has a header	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Definitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	!FreeSpace = $208000			;| POINT THIS TO SOME FREE SPACE!!!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Hijacked routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	org $008CFF						;\ Hijack game mode 04
	JSL New_GM04_DMA				;| and jump to our routine
	RTS								;/ Return

	org $008DAC						;\ Hijack status bar
	JSL Status_Bar					;| and jump to our routine
	RTS								;/ Return

	org $009079						;\ Hijack item box sprite
	JSL ItemBox_Sprite				;| and jump to our routine
	RTS								;/ Return

	org $0092AD						;\ Fix lava height
	LDX #$01A0						;/ in platform battles

	org $009853						;\ Sprites over windowing
	db $30							;/ in platform battles
	
	org $01BDD6						;\ Hijack Magikoopa sprite
	JSL Magikoopa_Fix				;| and jump to our routine
	NOP								;/ NOP x1

	org $028008						;\ Hijack item box
	JSL ItemBox_Routine				;| and jump to our routine
	RTL								;| Return
	NOP								;/ NOP x1

	org $03B447						;\ Bowser item box GFX
	db $07,$07,$17,$17				;/ Y-Position

	org $03B457						;\ Always display item box
	NOP #5							;/ in Bowser battle

	org $03C0E0						;\ Lava position in
	db $C4							;/ platform battles

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;RATS Tag Macro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro RATS_start(id)
	db "STAR"
	dw RATS_Endcode<id>-RATS_Startcode<id>
	dw RATS_Endcode<id>-RATS_Startcode<id>^#$FFFF
RATS_Startcode<id>:
endmacro

macro RATS_end(id)
RATS_Endcode<id>:
endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Modified Game Mode 04 Routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	org !FreeSpace					;| Insert location of code
%RATS_start(1)
New_GM04_DMA:
	LDA $1BE3						;\ Load layer 3 tilemap value
	BNE Boss_Battle_01				;/ If not equal, status bar is on top

	LDA $0D9B						;\ Load fight mode value
	BNE Boss_Battle_01				;/ If not equal, status bar is on top

	LDA #$80						;\ Set VRAM Address Increment Value to x80
	STA $2115						;| 
	LDA #$0E						;| Set Address for VRAM Read/Write to x530E
	STA $2116						;| Address for VRAM Read/Write (Low Byte)
	LDA #$53						;| 
	STA $2117						;| 
	BRA Before_Loop_01				;/ Continue code

Boss_Battle_01:
	LDA #$80						;\ Set VRAM Address Increment Value to x80
	STA $2115						;| 
	LDA #$2E						;| Set Address for VRAM Read/Write to x502E
	STA $2116						;| Address for VRAM Read/Write (Low Byte)
	LDA #$50						;| 
	STA $2117						;/ 

Before_Loop_01:
	LDX #$06						;\ $06 bytes
Loop_01:
	LDA $8D90,X						;| Get data from table
	STA $4310,X						;| Store to DMA registers
	DEX								;| Decrease X
	BPL Loop_01						;/ Loop code
 
	LDA #$02						;\ Activate DMA channel 1
	STA $420B						;/ Regular DMA Channel Enable

	LDA $1BE3						;\ Load layer 3 tilemap value
	BNE Boss_Battle_02				;/ If not equal, status bar is on top

	LDA $0D9B						;\ Load fight mode value
	BNE Boss_Battle_02				;/ If not equal, status bar is on top

	LDA #$80						;\ Set VRAM Address Increment Value to x80
	STA $2115						;| 
	LDA #$22						;| Set Address for VRAM Read/Write to x5322
	STA $2116						;| Address for VRAM Read/Write (Low Byte)
	LDA #$53						;| 
	STA $2117						;| 
	BRA Before_Loop_02				;/ Continue code

Boss_Battle_02:
	LDA #$80						;\ Set VRAM Address Increment Value to x80
	STA $2115						;| 
	LDA #$42						;| Set Address for VRAM Read/Write to x5042
	STA $2116						;| Address for VRAM Read/Write (Low Byte)
	LDA #$50						;| 
	STA $2117						;/ 

Before_Loop_02:
	LDX #$06						;\ $06 bytes
Loop_02:
	LDA $8D97,X						;| Get data from table
	STA $4310,X						;| Store to DMA registers
	DEX								;| Decrease X
	BPL Loop_02						;/ Loop code

	LDA #$02						;\ Activate DMA channel 1
	STA $420B						;/ Regular DMA Channel Enable

	LDA $1BE3						;\ Load layer 3 tilemap value
	BNE Boss_Battle_03				;/ If not equal, status bar is on top

	LDA $0D9B						;\ Load fight mode value
	BNE Boss_Battle_03				;/ If not equal, status bar is on top

	LDA #$80						;\ Set VRAM Address Increment Value to x80
	STA $2115						;| 
	LDA #$43						;| Set Address for VRAM Read/Write to x5343
	STA $2116						;| Address for VRAM Read/Write (Low Byte)
	LDA #$53						;| 
	STA $2117						;| 
	BRA Before_Loop_03				;/ Continue code

Boss_Battle_03:
	LDA #$80						;\ Set VRAM Address Increment Value to x80
	STA $2115						;| 
	LDA #$63						;| Set Address for VRAM Read/Write to x5063
	STA $2116						;| Address for VRAM Read/Write (Low Byte)
	LDA #$50						;| 
	STA $2117						;/ 

Before_Loop_03:
	LDX #$06						;\ $06 bytes
Loop_03:
	LDA $8D9E,X						;| Get data from table
	STA $4310,X						;| Store to DMA registers
	DEX								;| Decrease X
	BPL Loop_03						;/ Loop code

	LDA #$02						;\ Activate DMA channel 1
	STA $420B						;/ Regular DMA Channel Enable

	LDA $1BE3						;\ Load layer 3 tilemap value
	BNE Boss_Battle_04				;/ If not equal, status bar is on top

	LDA $0D9B						;\ Load fight mode value
	BNE Boss_Battle_04				;/ If not equal, status bar is on top

	LDA #$80						;\ Set VRAM Address Increment Value to x80
	STA $2115						;| 
	LDA #$6E						;| Set Address for VRAM Read/Write to x536E
	STA $2116						;| Address for VRAM Read/Write (Low Byte)
	LDA #$53						;| 
	STA $2117						;| 
	BRA Before_Loop_04				;/ Continue code

Boss_Battle_04:
	LDA #$80						;\ Set VRAM Address Increment Value to x80
	STA $2115						;| 
	LDA #$8E						;| Set Address for VRAM Read/Write to x508E
	STA $2116						;| Address for VRAM Read/Write (Low Byte)
	LDA #$50						;| 
	STA $2117						;/ 

Before_Loop_04:
	LDX #$06						;\ $06 bytes
Loop_04:
	LDA $8DA5,X						;| Get data from table
	STA $4310,X						;| Store to DMA registers
	DEX								;| Decrease X
	BPL Loop_04						;/ Loop code

	LDA #$02						;\ Activate DMA channel 1
	STA $420B						;/ Regular DMA Channel Enable

	LDX #$36						;\ $36 bytes
	LDY #$6C						;| Load something in Y

Loop_05:
	LDA $8C89,Y						;\ Get data from table 
	STA $0EF9,X						;| and draw the status bar
	DEY								;| Decrease Y
	DEY 							;| Decrease Y
	DEX 							;| Decrease X
	BPL Loop_05						;/ Loop code

	LDA #$28						;\ Set timer frame
	STA $0F30						;| counter to #$28
	RTL								;/ Return 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Modified Status Bar Code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Status_Bar:
	LDA $1BE3						;\ Load layer 3 tilemap value
	BNE Boss_Battle_05				;/ If not equal, status bar is on top

	LDA $0D9B						;\ Load fight mode value
	BNE Boss_Battle_05				;/ If not equal, status bar on top

	LDA #$09						;\ Layer 3 has
	STA $3E							;/ priority

	STZ $22							;\ 
	STZ $23							;| Fixed layer 3
	STZ $24							;| position
	STZ $25							;/ 

	STZ $2115						;\ Set VRAM Address Increment Value to x00
	LDA #$22						;| 
	STA $2116						;| Set Address for VRAM Read/Write to x5322
	LDA #$53						;| Address for VRAM Read/Write (Low Byte)
	STA $2117						;| 
	BRA Before_SB_Loop_01			;/ Continue code

Boss_Battle_05:
	STZ $2115						;\ Set VRAM Address Increment Value to x00
	LDA #$42						;| 
	STA $2116						;| Set Address for VRAM Read/Write to x5042
	LDA #$50						;| Address for VRAM Read/Write (Low Byte)
	STA $2117						;/ 

Before_SB_Loop_01:
	LDX #$06						;\ $06 bytes
SB_Loop_01:
	LDA SB_DMA_Table_01,X			;| Get data from table
	STA $4310,X						;| Store to DMA registers
	DEX								;| Decrease X
	BPL SB_Loop_01					;/ Loop code

	LDA #$02						;\ Activate DMA channel 1
	STA $420B						;/ Regular DMA Channel Enable

	LDA $1BE3						;\ Load layer 3 tilemap value
	BNE Boss_Battle_06				;/ If not equal, status bar is on top

	LDA $0D9B						;\ Load fight mode value
	BNE Boss_Battle_06				;/ If not equal, status bar on top

	STZ $2115						;\ Set VRAM Address Increment Value to x00
	LDA #$43						;| 
	STA $2116						;| Set Address for VRAM Read/Write to x5343
	LDA #$53						;| Address for VRAM Read/Write (Low Byte)
	STA $2117						;| 
	BRA Before_SB_Loop_02			;/ Continue code

Boss_Battle_06:
	STZ $2115						;\ Set VRAM Address Increment Value to x00
	LDA #$63						;| 
	STA $2116						;| Set Address for VRAM Read/Write to x5063
	LDA #$50						;| Address for VRAM Read/Write (Low Byte)
	STA $2117						;/ 

Before_SB_Loop_02:
	LDX #$06						;\ $06 bytes
SB_Loop_02:
	LDA SB_DMA_Table_02,X			;| Get data from table
	STA $4310,X						;| Store to DMA registers
	DEX								;| Decrease X
	BPL SB_Loop_02					;/ Loop code

	LDA #$02						;\ Activate DMA channel 1
	STA $420B						;| Regular DMA Channel Enable
	RTL								;/ Return

SB_DMA_Table_01:
	db $00,$18,$F9,$0E,$00,$1C,$00	;| DMA settings 2nd row (timers,etc)

SB_DMA_Table_02:
	db $00,$18,$15,$0F,$00,$1B,$00	;| DMA settings 3rd row (timers,etc)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Modified ItemBox Sprite
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ItemBox_Sprite:
	LDY #$E0						;\ Load $E0 to Y
	BIT $0D9B						;| Check bits but do not store
	BVC Sprite_Routine				;/ If overflow flag clear, skip code

	LDY #$00						;\ Load $00 to Y
	LDA $0D9B						;| Load fight mode value
	CMP #$C1						;| and compare with $C1 (bowser battle)
	BEQ Sprite_Routine				;/ If equal, skip code

	LDA #$F0						;\ Y-position of item
	STA $0201,Y						;/ is stored here then

Sprite_Routine:
	STY $01							;\ Store previous value from Y here
	LDY $0DC2						;| Load reserved item into Y
	BEQ Sprite_Return				;/ If empty, return

	LDA $8E01,Y						;\ Get data from table
	STA $00							;| and store here
	CPY #$03						;| Compare Y with $03
	BNE Draw_Sprite					;/ If not equal, skip code

	LDA $13							;\ Frame counter
	LSR								;| Divide by 2
	AND #$03						;| AND #$03
	PHY								;| Push Y
	TAY								;| Transfer A to Y
	LDA $8DFE,Y						;| Get data from table
	PLY								;| Pull Y
	STA $00							;/ Store here

Draw_Sprite:
	LDY $01							;\ Load previous Y value again
	LDA #$78						;| X-position of item
	STA $0200,Y						;/ is stored here

	LDA $1BE3						;\ Load layer 3 tilemap value
	BNE Boss_Item					;/ If not equal, status bar is on top

	LDA $0D9B						;\ Load fight mode value
	BNE Boss_Item					;/ If not equal, item is on top

	LDA #$C7						;\ Y-position of item
	STA $0201,Y						;| is stored here
	BRA Store_Item					;/ Continue code

Boss_Item:
	LDA #$0F						;\ Y-position of item
	STA $0201,Y						;/ is stored here

Store_Item:
	LDA #$30						;\ Get properties
	ORA $00							;| and settings from before
	STA $0203,Y						;/ and store here
	LDX $0DC2						;| Reserved item into X
	LDA $8DF9,X						;| Tilemap from table
	STA $0202,Y						;| is stored here
	TYA								;| Transfer Y to A
	LSR								;| Divide by 2
	LSR								;| Divide by 4
	TAY								;| Transfer A to Y
	LDA #$02						;| Sprite tilemap
	STA $0420,Y						;/ stuff (8x8 / 16x16)
             
Sprite_Return:
	RTL								;| Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Magikoopa Fix for Layer 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Magikoopa_Fix:
	LDA #$1F						;\ Set everything to be on
	STA $212C						;| main screen
	STZ $212D						;| Nothing is on sub screen
	LDA #$01						;| Restore previously
	STA $15D0,X						;| hijacked Magikoopa code
	RTL								;/ Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Modified ItemBox Routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Item_Return:
	PLX								;\ Pull X
	RTL								;/ Return

ItemBox_Routine:
	PHX								;\ Push X
	LDA $0DC2						;| Check item box item
	BEQ Item_Return					;/ If empty, return

	STZ $0DC2						;\ Zero out item once it falls
	PHA								;| Push A
	LDA #$0C						;| Play sound effect
	STA $1DFC						;/ when item falls

	LDX #$0B						;\ $0B bytes
Item_Loop_01:
	LDA $14C8,X						;| Check sprite status
	BEQ Item_Fall					;| If 0, return
	DEX								;| Decrease X
	BPL Item_Loop_01				;/ Loop code

	DEC $1861						;\ Decrease slot for sprites being overwritten
	BPL Continue					;| If plus, continue
	LDA #$01						;| Set sprite to overwrite
	STA $1861						;/ to #$01.

Continue:
	LDA $1861						;\ Load slot for sprites being overwritten
	CLC								;| Clear carry flag
	ADC #$0A						;| and add #$0A
	TAX								;| Transfer A to X
	LDA $9E,X						;| Get sprite number
	CMP #$7D						;| and compare with sprite 7D
	BNE Item_Fall					;/ if not equal, item falls

	LDA $14C8,X						;\ Check sprite status
	CMP #$0B						;| and compare with 0B
	BNE Item_Fall					;| if not equal, item falls
	STZ $13F3						;/ Not a P-Balloon

Item_Fall:
	LDA #$08						;\ Set sprite status to 08
	STA $14C8,X						;| (normal sprite)
	PLA								;| Pull A
	CLC								;| Clear carry flag
	ADC #$73						;| and add #$73 (starting with Mushroom)
	STA $9E,X						;/ Store to sprite number

	JSL $07F7D2 					;| Jump to InitSpriteTables routine

	LDA $1BE3						;\ Load layer 3 tilemap value
	BNE Boss_Fall					;/ If not equal, status bar is on top

	LDA $0D9B						;\ Load fight mode value
	BNE Boss_Fall					;/ If not equal, item falls from top

	LDA $94							;\ Item X-position = Mario X-position
	STA $E4,X						;/ (low byte)

	LDA $95							;\ Item X-position = Mario X-position
	STA $14E0,X						;/ (high byte)

	LDA $96							;\ 
	SEC								;| Item Y-position = Mario Y-position
	SBC #$20						;| (low byte)
	STA $D8,X						;/ 

	LDA $97							;\ Item Y-position = Mario Y-position
	SBC #$00						;| (high byte)
	STA $14D4,X						;| 
	BRA Item_Blink					;/ Continue code

Boss_Fall:
	LDA #$78						;\ Load #$78
	CLC								;| Clear carry flag
	ADC $1A							;| and add layer 1 X-position (low byte)
	STA $E4,X						;/ Store to Sprite X-position (low byte)

	LDA $1B							;\ Load layer 1 X-position (high byte)
	ADC #$00						;| Add nothing
	STA $14E0,X						;/ Store to sprite X-position (high byte)

	LDA #$20						;\ Load #$20
	CLC								;| Clear carry flag
	ADC $1C							;| Add layer 1 Y-position (low byte)
	STA $D8,X						;/ Store to sprite Y-postion (low byte)

	LDA $1D							;\ Load layer 1 Y-position (high byte)
	ADC #$00						;| Add nothing
	STA $14D4,X						;/ Store to sprite Y-position (high byte)

Item_Blink:
	INC $1534,X						;\ Blinking power-up = activated
	PLX								;| Pull X
	RTL								;/ Return
%RATS_end(1)