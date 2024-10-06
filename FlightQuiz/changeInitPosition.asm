!random = $7FA541
!xlo = $7FA543
!level    = $015    ; Level number that has dynamic init positions
if read1($00FFD5) == $23
    sa1rom
    !bank = $000000
else
    lorom
    !bank = $800000
endif
org read3($05DA18)

    autoclean JML Dynamic_Init_Pos

freecode

Dynamic_Init_Pos:

    REP #$20
    LDA $010B
    CMP.w #!level
    BNE .Return
    SEP #$20

                                ;  \ This is to get a random number from $200-$F93.
    lda #$93 : sta $211B        ;  | First store $D93 to 16 bit register. Write $93 then $0D.
	lda #$0D : sta $211B        ; / Then, store !random. Get high 16 bytes of product, add 200.
    lda !random
    bpl +
    lda #$93 : asl : sta $211b
    lda #$0D : rol : sta $211b
    lda !random : lsr : sta $211c
    bra ++
  +
    lda #$93 : sta $211b
    lda #$0D : sta $211b
    lda !random : sta $211c
  ++
    JSR Wait_Mult
    REP #$20
    lda $2135 : clc : adc #$0200
    sta $94
    sep #$20
.Return

    SEP #$30
    LDA $5B
    JML read3($05DA18)+4
Wait_Mult: RTS