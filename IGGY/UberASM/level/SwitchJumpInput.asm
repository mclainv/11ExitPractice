!state = $7FA500
    ; 0 = nothing
    ; 1 = y cord low enough
    ; 2 = p switch pressed
!switch_x = $7FA501
!switch_y = $7FA502

!showhud = $7FA503
; Handle jump timing
!framecounter = $7FA504
!earlypress = $7FA505
!latepress = $7FA506
!correctframe = $7FA507
!height_diff = $7FA508
!offset = $7FA509
!success = $7FA50A
; HUD values
!hudoffset = $7FA50B
!hudearly = $7FA50C
!hudlate = $7FA50D

calcforhud:
    lda !success : beq +

    +
    lda !latepress : beq +
        lda !latepress
        sec : sbc !correctframe
        sta !hudlate
    +
    lda !earlypress : beq +
        lda !correctframe
        sec : sbc !earlypress
        sta !hudearly
    +
    lda #$01 : sta !showhud
    rtl
init:
reset:
    lda #$00 : sta !state
    sta !offset
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
    ; show hud
    ; init p switch location
    ldx.b #!sprite_slots
    lda #$3E : sta $00 ; look for sprite number $3E
    %UberRoutine(FindSprite) ; now x is p switch sprite slot
    ; set value if found
;   lda #$02 : sta $7F2039
;   bcc +
;       lda #$03 : sta $7F2039 ; sets if sprite is not found
;   +
    ; store p switch coords
    lda $E4,X
    sta $5C
    sta !switch_x
    
    lda $D8,X
    ;sta $58
    sta !switch_y
    
    lda !offset
    sta $79

    lda $AA,X ;p switch speed
    sta $7C
    
    lda !state
    asl
    tax
    jmp (state_ptrs,x)

state0:     ; 0 = nothing -> holding something -> move on if low enough
    lda $148F : beq + ; holding something hides display
        lda #$00
        sta !showhud
        sta !framecounter
        sta !earlypress
        sta !latepress
        sta !hudearly
        sta !hudlate
    +
        rep #$20 : lda $00D1 ;16 bit mario level x cord
        cmp #$03B5 : bcc + ; below y cord ; COMPARE 2 bytes, $0360
        sep #$20 : lda $d3
        cmp #$5A : bcc +
            lda #$01 : sta !state
    +
    sep #$20
    jmp done

state1:     ; until p switch is hit, inc frame counter, when a is pressed store frame in earlypress
    lda !framecounter : inc : sta !framecounter
    lda $14AD : cmp #$B0 : bne +
        lda !framecounter : sta !correctframe
        lda #$02 : sta !state
        jmp done
    +
    lda $18 : cmp #$80 : bne + ; if a pressed this frame:
        lda !framecounter : sta !earlypress
    +
;
    ; check horizontal offset between mario and switch
    ;        lda !switch_x : sec : sbc #$C
    ;        pha ; $02,s = px - 12
    ;        lda !switch_x : clc : adc #$D
    ;        pha ; $01,s = px + 13
    ;        lda $d1 ; load mario x
    ;        cmp $01,s : bcs + ; mario is past switch
    ;        cmp $02,s : bcc ++ ; mario is left of switch
    ;        bra +++
    ;
    ;        + ; overshot
    ;        lda $d1 : sec : sbc $02,s
    ;        sta !offset
    ;        bra +++
    ;        ++ ; undershot
    ;        lda $02,s
    ;        sec : sbc $d1
    ;        sta !offset
    ;
    ;        +++
    ;        pla
    ;        pla
        ; inc frame counter
    jmp done

state2:     ; check if mario is jumping, check for late frame
    lda $72 : cmp #$0B : bne +
        lda #$01 : sta !success
        lda #$03 : sta !state
        jmp done
    +
    lda $71 : cmp #$09 : bne + ; if dying:
        jmp calcforhud
    +
    lda !framecounter : inc : sta !framecounter
    lda $18 : cmp #$80 : bne + ; if a pressed this frame:
        lda !framecounter : sta !latepress
        jmp calcforhud
    +
    jmp done

state3:
    jmp calcforhud
done:
	;if any of the timers are higher than they should be:

	rtl