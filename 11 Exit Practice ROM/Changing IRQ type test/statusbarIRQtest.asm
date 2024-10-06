!offset = $40+$1C0 ;moving everything down one tile
!offsetCorner = $02+!offset
!offsetInput = $18+!offset
!offsetTrickInfo = $CA+!offset

;Super Status Bar Advanced v2, by Kaijyuu. Patch updated by GreenHammerBro.
;See image file "ASSB_map.png" on how to use the status bar tiles.
incsrc "StatusBarDefines/SA1Defines.asm"
incsrc "StatusBarDefines/StatusBarDefines.asm"
print ""
print "Super Status bar RAM range (inclusive): $", hex(!RAM_BAR), " to $", hex(!RAM_BAR+319)
print ""

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Hijacks:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORG $008292					;\Move the cutoff Irq line (not for smw's mode 7 bosses however).
	LDY #$D0	;/

ORG $00835C					;\Move the cutoff Irq line (for smw's mode 7 bosses).
	LDY #$D0	;/

ORG $008D8A			; hijack status bar initilization routine
	autoclean JSL MAIN_2
	NOP			; fill in a byte

ORG $008DB6
	BRA SKIP_UNUSED		; skip past unused code
				; This spot was chosen for compatibility with sprite status bar and stripe image uploader
				; (sprite status bar requires some RAM address tweaks within it's code to be compatible with this)

ORG $008DE2			; near end of DrawStatusBar (error on asar, just because of ":")
SKIP_UNUSED:
	autoclean JSL MAIN 			;Point to new routine

	RTS


ORG $008E1F			; hijack routine that updates status bar tiles in RAM ($008E1A used by uberasm tool)
	autoclean JML MAIN_3

ORG $0090D0		; make this into a JSL routine instead JSR
	RTL


ORG $0090AE
	db !ITEM_X	; set item box item x position 
ORG $0090B3
	db !ITEM_Y	; set item box item y position
ORG $0090B8
	DB !ITEM_PRIORITY	; set item box item priority bits
ORG $0090CC
	DB !ITEM_SIZE		; set item box item size/high x bit

freecode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Tables for tiles.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DATA_TILES:			;\This is the data for the tiles not regularly uploaded by SMW
	db $FC,$38		;|First number is the tile number, second is the properties
	db $FC,$38		;|YXPCCCTT
	db $FC,$38		;|Y = y flip, X = flip, P = priority, CCC = palette number (4 color palettes remember)
	db $FC,$38		;|TT = page number
	db $FC,$38		;|Ex: $38 = 00111000
	db $FC,$38		;|priority bit set, palette 7 (of 8)
	db $FC,$38		;|FC is a blank tile with SMW's original l3 graphics
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|This whole block is the top row of status bar tile space.
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;/

DATA_TILES2:			;\Start of second line, the first 14 8x8 spaces on second row
	db $FC,$38		;|seen on ASSB map.png.
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;/
	;
	; Item box would be here. Already DMA'd in SMW's regular code
	; Not included here for compatibility with the status bar editor tool
	;
DATA_TILES3:
	db $FC,$38		;\End of second line, The last 14 8x8 spaces (the right 14)
	db $FC,$38		;|on the second row seen on ASSB_map.png.
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;/
DATA_TILES4:
	; two tiles at the upper middle left
	db $FC,$38		;\Third line, the first two 8x8 spaces (two tiles left from the NAME text).
	db $FC,$38		;/
DATA_TILES5:
	; two tiles at the upper middle right
	db $FC,$38		;\Third line, the last two 8x8 spaces (two tiles right from the coin counter
	db $FC,$38		;/(not the coin and "X" symbol)).
DATA_TILES6:
	; three tiles at the lower middle left
	db $FC,$38		;\Fourth line, the first 3 8x8 spaces before the "X" symbol and lives counter.
	db $FC,$38		;|
	db $FC,$38		;/
DATA_TILES7:
	; two tiles at the lower middle right
	db $FC,$38		;\Fourth line, the last two 8x8 spaces after the last 0 on the score counter.
	db $FC,$38		;/
DATA_TILES8:
	; bottom row
	db $FC,$38		;\Fifth line, the first 14 8x8 spaces.
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;/
	;
	; Item box would be here. Already DMA'd in SMW's regular code
	; Not included here for compatibility with the status bar editor tool
	;
DATA_TILES9:
	db $FC,$38		;\Fifth line, the last 14 8x8 spaces.
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;/

DMA_BAR:		db	$01,$18,!RAM_BAR,!RAM_BAR>>8,!RAM_BAR>>16,$40,$02
;^ ">>X", where x is how many times the number is divided by 2, so that it converts
;the freeram into DMA table bytes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Main code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MAIN_2:				; Uploads tiles to ram and DMAs new tiles
	PHB
	PHK
	PLB
	PHY
	PHX


	PHB
	LDA #$00		; set bank to 00
	PHA
	PLB
	
	REP #$10		; 16 bit X Y

	LDY #$0007		; 
	LDX #$0063		; Upload status bar tiles to ram
UPLOAD_STATBAR1:		; 
	LDA $8C81,y		; Top of item box
	STA !RAM_BAR,X		; 
	DEX
	DEY
	BPL UPLOAD_STATBAR1
	LDY #$0037		; top middle of status bar
	LDX #$00BB
UPLOAD_STATBAR2:
	LDA $8C89,Y
	STA !RAM_BAR,X
	DEX
	DEY
	BPL UPLOAD_STATBAR2
	LDY #$0035		; low middle of status bar
	LDX #$00FB
UPLOAD_STATBAR3:
	LDA $8CC1,Y
	STA !RAM_BAR,X
	DEX
	DEY
	BPL UPLOAD_STATBAR3
	LDY #$0007		; bottom of item box
	LDX #$0123
UPLOAD_STATBAR4:
	LDA $8CF7,Y
	STA !RAM_BAR,X
	DEX
	DEY
	BPL UPLOAD_STATBAR4

	PLB			; reset bank

	LDY #$005B		; get tiles from here and store to RAM
	LDX #$005B
UPLOAD_STATBAR5:
	LDA DATA_TILES,Y
	STA !RAM_BAR,x
	DEX
	DEY
	BPL UPLOAD_STATBAR5

	LDY #$001F		
	LDX #$0083
UPLOAD_STATBAR6:
	LDA DATA_TILES3,Y
	STA !RAM_BAR,x
	DEX
	DEY
	BPL UPLOAD_STATBAR6

	LDY #$0009		
	LDX #$00C5
UPLOAD_STATBAR7:
	LDA DATA_TILES5,Y
	STA !RAM_BAR,x
	DEX
	DEY
	BPL UPLOAD_STATBAR7

	LDY #$001F		
	LDX #$011B
UPLOAD_STATBAR8:
	LDA DATA_TILES7,Y
	STA !RAM_BAR,x
	DEX
	DEY
	BPL UPLOAD_STATBAR8

	LDY #$001B		
	LDX #$013F
UPLOAD_STATBAR9:
	LDA DATA_TILES9,Y
	STA !RAM_BAR,x
	DEX
	DEY
	BPL UPLOAD_STATBAR9

      	LDA #!TIME_SPEED		; Recover old code
      	STA $0F30+!addr      		; #$28 -> Timer frame counter 

DMA_STATBAR:	

	SEP #$10	; 8 bit X Y


	LDA #$80
	STA $2115
	LDA #$00
	STA $2116	; DMA it
	LDA #$50
	STA $2117
	LDX #$06
DMA_LOOP:
	LDA DMA_BAR,x
	STA $4310,x
	DEX
	BPL DMA_LOOP	
	LDA #$02
	STA $420B	

	PLX
	PLY
	PLB



	RTL


MAIN:	PHB
	PHY
	PHX		; wrapper thingy
	PHK
	PLB
	;-----------------------------------------------------------------
	--
	;this code below adds the red timer and/or beeping warning.
	if !timer_warning != 0
	LDA $0F31+!addr	;\If all digits = 0, then no warning
	ORA $0F32+!addr	;|(so its safe to use in a level with no time
	ORA $0F33+!addr	;|limit).
	BEQ no_red_timer	;/
	LDA $0F31+!addr	;\If timer >= 100, then use defualt color
	BNE no_red_timer	;/
	LDA $0F32+!addr	;\If timer >= 10 then no warning sound
	BNE no_warning_sound	;/
	LDA $0F30+!addr	;\If frame counter <> max then don't play 10 second warning
	CMP #!TIME_SPEED	;|
	BNE no_warning_sound	;/
	LDA #$23		;\play sound each time the timer has 1 smw second subtracted
	STA $1DFC+!addr	;/
no_warning_sound:
	LDA.b #%00101100	;".b" so asar reconizes as its a byte; this is the color if < 100
	BRA store_prop
no_red_timer:
	LDA.b #%00111100	;>color for >= 100
store_prop:
	STA !RAM_BAR+!TIME_OFFSET+1	;\digits
	STA !RAM_BAR+!TIME_OFFSET+3	;|
	STA !RAM_BAR+!TIME_OFFSET+5	;/
	STA !RAM_BAR+$A7		;\the word "TIME".
	STA !RAM_BAR+$A9		;|
	STA !RAM_BAR+$AB		;/
	endif
	;-------------------------------------------------------------------
	; If you would like to add any subroutines that are run every frame the status bar is, 
	; feel free to stick them right here. However this runs during v-blank; HDMA AND TOP OF
	; THE SCREEN WILL GLITCH OUT IF YOU PUT TOO MUCH CODES HERE! I don't know how much is
	; the limit that will glitch, if you are too concern, use uberasm (but disable the
	; status bar hijack first) and write HUD using gamemode 13 and 14.

	JMP DMA_STATBAR		;>BUT DO NOT DELETE THIS LINE!!

Imgs: db $2E,$55,$56,$66



DATA_008DF5:		      db $40,$41,$42,$43,$44	;>luigi's name?

DATA_008E06:		      db $B7

DATA_008E07:		      db $C3,$B8,$B9,$BA,$BB,$BA,$BF,$BC
				  db $BD,$BE,$BF,$C0,$C3,$C1,$B9,$C2
				  db $C4,$B7,$C5

; DATA_SELECTMENU:


MAIN_3:
	PHB
	PHK
	PLB		; wrapper
			; Basically copy/pasted code from all.log
			; modified to use new RAM addresses
	LDA $15
	AND #$20
	REP #$30
	BEQ .clear

	.clear
		LDX #$01FE ; expanded hud= #$01FE
		LDA #$38FC ; black
	-	STA $7FA040,X
		DEX
		DEX
		BPL -

		SEP #$30
		LDA $010B ; level number
		CMP #$13 : BNE +
			JSR GhostHouseInput
		+
		REP #$30
		LDA $010B ; level number
		CMP #$0101 : BNE +
			SEP #$30
			JSR IggyInput
		+
		SEP #$30
		JSR InputDisplay
		SEP #$30
			PLB
			JML $008FF9

HexToDec:		    	LDX #$00			;| 
	CODE_009047:		CMP #$0A			;| 
	CODE_009049:		BCC Return009050		;|Sets A to 10s of original A 
	CODE_00904B:		SBC #$0A			;|Sets X to 1s of original A 
	CODE_00904D:		INX		       		;| 
	CODE_00904E:		BRA CODE_009047	   		;|>loop

	Return009050:       RTS
;xcord start

;input display start
InputDisplay:
		; first row =====================
		; L shoulder button ----------------
		LDA $17
		AND #$20
		BEQ L
		LDA #$3D	; pressed
		STA $7FA000+!offsetInput+$00
		LDA #$3E
		BRA L2
		L:
		LDA #$3A	; not pressed
		STA $7FA000+!offsetInput+$00
		LDA #$3B
		L2:
		STA $7FA000+!offsetInput+$02
		;     YXPCCCTT - YX flip, CCC palette
		LDA #%00111000
		STA $7FA000+!offsetInput+$01
		STA $7FA000+!offsetInput+$03

		; Up dpad ----------------
		LDA $15
		AND #$08
		BEQ U
		LDA #$40	; pressed
		BRA U2
		U:
		LDA #$30	; not pressed
		U2:
		STA $7FA000+!offsetInput+$04
		;     YXPCCCTT - YX flip, CCC palette
		LDA #%00101100
		STA $7FA000+!offsetInput+$05

		; X button ----------------
		LDA $17
		AND #$40
		BEQ X
		LDA #$33	; pressed
		BRA X2
		X:
		LDA #$32	; not pressed
		X2:
		STA $7FA000+!offsetInput+$0C
		;     YXPCCCTT - YX flip, CCC palette
		LDA #%00101100
		STA $7FA000+!offsetInput+$0D

		; R shoulder button ----------------
		LDA $17
		AND #$10
		BEQ R
		LDA #$3F	; pressed
		STA $7FA000+!offsetInput+$0E
		LDA #$3D
		BRA R2
		R:
		LDA #$3B	; not pressed
		STA $7FA000+!offsetInput+$0E
		LDA #$3A
		R2:
		STA $7FA000+!offsetInput+$10
		;     YXPCCCTT - YX flip, CCC palette
		LDA #%01111000
		STA $7FA000+!offsetInput+$0F
		STA $7FA000+!offsetInput+$11

		; second row =====================
		; left dpad ----------------
		LDA $15
		AND #$02
		BEQ Left
		LDA #$41	; pressed
		BRA Left2
		Left:
		LDA #$31	; not pressed
		Left2:
		STA $7FA000+!offsetInput+$42
		;     YXPCCCTT - YX flip, CCC palette
		LDA #%00101100
		STA $7FA000+!offsetInput+$43

		; right dpad ----------------
		LDA $15
		AND #$01
		BEQ Right
		LDA #$41	; pressed
		BRA Right2
		Right:
		LDA #$31	; not pressed
		Right2:
		STA $7FA000+!offsetInput+$46
		;     YXPCCCTT - YX flip, CCC palette
		LDA #%01101100
		STA $7FA000+!offsetInput+$47

		; Y button ----------------
		LDA $0DA2
		AND #$40
		BEQ Y
		LDA #$34	; pressed
		BRA Y2
		Y:
		LDA #$32	; not pressed
		Y2:
		STA $7FA000+!offsetInput+$4A
		;     YXPCCCTT - YX flip, CCC palette
		LDA #%00111100
		STA $7FA000+!offsetInput+$4B

		; A button ----------------
		LDA $0DA4
		AND #$80
		BEQ A
		LDA #$43	; pressed
		BRA A2
		A:
		LDA #$42	; not pressed
		A2:
		STA $7FA000+!offsetInput+$4E
		;     YXPCCCTT - YX flip, CCC palette
		LDA #%00101100
		STA $7FA000+!offsetInput+$4F

		; third row =====================
		; down dpad ----------------
		LDA $15
		AND #$04
		BEQ D
		LDA #$40	; pressed
		BRA D2
		D:
		LDA #$30	; not pressed
		D2:
		STA $7FA000+!offsetInput+$84
		;     YXPCCCTT - YX flip, CCC palette
		LDA #%10101100
		STA $7FA000+!offsetInput+$85

		; B button ----------------
		LDA $0DA2
		AND #$80
		BEQ B
		LDA #$44	; pressed
		BRA B2
		B:
		LDA #$42	; not pressed
		B2:
		STA $7FA000+!offsetInput+$8C
		;     YXPCCCTT - YX flip, CCC palette
		LDA #%00111100
		STA $7FA000+!offsetInput+$8D

		; Center of dpad - shows if diagonal/impossible direction combinations
		LDA $15
		AND #$0F
		TAX
		LDA DpadCenterTable,X
		BNE +
		LDA #$FC
		STA $7FA000+!offsetInput+$44
		BRA ++
		+
		AND #$01
		ORA #$46
		STA $7FA000+!offsetInput+$44
		LDA DpadCenterTable,X
		AND #%11000000
		ORA #%00101100
		STA $7FA000+!offsetInput+$45
		++
		RTS
	;input display end
	DpadCenterTable:
		;f = flag to draw center graphics
		;g = which graphics to use (0 = solid, 1 = diag)
		;YX = flip
		;   YX    fg	 UDLR
		db %00000000	;0000
		db %00000000	;0001
		db %00000000	;0010
		db %00000010	;0011
		db %00000000	;0100
		db %11000011	;0101
		db %10000011	;0110
		db %00000010	;0111
		db %00000000	;1000
		db %01000011	;1001
		db %00000011	;1010
		db %00000010	;1011
		db %00000010	;1100
		db %00000010	;1101
		db %00000010	;1110
		db %00000010	;1111

; Global defines
!showhud = $7FA501
; Global strings
	str_early:		; "PRESSED A: 0 F EARLY"	 20 tiles, 20*2= 40-2= 38,ldx #$26
		db $19, $38, $1b, $38, $0e, $38, $1c, $38, $1c, $38, $0e, $38, $0d, $38, $fc, $38, $0a, $38, $78, $38, $fc, $38, $00, $38, $fc, $38, $0f, $38, $fc, $38, $0e, $38, $0a, $38, $1b, $38, $15, $38, $22, $38

	str_late:		; "0 F LATE"   16 bytes, ldx #$0E
		db $00, $38, $fc, $38, $0f, $38, $fc, $38, $15, $38, $0a, $38, $1d, $38, $0e, $38

	str_success:		; "SUCCESS!"
		db $0c, $38, $18, $38, $1b, $38, $1b, $38, $0e, $38, $0c, $38, $1d, $38, $78, $38, $fc, $38, $05, $38, $27, $38, $07, $38
; Ghost House strings
	str_delay:		; "DELAY:  0 FRAMES"	 32 frames, ldx #$
		db $0d, $38, $0e, $38, $15, $38, $0a, $38, $22, $38, $78, $38, $fc, $38, $fc, $38, $00, $38, $fc, $38, $0f, $38, $1b, $38, $0a, $38, $16, $38, $0e, $38, $1c, $38

	str_delay2:		; "CORRECT: 5-7"
		db $0c, $38, $18, $38, $1b, $38, $1b, $38, $0e, $38, $0c, $38, $1d, $38, $78, $38, $fc, $38, $05, $38, $27, $38, $07, $38

	str_duck:		; "DUCK:  0F"   18 bytes, ldx #$10
		db $0d, $38, $1e, $38, $0c, $38, $14, $38, $78, $38, $fc, $38, $fc, $38, $00, $38, $0f, $38
; Ghost House Input
!huddelay = $7FA514
!hudduck = $7FA515
GhostHouseInput:
	lda !showhud
	bne +
		RTS
	+
	;string display
	;	delay
	LDX #$1E
 -	LDA str_delay,X
	STA !RAM_BAR+!offsetTrickInfo,X
	DEX
	DEX
	BPL -
	
	;	duck
	LDX #$10
 -	LDA str_duck,X
	STA !RAM_BAR+!offsetTrickInfo+$40,X
	DEX
	DEX
	BPL -

	;numbers
	;	delay
	LDA !huddelay
	JSR HexToDec
	STA !RAM_BAR+!offsetTrickInfo+$10
	TXA
	BNE ++ ; if 1s val is 0
		LDA #$FC
	++
	STA !RAM_BAR+!offsetTrickInfo+$0E

	lda !huddelay
			cmp #$05
			bcc ++
			cmp #$08
			bcs ++
				lda #$28
				STA !RAM_BAR+!offsetTrickInfo+$11
				STA !RAM_BAR+!offsetTrickInfo+$0F
			++
	;	duck
	LDA !hudduck
	JSR HexToDec
	STA !RAM_BAR+!offsetTrickInfo+$40+$0E
	TXA
	BNE ++ ; if 1s val is 0
		LDA #$FC
	++
	STA !RAM_BAR+!offsetTrickInfo+$40+$0C

	lda !hudduck
		cmp #$02
		bne ++
			lda #$28
			STA !RAM_BAR+!offsetTrickInfo+$40+$0F
			STA !RAM_BAR+!offsetTrickInfo+$40+$0D
		++
	RTS
; Iggy Input
;!success = 
!hudearly = $7FA50C
!hudlate = $7FA50D
IggyInput:
	lda !showhud
	bne +
		RTS
	+
		;lda !success : beq +

		;+
 ;early
	;string display
	lda !hudearly : beq +
	LDX #$26
 -	LDA str_early,X
	STA !RAM_BAR+!offsetTrickInfo,X
	DEX
	DEX
	BPL -
	;numbers
	lda !hudearly
	JSR HexToDec
	STA !RAM_BAR+!offsetTrickInfo+$16
	+
 ;late
	;string display
	lda !hudlate : beq +
	LDX #$0E
 -	LDA str_late,X
	STA !RAM_BAR+!offsetTrickInfo+$56,X
	DEX
	DEX
	BPL -
	;numbers
	LDA !hudlate
	JSR HexToDec
	STA !RAM_BAR+!offsetTrickInfo+$56
	+
	RTS




