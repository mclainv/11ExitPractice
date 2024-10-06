; Resets display vals
!showhud = $7FA503
!hudearly = $7FA50C
!hudlate = $7FA50D
main:
	lda #$00 : sta !showhud
	sta !hudearly
	sta !hudlate
	rtl
	