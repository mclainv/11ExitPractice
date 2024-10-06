; Resets display vals
!showhud = $7F1934
!huddelay = $7F1935
!hudduck = $7F1936
main:
	lda #$00 : sta !showhud
	sta !huddelay
	sta !hudduck
	rtl
	