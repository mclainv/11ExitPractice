; RAM defines
!controller_byetUDLR #= $16
!controller_axlr     #= $18
!game_mode           #= $0100|!addr
!intro_flag          #= $0109|!addr
!oam_x_pos           #= $0200|!addr
!oam_y_pos           #= $0201|!addr
!oam_tile            #= $0202|!addr
!oam_props           #= $0203|!addr
!oam_size_compressed #= $0400|!addr
!oam_size            #= $0420|!addr
!window_table        #= $04A0|!addr
!hdma_enable         #= $0D9F|!addr
!current_level       #= $13BF|!addr
!pause_delay_addr    #= $13D3|!addr
!pause_flag          #= $13D4|!addr
!cursor_frame        #= $1B91|!addr
!cursor_position     #= $1B92|!addr
!saved_data          #= $1EA2|!addr
!sram_buffer         #= $1F49|!addr

; Routine defines
!bank0_rtl    #= $0084CF|!bank
!save_game    #= $009BC9|!bank
!exit_select  #= $00A269|!bank
!clear_oam    #= $7F8000

; Other defines
!sram_buffer_size #= 141
!pause_sfx        #= read1($00A23E)
!unpause_sfx      #= read1($00A232)
!pause_sfx_addr   #= read2($00A240)
!pause_delay      #= read1($00A22D)

; Free RAM defines
!window_param #= !freeram+0  ; 10 bytes
!backup_3E    #= !freeram+10 ; 1 byte
!backup_41    #= !freeram+11 ; 1 byte
!backup_42    #= !freeram+12 ; 1 byte
!backup_43    #= !freeram+13 ; 1 byte
!backup_0D9D  #= !freeram+14 ; 1 byte
!backup_0D9E  #= !freeram+15 ; 1 byte
!vram_backup  #= !freeram+16 ; 704 bytes

; Check which channel is used for windowing HDMA, for SA-1 v1.35 (H)DMA remap compatibility
; It will be 7 on lorom or with SA-1 <1.35, and 1 with SA-1 >=1.35
!window_mask    #= read1($0092A1)
!window_channel #= log2(!window_mask)

; Menu stuff
function x(off) = (!menu_x_pos+(off))
function y(off) = (!menu_y_pos+(off))
function t(off) = (!menu_starting_tile+(off))

if !last_option == 1
    !menu_gfx_name = "gfx/letters_exit.bin"
elseif !last_option == 2
    !menu_gfx_name = "gfx/letters_quit.bin"
else
    !menu_gfx_name = "gfx/letters_quit+exit.bin"
endif

!menu_gfx_size  #= filesize("!menu_gfx_name")

!menu_vram_addr #= $6000+($10*(!menu_starting_tile))

!menu_props   #= $30|((!menu_palette-8)*2)|((!menu_starting_tile&$100)>>8)
!menu_oam     #= $00
!menu_bg_tile #= t($00)

if !last_option < 3
    !menu_options_count #= 3
else
    !menu_options_count #= 4
endif

;================================================
; Macro to push the current code's DB to the stack and set the DBR to label's bank.
; Note: remember to PLB when finished!
;================================================
macro set_dbr(label)
?-  pea.w (<label>>>16)|((?-)>>16<<8)
    plb
endmacro

;================================================
; Macro to JSL to a routine that ends in RTS.
;================================================
macro jsl_to_rts(routine, rtl)
    phk : pea.w (?+)-1 : pea.w <rtl>-1
    jml <routine>|!bank
?+
endmacro

;================================================
; Macro to JSL to a routine that ends in RTS.
; Also sets up the DBR to the routine's bank.
;================================================
macro jsl_to_rts_db(routine, rtl)
    %set_dbr(<routine>)
    %jsl_to_rts(<routine>,<rtl>)
    plb
endmacro
