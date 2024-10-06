nmi:
    lda !pause_flag : asl : tax
    jmp (.menu_phase_pointers,x)

.menu_phase_pointers:
    dw normal
    dw init_menu
    dw draw_menu
    dw menu_upload
    dw window_opening
    dw menu_main
    dw window_closing
    dw menu_restore

normal:
init_menu:
window_opening:
window_closing:
menu_main:
    rtl

draw_menu:
    rep #$20
    lda $0D9D|!addr : sta $212C : sta $212E
    
    ldx #$80 : stx $2115
    lda.w #!menu_vram_addr : sta $2116
    lda $2139
    lda #$3981 : sta $4320
    lda.w #!vram_backup : sta $4322
    ldx.b #!vram_backup>>16 : stx $4324
    lda.w #!menu_gfx_size : sta $4325
    ldx #$04 : stx $420B

    sep #$20
    rtl

menu_upload:
    rep #$20
    ldx #$80 : stx $2115
    lda.w #!menu_vram_addr : sta $2116
    lda #$1801 : sta $4320
    lda.w #menu_gfx : sta $4322
    ldx.b #menu_gfx>>16 : stx $4324
    lda.w #!menu_gfx_size : sta $4325
    ldx #$04 : stx $420B
    sep #$20
    rtl

menu_restore:
    rep #$20
    lda $0D9D|!addr : sta $212C : sta $212E
    
    ldx #$80 : stx $2115
    lda.w #!menu_vram_addr : sta $2116
    lda #$1801 : sta $4320
    lda.w #!vram_backup : sta $4322
    ldx.b #!vram_backup>>16 : stx $4324
    lda.w #!menu_gfx_size : sta $4325
    ldx #$04 : stx $420B

    sep #$20
    rtl

menu_gfx:
    incbin !menu_gfx_name
