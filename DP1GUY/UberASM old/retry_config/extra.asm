;=====================================
; All these routines are called in 8-bit A/X/Y mode and DBR is already set.
; Don't worry about overwriting registers, they'll be restored afterwards.
; All the routines must end with rts.
;=====================================

;=====================================
; This routine will be called when loading the title screen.
; It can be used to reset particular RAM addresses for a new save file (see "docs/sram_info.txt").
; NOTE: on SA-1 roms, this runs on the SNES cpu.
;=====================================
load_title:
    ; Feel free to put your code here.



    rts

;=====================================
; This routine will be called when the level is reset by the retry system or when entering from the overworld.
; Unlike UberASM level init routine, this won't be executed during regular level transitions.
; NOTE: on SA-1 roms, this runs on the SNES cpu.
;=====================================
reset:
    ; Feel free to put your code here.



    rts

;=====================================
; This routine will be executed everytime the player dies.
;=====================================
death:
    ; Feel free to put your code here.



    ; Code to reset some stuff related to lx5's Custom Powerups.
    ; You shouldn't need to edit this.
if !custom_powerups == 1
    stz.w ($170B|!addr)+$08
    stz.w ($170B|!addr)+$09
    lda #$00 : sta !projectile_do_dma

    ldx #$07
-   lda $170B|!addr,x : cmp #$12 : bne +
    stz $170B|!addr,x
+   dex : bpl -
    
    lda !item_box_disable : ora #$02 : sta !item_box_disable
endif

    rts

;=====================================
; This routine will be called every time the player touches a midway (vanilla or custom midway object).
; NOTE: on SA-1 roms, this runs on the SA-1 cpu.
;=====================================
midway:
    ; Feel free to put your code here.



    rts

;=====================================
; This routine will be called every time the player gets a checkpoint through a room transition.
; Remember you can check for $13BF and $010B to know in which trans/sub-level you are.
; NOTE: on SA-1 roms, this runs on the SNES cpu.
;=====================================
room_checkpoint:
    ; Feel free to put your code here.



    rts

;=====================================
; This routine will be called every time the player selects "exit" on the retry prompt.
; NOTE: on SA-1 roms, this runs on the SNES cpu.
;=====================================
prompt_exit:
    ; Feel free to put your code here.



    rts

;=====================================
; This routine will be called every time the game is saved (before anything gets saved).
; Remember you can check for the current save file in $010A.
;=====================================
save_file:
    ; Feel free to put your code here.



    rts

;=====================================
; This routine will be called every time an existing save file is loaded (before anything gets loaded).
; Remember you can check for the current save file in $010A.
;=====================================
load_file:
    ; Feel free to put your code here.



    rts

;=====================================
; This routine will be called every time a new save file is loaded (before anything gets reset).
; Remember you can check for the current save file in $010A.
;=====================================
load_new_file:
    ; Feel free to put your code here.


    
    rts

;=====================================
; This routine will be called at the end of the game loop during gamemode 14,
; just before retry draws the prompt and AddmusicK's code runs.
; If you have other patches that hijack $00A2EA, you could try to put their freespace code in this routine to solve the conflict.
;=====================================
gm14_end:
    ; Feel free to put your code here.



    rts
