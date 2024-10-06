main:
    lda !pause_flag : asl : tax
    jsr (.menu_phase_pointers,x)

    ldy !pause_flag : beq .return
if !allow_start_select
    lda #$00
    cpy #$05 : bne ++
    lda !controller_byetUDLR-1 : and #$20
++  sta !controller_byetUDLR-1
else
    stz !controller_byetUDLR-1
endif
    stz !controller_byetUDLR
    stz !controller_axlr-1
    stz !controller_axlr
.return:
    rtl

.menu_phase_pointers:
    dw normal
    dw init_menu
    dw draw_menu
    dw menu_upload
    dw window_opening
    dw menu_main
    dw window_closing
    dw menu_restore

init_menu:
    inc !pause_flag
    stz !cursor_frame
    stz !cursor_position

    rep #$30
    lda #$0010 : sta !window_param+0
    lda #$0064 : sta !window_param+2
    lda #$00A4 : sta !window_param+4
    lda #$00C4 : sta !window_param+6
if !last_option < 3
    lda #$00D0 : sta !window_param+8
elseif !last_option == 3
    lda #$00E8 : sta !window_param+8
else
    sep #$10
    lda #$00D0
    ldy !current_level
    ldx !saved_data,y : bpl +
    lda #$00E8
+   rep #$10
    sta !window_param+8
endif
    jsr reset_window
    sep #$30

    lda $3E : sta !backup_3E
    and #$F7 : sta $3E
    lda $41 : sta !backup_41
    stz $41
    lda $42 : sta !backup_42
    stz $42
    lda $43 : sta !backup_43
    ora #$03 : sta $43
    lda $0D9D|!addr : sta !backup_0D9D
    ora #$10 : sta $0D9D|!addr
    lda $0D9E|!addr : sta !backup_0D9E
    and #$EF : sta $0D9E|!addr
    lda.b #!window_mask : tsb !hdma_enable
normal:
    rts

draw_menu:
    jsl !clear_oam

    phb : phk : plb

.draw_letters:
    ldx.b #!menu_oam
    ldy.b #.letters_y_pos-.letters_x_pos-1
