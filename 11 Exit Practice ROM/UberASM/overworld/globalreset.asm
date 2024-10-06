; Resets display vals
!state = $7FA500
!showhud = $7FA501
main:
	lda #$00
	sta !showhud
	sta !state
	rtl