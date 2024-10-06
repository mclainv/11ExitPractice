!offset = $40 ;moving everything down one tile
!offsetScore = $02+!offset
!offsetFlight = $32+!offset
!offsetSpeed = $72+!offset
!offsetShoulders = $16+!offset
!offsetChangeGuess = $5A+!offset
!offsetPrevNextVals = $9A+!offset
!offsetSuccess = $D8+!offset
!offsetGuessAorB = $114+!offset
!offsetQuizInfo = $60+!offset

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
ORG $009CB1					;Turn off new save cutscene
	db $00

ORG $008292					;\Move the cutoff Irq line (not for smw's mode 7 bosses however).
	LDY #!IRQ_line_Y_pos	;/

ORG $00835C					;\Move the cutoff Irq line (for smw's mode 7 bosses).
	LDY #!IRQ_line_Y_pos	;/

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

		JSR QuizDisplay
		JSR InputDisplayLR
		SEP #$30
			PLB
			JML $008FF9

HexToDec:		    	LDX #$00			;| 
	CODE_009047:		CMP #$0A			;| 
	CODE_009049:		BCC Return009050		;|Sets A to 1s of original A 
	CODE_00904B:		SBC #$0A			;|Sets X to 10s of original A 
	CODE_00904D:		INX		       		;| 
	CODE_00904E:		BRA CODE_009047	   		;|>loop

	Return009050:       RTS

;input display start
!showhud = $7FA501
InputDisplayLR:
	lda !showhud : bne +
		; L shoulder button ----------------
		LDA $17
		AND #$20
		BEQ L
		LDA #$3D	; pressed
		STA $7FA000+!offsetShoulders+$02
		LDA #$3E
		BRA L2
		L:
		LDA #$3A	; not pressed
		STA $7FA000+!offsetShoulders+$02
		LDA #$3B
		L2:
		STA $7FA000+!offsetShoulders+$04
		;     YXPCCCTT - YX flip, CCC palette
		LDA #%00111000
		STA $7FA000+!offsetShoulders+$03
		STA $7FA000+!offsetShoulders+$05
		
		; R shoulder button ----------------
		LDA $17
		AND #$10
		BEQ R
		LDA #$3F	; pressed
		STA $7FA000+!offsetShoulders+$0E
		LDA #$3D
		BRA R2
		R:
		LDA #$3B	; not pressed
		STA $7FA000+!offsetShoulders+$0E
		LDA #$3A
		R2:
		STA $7FA000+!offsetShoulders+$10
		;     YXPCCCTT - YX flip, CCC palette
		LDA #%01111000
		STA $7FA000+!offsetShoulders+$0F
		STA $7FA000+!offsetShoulders+$11
	+
		RTS
	;28=green, 2C=red
	str_flight_s:			; "FLIGHT"	6 tiles, 6*2= 12-2= 10, ldx #0A
		db $0f, $38, $15, $38, $12, $38, $10, $38, $11, $38, $1d, $38
		
	str_f_speed:			; "SPEED?"	6 tiles, 6*2= 12-2= 10, ldx #$0A
		db $1c, $38, $19, $38, $0e, $38, $0e, $38, $0d, $38, $27, $38

	str_guess_a_or_b:		; "GUESS:AorB" 10 tiles, 10*2= 20-2= 18, ldx #$12
		db $10, $38, $1e, $38, $0e, $38, $1c, $38, $1c, $38, $78, $38, $43, $30, $18, $38, $1b, $38, $44, $28
	
	str_score:				; "SCORE:  0"	8 tiles, 8*2= 16-2= 14, ldx #$10
		db $1c, $38, $0c, $38, $18, $38, $1b, $38, $0e, $38, $78, $38, $fc, $38, $fc, $38, $00, $38

	str_change_guess:		; "< 49 >"	6 tiles, 6*2= 12-2= 10, ldx #$0A
		db $77, $38, $fc, $38, $04, $38, $09, $38, $fc, $38, $2e, $38

	str_prev_next:			; "48  50"	6 tiles, 6*2= 12-2= 10, ldx #$0A
		db $04, $38, $08, $38, $fc, $38, $fc, $38, $05, $38, $00, $38

	str_success:			; "SUCCESS!" color, 16 values, 16-1=15, ldx #$0F
		db $1c, $28, $1e, $28, $0c, $28, $0c, $28, $0e, $28, $1c, $28, $1c, $28, $28, $28
	speedTable:
		db $33, $2F, $30, $31, $32, $33, $2F
; Early/Late Input
!hudearly = $7FA503
!hudlate = $7FA504
!success = $7FA508
!score = $7FA50A
!selectedSpeed = $7FA534


QuizDisplay:
	; score
	LDX #$10
 -	LDA str_score,X
	STA !RAM_BAR+!offsetScore,X
	DEX
	DEX
	BPL -
	;numbers
	;score
	lda !score
	jsr HexToDec
	sta !RAM_BAR+!offsetScore+$10
	txa : bne +
		lda $fc ; blank tile if 10s place is 0;
	+
	sta !RAM_BAR+!offsetScore+$0E
	; show correct/incorrect
	lda !showhud 
	beq +
		lda !success : beq ++
		; correct guess
		LDX #$0f
	-   LDA str_success,X
		STA !RAM_BAR+!offsetSuccess,X
		DEX
		BPL -
		RTS

		++
		; incorrect guess
		RTS

	+ 
	; show flight quiz game
	LDX #$0A
 -	LDA str_flight_s,X
	STA !RAM_BAR+!offsetFlight,X
	DEX
	DEX
	BPL -

	LDX #$0A
 -	LDA str_f_speed,X
	STA !RAM_BAR+!offsetSpeed,X
	DEX
	DEX
	BPL -

	LDX #$12
 -	LDA str_guess_a_or_b,X
	STA !RAM_BAR+!offsetGuessAorB,X
	DEX
	DEX
	BPL -

	LDX #$0A
 -	LDA str_change_guess,X
	STA !RAM_BAR+!offsetChangeGuess,X
	DEX
	DEX
	BPL -

	LDX #$0A
 -	LDA str_prev_next,X
	STA !RAM_BAR+!offsetPrevNextVals,X
	DEX
	DEX
	BPL -

	;numbers
	;score
	lda !score : sta !RAM_BAR
	jsr HexToDec
	sta !RAM_BAR+!offsetScore+$10
	txa : bne +
		lda $fc ; blank tile if 10s place is 0;
	+
	sta !RAM_BAR+!offsetScore+$0E

	; cycle through speed guessing display
	lda !selectedSpeed : cmp #$02 : beq +
	LDA !selectedSpeed : TAX
	INX ; Table starts at 51, because its to the left of 47 (and the table ends at 47 likewise)
	LDA speedTable,X
	JSR HexToDec
	STA !RAM_BAR+!offsetChangeGuess+6
	TXA
	STA !RAM_BAR+!offsetChangeGuess+4

	LDA !selectedSpeed : TAX
	INX
	INX
	LDA speedTable,X
	JSR HexToDec
	STA !RAM_BAR+!offsetPrevNextVals+$0A
	TXA
	STA !RAM_BAR+!offsetPrevNextVals+8

	LDA !selectedSpeed : TAX
	LDA speedTable,X
	JSR HexToDec
	STA !RAM_BAR+!offsetPrevNextVals+2
	TXA
	STA !RAM_BAR+!offsetPrevNextVals
	+
	RTS