..loop:
    lda.w .letters_x_pos,y : sta !oam_x_pos,x
    lda.w .letters_y_pos,y : sta !oam_y_pos,x
    lda.w .letters_tile,y : sta !oam_tile,x
    lda.b #!menu_props : sta !oam_props,x
    phx
    txa : lsr #2 : tax
    stz !oam_size,x
    ; $0400 isn't updated when the game is paused
    ; Calling $008494 to update it causes issues with MaxTile (cursor doesn't work properly)
    ; Copying the routine here is slow and boring
    ; So just STZ everything brainlessly since we don't care about other sprites
    txa : lsr #2 : tax
    stz !oam_size_compressed,x
    plx
    inx #4
if !last_option == 4
    cpx.b #!menu_oam+4 : bne +
    phx
    ldx !current_level
    lda !saved_data,x
    plx
    cmp #$80 : bcs +
    ldy.b #.letters_x_pos_extra-.letters_x_pos-1
    bra ..loop
+
endif
    dey : bpl ..loop

.draw_background:
    stz $00
    stz $01
    ldx.b #!menu_oam
..loop:
    ldy $00 : lda.w .background_x_pos,y : sta !oam_x_pos+$100,x
    ldy $01 : lda.w .background_y_pos,y : sta !oam_y_pos+$100,x
    lda.b #!menu_bg_tile : sta !oam_tile+$100,x
    lda.b #!menu_props : sta !oam_props+$100,x
    phx
    txa : lsr #2 : tax
    lda #$02 : sta !oam_size+$40,x
    ; Same reasoning as before
    txa : lsr #2 : tax
    lda #$AA : sta !oam_size_compressed+$10,x
    plx
    inx #4
    inc $00
    lda $00 : cmp.b #.background_y_pos-.background_x_pos : bne ..loop
    stz $00
    inc $01
    lda $01 : cmp.b #.background_end-.background_y_pos : bne ..loop

    plb

    inc !pause_flag
    rts

.letters:
..x_pos:
    ; CONTINUE
    db x($14),x($1C),x($24),x($2C),x($34),x($3C),x($44),x($4C)
    ; SAVE&CONTINUE
    db x($14),x($1C),x($24),x($2C),x($34),x($3C),x($44),x($4C),x($54),x($5C),x($64),x($6C),x($74)
    ; SAVE&QUIT
    db x($14),x($1C),x($24),x($2C),x($34),x($3C),x($44),x($4C),x($54)
if !last_option > 2
...extra:
    ; SAVE&EXIT
    db x($14),x($1C),x($24),x($2C),x($34),x($3C),x($44),x($4C),x($54)
endif
    ; Cursor
    db x($0C)
..y_pos:
    ; CONTINUE
    db y($10),y($10),y($10),y($10),y($10),y($10),y($10),y($10)
    ; SAVE&CONTINUE
    db y($20),y($20),y($20),y($20),y($20),y($20),y($20),y($20),y($20),y($20),y($20),y($20),y($20)
    ; SAVE&QUIT
    db y($30),y($30),y($30),y($30),y($30),y($30),y($30),y($30),y($30)
if !last_option > 2
    ; SAVE&EXIT
    db y($40),y($40),y($40),y($40),y($40),y($40),y($40),y($40),y($40)
endif
    ; Cursor
    db y($10)
..tile:
    ; CONTINUE
    db t($03),t($04),t($05),t($06),t($07),t($08),t($09),t($0A)
    ; SAVE&CONTINUE
    db t($12),t($13),t($14),t($15),t($0B),t($03),t($04),t($05),t($06),t($07),t($08),t($09),t($0A)
    ; SAVE&QUIT
    db t($12),t($13),t($14),t($15),t($0B),t($0C),t($0D),t($0E),t($0F)
if !last_option > 2
    ; SAVE&EXIT
    db t($12),t($13),t($14),t($15),t($0B),t($15),t($16),t($0E),t($0F)
endif
    ; Cursor
    db t($02)

.background:
..x_pos:
    db x($00),x($10),x($20),x($30),x($40),x($50),x($60),x($70)
..y_pos:
    db y($00),y($10),y($20),y($30),y($40)
if !last_option > 2
    db y($50)
endif
..end:

menu_upload:
    inc !pause_flag
    rts

window_opening:
    lda !window_param+0 : beq .finished : bmi .finished
    rep #$30
    lda !window_param+2 : dec #2 : sta !window_param+2
    lda !window_param+4 : inc #2 : sta !window_param+4
    lda !window_param+6 : dec #4 : sta !window_param+6
    lda !window_param+8 : inc #4 : sta !window_param+8
    jsr set_window
    sep #$30
    rts
.finished:
    inc !pause_flag
    rts

menu_main:
    lda !controller_byetUDLR
    bit #$04 : bne .down
    bit #$08 : beq .skip
.up:
    lda !cursor_position : dec
    bpl +
    lda.b #!menu_options_count-1
if !last_option == 4
    ldy !current_level
    ldx !saved_data,y : bmi +
    dec
endif
    bra +
.down:
    lda !cursor_position : inc
if !last_option == 4
    ldy !current_level
    ldx !saved_data,y : bmi ++
    cmp.b #!menu_options_count-1 : bne +
    lda #$00
    bra +
++
endif
    cmp.b #!menu_options_count : bne +
    lda #$00
+   sta !cursor_position
    stz !cursor_frame
    lda.b #!cursor_sfx : sta !cursor_sfx_addr
.skip:

    ldx !cursor_position
    lda !cursor_frame : and #$10 : beq +
    ldx.b #!menu_options_count
+   lda.l .cursor_y_pos,x
    sta !oam_y_pos+!menu_oam

    inc !cursor_frame
    
    lda !controller_byetUDLR : ora !controller_axlr
    bit #$90 : beq .return
    lda #$10 : sta !window_param+0
    stz !cursor_frame
    lda !cursor_position : asl : tax
    jmp (.menu_action_pointers,x)

.cursor_y_pos:
    db y($10),y($20),y($30)
if !last_option > 2
    db y($40)
endif
    db $F0

.menu_action_pointers:
    dw .continue
    dw .save_and_continue
if !last_option == 1
    dw .save_and_exit
elseif !last_option == 2
    dw .save_and_quit
else
    dw .save_and_quit
    dw .save_and_exit
endif

.save_and_continue:
    lda.b #!save_sfx : sta !save_sfx_addr
    jsr save_game
.continue:
    inc !pause_flag
    lda.b #!unpause_sfx : sta !pause_sfx_addr
    rts
.save_and_quit:
    jsr .save_and_exit
    lda #$02 : sta !game_mode
    rts
.save_and_exit:
    lda.b #!save_sfx : sta !save_sfx_addr
    jsr save_game
    %jsl_to_rts_db(!exit_select,!bank0_rtl)
.return:
    rts

window_closing:
    lda !window_param+0 : beq .finished : bmi .finished
    rep #$30
    lda !window_param+2 : inc #2 : sta !window_param+2
    lda !window_param+4 : dec #2 : sta !window_param+4
    lda !window_param+6 : inc #4 : sta !window_param+6
    lda !window_param+8 : dec #4 : sta !window_param+8
    jsr set_window
    sep #$30
    rts
.finished:
    inc !pause_flag
    jsl !clear_oam

    rep #$30
    jsr reset_window
    sep #$30

    lda !backup_3E : sta $3E
    lda !backup_41 : sta $41
    lda !backup_42 : sta $42
    lda !backup_43 : sta $43
    lda !backup_0D9D : sta $0D9D|!addr
    lda !backup_0D9E : sta $0D9E|!addr
    lda.b #!window_mask : trb !hdma_enable
    rts

menu_restore:
    stz !pause_flag
    lda.b #!pause_delay : sta !pause_delay_addr
    rts

set_window:
    lda !window_param+0 : dec #1 : sta !window_param+0
    jsr reset_window
    lda !window_param+6 : tax
    lda !window_param+8 : sta $00
    lda !window_param+4 : xba : ora !window_param+2
-   sta.w !window_table,x
    inx #2
    cpx $00 : bne -
    rts

reset_window:
    ldx #$006E
    lda #$00FF
-   sta.w !window_table+$000,x
    sta.w !window_table+$070,x
    sta.w !window_table+$0E0,x
    sta.w !window_table+$150,x
    dex #2
    bpl -
    rts

save_game:
    lda !intro_flag : bne .return
    phx
    phy
    %move_block(!saved_data|!bank,!sram_buffer|!bank,!sram_buffer_size)
    jsl !save_game
    ply
    plx
.return:
    rts
