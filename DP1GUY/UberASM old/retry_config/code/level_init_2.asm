; Gamemode 12

init:
    ; Check if we entered from the overworld.
    lda $141A|!addr : beq .return

.room_transition:
    ; If respawning from retry, skip.
    lda !ram_is_respawning : bne .return
    
    ; Check if we should count this entrance as a checkpoint.
    jsr shared_get_checkpoint_value
    cmp #$02 : bcc .return

..set_checkpoint:
    ; Set the checkpoint to the current entrance.
    lda !ram_door_dest : sta !ram_respawn
    lda !ram_door_dest+1 : sta !ram_respawn+1

    ; Update the checkpoint value.
    jsr shared_hard_save

    ; Call the custom checkpoint routine.
    php : phb : phk : plb
    jsr extra_room_checkpoint
    plb : plp

    ; Play the silent checkpoint SFX.
    lda.b #!room_cp_sfx : sta !room_cp_sfx_addr

    ; Save individual dcsave buffers.
if !dcsave
    jsr shared_dcsave_midpoint
endif

.return:
    rtl
