!state = $7FA500
    ; 0 = still to the left
    ; 1 = within jumping distance
    ; 2 = at x($D1)=#$0181
    ; 3 = done
; Global HUD Values
!showhud = $7FA501
!success = $7FA508
!showmenu = $7FA509
; Flight Values
;Controller addresses
!curB = $0015
    ;   byetUDLR = B, Y, Select, Start, Up, Down, Left, Right
    ;   B = 10000000 #$80
    ;   Y = 01000000 #$40
    ;   Select = 00100000 #$20
    ;   Start = 00010000 #$10
    ;   Up = 00001000 #$08
    ;   Down = 00000100 #$04
    ;   Left = 00000010 #$02
    ;   Right = 00000001 #$01
!newB = $0016
    ;!curA = $0017
    ;   axlr----
    ;   A = 10000000 #$80
    ;   X = 01000000 #$40
    ;   L = 00100000 #$20
    ;   R = 00010000 #$10
;Initialize location and speed
!mxspd = $007B
!flying_height_timer = $7fA530
!random = $7FA531

; Menu
!dp1gamemode = $7FA532
!racedifficulty = $7FA533

; Quiz
!selSpeed = $7FA534

init:
    lda #$00 : sta !showmenu
    lda #$02 : sta $19
    lda #$01 : sta $7E1407
    stz $1408
    lda #$20 : sta !flying_height_timer
reset:
    lda #$00 : sta !state
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

state_ptrs:
	dw state0, state1, state2, state3
main:
    lda $17         ; \ Check if L & R are pressed
    eor #$30        ; |
    bne +           ;/
        jsl $00F606     ; Kill the player
    +
    lda $71 : cmp #$09 : bne + ; if dying:
        jmp reset
    +
    lda !showmenu : bne + ; if showmenu is 0, check select
        lda !curB : and #$20 : beq + ; \
            lda #$01                 ;  \ if select, display menu
            sta !showmenu            ;  |
            jmp menu                 ; /
    +
    lda !curB : and #$20 : beq +
        lda #$00 : sta !showmenu
    +
    lda !state
    asl
    tax
    jmp (state_ptrs,x)

menu:
    lda !state
    asl
    tax
    jmp (state_ptrs,x)
state0:
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
    jmp done
state1:
    jmp done
state2:
    jmp done
state3:
    jmp done
done:
	rtl