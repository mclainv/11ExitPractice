!state = $7FA500
    ; 0 = nothing
    ; 1 = run right
    ; 2 = ducking
    ; 3 = done ducking
!showhud = $7FA501
!success = $7FA502   ; clip?

!duck = $7FA510 ; duck timer
!delay = $7FA511

!huddelay = $7FA512
!hudduck = $7FA513

calcforhud:
    lda !delay : sta !huddelay

    lda !duck : sta !hudduck

    lda #$01 : sta !showhud

    rtl

init:
    lda #$02 : sta $19
reset:
    lda #$00 : sta !state
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
        jmp reset
    +

    lda !state
    asl
    tax
    jmp (state_ptrs,x)

state0:     ; 0 = nothing
    lda $7E : cmp #$11 : bcs + ; if at the start of the level
        lda #$00
        sta !showhud
        sta !huddelay
        sta !hudduck
        sta !duck
        lda $15 : bit #$01 : beq + ; if holding right
            lda #$01
            sta !state
            sta !delay ; increase delay frames
    +
    jmp done

state1:     ; running right
    lda $15 : bit #$04 : beq + ; if you start holding down
        lda !duck : inc : sta !duck
        lda #$02 : sta !state
        jmp done
    +
;   lda $15 : bit #$01 : bne + ; if stopped holding right
;       jmp reset
;   +
    lda !delay : inc : sta !delay
    jmp done

state2:     ; ducking
    lda $15 : bit #04 : bne + ; released down
        lda #$03 : sta !state
        jmp done
    +
    lda !duck : inc : sta !duck
    jmp done

state3:
    jmp calcforhud
done:
	;if any of the timers are higher than they should be:
	lda !duck : cmp #$20 : bcc +	; cap at 10
	-
		jmp reset
	+
	lda !delay : cmp #$20 : bcs - 	; cap at 10

	rtl