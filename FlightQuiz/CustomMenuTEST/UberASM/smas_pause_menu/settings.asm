; 16 + 704 bytes of free RAM (+ 32 if using !last_option = 3 or 4)
!freeram = $7FA700

; 1 = save&exit (exit the level)
; 2 = save&quit (quit to title screen)
; 3 = save&quit + save&exit
; 4 = save&quit + save&exit (only after beating the level)
!last_option = 3

; 0 = select doesn't exit the level (suggested if !last_option = 1)
; 1 = select works as normal (suggested if !last_option = 2)
!allow_start_select = 0

; SFX when moving the cursor
!cursor_sfx      = $06
!cursor_sfx_addr = $1DFC|!addr

; SFX when saving the game
!save_sfx      = $1E
!save_sfx_addr = $1DFC|!addr

; Palette row to use for the letters
; Palette 8 will make the cursor use the player's color
; (red-ish for Mario, green for Luigi, white for fire Mario/Luigi)
!menu_palette = $08

; X and Y position of the menu
!menu_x_pos = $40
!menu_y_pos = $40

; Where in the sprite GFX the menu will be uploaded (equals to address in LM-0x400)
; You shouldn't need to change this
!menu_starting_tile = $080
