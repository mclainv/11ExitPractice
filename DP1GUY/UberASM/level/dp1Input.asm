!state = $7FA500
    ; 0 = still to the left
    ; 1 = within jumping distance
    ; 2 = at x($D1)=#$0181
    ; 3 = done
; Global HUD Values
!showhud = $7FA501
!success = $7FA502
!hudearly = $7FA503
!hudlate = $7FA504
; Global Frame counter & marker
!framecounter = $7FA505
!correctframe = $7FA506
; Global button timing
!earlypress = $7FA507
!latepress = $7FA508

calcforhud:
    lda !success : beq +

    +
    lda !latepress : beq +
        lda !latepress
        sec : sbc #$09
        sta !hudlate
    +
    lda !earlypress : beq +
        lda #$09
        sec : sbc !earlypress
        sta !hudearly
    +
    lda #$01 : sta !showhud
    rtl

init:
    lda #$00 : sta $19
    
reset:
    lda #$00 : sta !state
    sta !earlypress
    sta !latepress
	rtl

state_ptrs:
	dw state0, state1, state2, state3
main:
    lda $17             ;\ Check if L & R are pressed
    bit #$30            ;|
    beq +               ;/
    jsl $00F606         ; Kill the player
    +
    lda $71 : cmp #$09 : bne + ; if dying:
        lda !state : cmp #$02 : bne ++
            jmp calcforhud
        ++
        jmp reset
    +

    lda !state
    asl
    tax
    jmp (state_ptrs,x)
;Start at #$0166
;Correct frame #$0181

state0:     ; 0 = nothing
    lda $D1 : cmp #$A9 : bcc + ; if past start of level
        lda #$00
        sta !showhud
        sta !success
        sta !hudearly
        sta !hudlate
        ;sta !correctframe
        sta !framecounter
    +
    rep #$20 : lda $D1
    cmp #$016A : bcc + ; if in jumping distance
            sep #$20
            lda #$01
            sta !state
            sta !framecounter
    +
    sep #$20
    jmp done

state1:     ; waiting to jump
    lda !framecounter : inc : sta !framecounter
    rep #$20 : lda $D1
    cmp #$0184 : bcc + ;if at correct pixel
        sep #$20
        ;lda !framecounter : sta !correctframe
        lda #$02 : sta !state
        jmp done
    +
    sep #$20
    lda $16 : cmp #$80 : bne + ; if a pressed this frame:
        lda !framecounter : sta !earlypress
        jmp calcforhud
    +
    jmp done

state2:     ; check if mario is jumping, check for late frame
    ;check for feather
    ldx.b #!sprite_slots
    lda #$77 : sta $00 ; #$77 = feather, #00 is full sprite list
    %UberRoutine(FindSprite) ; cc if found, cs if NOT found
    BCS + ; branch if cs (not found)
        lda #$01 : sta !success
        lda #$03 : sta !state
        jmp done
    +
    lda !framecounter : inc : sta !framecounter
    lda $16 : cmp #$80 : bne + ; if a pressed this frame:
        lda !framecounter : sta !latepress
        jmp calcforhud
    +
    lda $71 : cmp #$09 : bne + ; if dying:
        jmp calcforhud
    +
    jmp done

state3:
    jmp calcforhud
done:
	rtl