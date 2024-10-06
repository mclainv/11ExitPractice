!state = $7FA500
    ; 0 = quiz_state0
    ; 1 = quiz_state1
    ; 2 = at x($D1)=#$0181
    ; 3 = done
; Global HUD Values
!showhud = $7FA501
!success = $7FA508
!score = $7FA509
; Shorthand addresses (controller, speed)
!curB = $0015 ; byetUDLR = B, Y, Select, Start
!newB = $0016
!newLR = $0018 ; axlr
!mxspd = $7B ; Mario Speed

;Flying input timer
!flying_height_timer = $7fA530
;Random value for location and speed
!random = $7FA531

; Menu
!dp1gamemode = $7FA532
!racedifficulty = $7FA533

; Quiz
!selectedSpeed = $7FA534
!checkGuessSum = $7FA535
;   0=47, 1=48, 2=49, 3=50, 4=51
!hudspeed = $7FA536

calcforhud:
    ;increase score
    lda !score : inc
    sta !score
    ;set score to 0 if lost
    lda !success : bne +
    lda #$00 : sta !score
    +
    ;save mario's speed
    lda !mxspeed : sta !hudspeed
    ;show the hud
    lda #$01 : sta !showhud
    lda #$00 : sta !state
    rtl
init:
    lda #$02 : sta $19
    lda #$01 : sta $7E1407
    stz $1408
    lda #$20 : sta !flying_height_timer
reset:
    lda #$00
    sta !state
    sta !showhud
    sta !success
init_speed: ; sets speed to speed_table,X=random val(between $00-$13)
    lda $0014
    EOR !random
    SEC : ADC $0013
    sta !random
    sta $4202 ; multiplicand
    lda #$14 : sta $4203 ; multiplier
    JSR Wait_Mult
    ldx $4217
    lda SPEED_TABLE,X : sta !mxspd  
    sep #$20
    rtl             

Wait_Mult: RTS

SPEED_TABLE:        db $32, $30, $33, $30, $33, $2F, $31, $32, $30, $2F, $2F, $31, $33, $31, $2F, $32, $30, $31, $32, $33 ; $13 Values

quiz_state_ptrs:
	dw quiz_state0, quiz_state1, quiz_state2, quiz_state3
main:
    lda $17         ; \ Check if L & R are pressed
    eor #$30        ; |
    bne +           ;/
        jsl $00F606     ; Kill the player
    +
    lda $71 : cmp #$09 : bne + ; if dying:
        jmp reset
    +
    jmp quiz_main

quiz_main:
    LDA #$40 ; 0100 0000
    TSB !curB

    LDA #$02
    TRB !curB

    lda !flying_height_timer : dec : sta !flying_height_timer
    BPL +
    lda #$3A : sta !flying_height_timer
    +
    lda !flying_height_timer
    cmp #$0A : BCS +
        LDA #$01
        TRB !curB
        LDA #$02
        TSB !curB
    +
    lda !state
    asl
    tax
    jmp (quiz_state_ptrs,x)

quiz_state0: ; guessing
    lda !newLR : bit #$20 : beq + ; bit sets z flag to 1 if L is pressed; branch if its 0
        lda !selectedSpeed : dec : bmi ++
        sta !selectedSpeed : bra +
        ++
        lda #$04 : sta !selectedSpeed
    +
    lda !newLR : bit #$10 : beq + ; pressed R
        lda !selectedSpeed : inc : sta !selectedSpeed
        lda !selectedSpeed : cmp #$05 : bcc ++
            lda #$00 : sta !selectedSpeed
        ++
    +
    lda !curB : bit #$80 : beq + ; pressed a/b
        lda #$01 : sta !state
    +
    jmp done
checkGuessSums: db $2F, $35, $3B, $41, $47
quiz_state1: ; checking guess
    ; (selectedSpeed, mxspd): (00, 2F) (05, 30) (0A, 31) (0F, 32) (14, 33) 
    ; = 2F, 35, 3B, 41, 47
    lda !mxspd 

    clc : adc !selectedSpeed ; \
    clc : adc !selectedSpeed ;  \
    clc : adc !selectedSpeed ;  | add (selectedSpeed*5)
    clc : adc !selectedSpeed ; /
    clc : adc !selectedSpeed ;|

    sta !checkGuessSum
    
    ldx #$04;
-   lda checkGuessSums,X
    cmp !checkGuessSum : beq +
    dex
    bpl -
    jmp calcforhud
    + ; correct
    lda #$01 : sta !success
    jmp calcforhud
; quiz_state2: ; incorrect guess
;     jmp calcforhud
; quiz_state3: ; correct guess
;     lda #$01 : sta !success
;     jmp calcforhud
done:
	rtl