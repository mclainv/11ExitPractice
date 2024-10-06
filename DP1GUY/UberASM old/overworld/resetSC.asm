; Resets display vals
		; Global HUD values
!showhud = $7FA501
!hudearly = $7FA502
!hudlate = $7FA503
 		; Global Frame counter & marker
!framecounter = $7FA504
!correctframe = $7FA505
		; Global button timing
!earlypress = $7FA506
!latepress = $7FA507
		; Global Success Flag
!success = $7FA508
main:
	lda #$00 : sta !showhud
	sta !showhud
	sta !hudearly
	sta !hudlate
	sta !framecounter
	sta !correctframe
	sta !earlypress
	sta !latepress
	sta !success
	rtl
	