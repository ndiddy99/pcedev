; main.asm: Entry point for the game.
; Copyright (C) 2020 Nathan Misner

; This program is free software; you can redistribute it and/or
; modify it under the terms of version 2 of the GNU General Public
; License as published by the Free Software Foundation.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program; if not, see
; <https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>


;
; PCEAS sets up the following values in the IPL ...
;
; Program load address : $4000
; Program exec address : $4070
; MPR2 (Bank @ $4000)  : $80
; MPR3 (Bank @ $6000)  : $81
; MPR4 (Bank @ $8000)  : $82
; MPR5 (Bank @ $A000)  : $83
; MPR6 (Bank @ $C000)  : $80
;
; CD ram banks: $80-$87
; SCD ram banks: $68-$7F

	; PCEAS equates.
	.include "includes.inc"

	; CC65 hardware equates (because I prefer them).
	.include "pce.inc"
	
	; Variables
	.include "variables.asm"
	
	; CD routines & macros
	.include "cd.asm"
	
	; Scroll routines
	.include "scroll.asm"
	
	; Player routines
	.include "player.asm"

	;asset location on cd-rom
	.include "cd_labels.asm"

	;-----asset load pointers-----
tile_load equ $8000
pal_load equ $a000 ;palette is 32 bytes
heights_load equ $a020 ;height array indices
map_load equ $a060

	;-----misc constants-----
satb_vram equ $1000 ;where satb is in vram

	.list
	.mlist
	.data

	.code
	.bank   0
	.org    $4070

;
;
;
boot:
	jsr     ex_dspoff
	jsr     ex_rcroff
	jsr     ex_irqoff
	jsr     ad_reset

	jsr     init_vce

	stw     #boot_video_mode,_ax
	jsr     init_vdc
	
	;set up vsync handler
	stw #my_vsync,sync_jmp
	lda #%00110000
	sta irq_m
	jsr ex_dspon
	jsr ex_rcron
	jsr ex_irqon
	jsr ex_vsync
	jsr ex_vsync
	
	;initialize zero-page variables
	stz start_vars
	tii start_vars,start_vars+1,(end_vars-start_vars)
	
	;load sprites
	cd_load _ADDR_spritegfx,#$68,#_SECSIZE_spritegfx
	;load level gfx & map
	cd_load _ADDR_level1,#$82,#_SECSIZE_level1
	
	;play cdda
	; lda #2 ;track 2
	; jsr cd_track
	
	;copy bg palette
	stw     #pal_load,<_ax
	stw     #$0000,VCE_ADDR_LO
	jsr     copy_palette
	
	;copy bg tiles
	vreg #VDC_MAWR
	stw #$2000,video_data
	vreg #VDC_VWR
	tia tile_load,video_data,$2000
	; ;copy bg data
	stw #map_load,<_si
	jsr scroll_fill
	
	;copy sprite palette
	lda #$68
	tam #4
	stw #$8000,<_ax
	stw #$0100,VCE_ADDR_LO ;sprite palette 0
	jsr copy_palette
	
	;copy sprite tiles
	vreg #VDC_MAWR
	stw #$3000,video_data
	vreg #VDC_VWR
	tia $8020,video_data,$400
	lda #$82
	tam #4
	
	;zero out SATB
	stz satb
	tii satb,satb+1,511
	
	jsr player_init
	
	;init scroll
	stwz <scroll_x
	stwz <scroll_y
	
	;main loop
main:
	; ;d-pad up
	; bbr4 <joypad,.no_up
	; decw <scroll_y
; .no_up:
	; ;d-pad right
	; bbr5 <joypad,.no_right
	; incw <scroll_x
; .no_right:
	; ;d-pad down
	; bbr6 <joypad,.no_down
	; incw <scroll_y
; .no_down:
	; ;d-pad left
	; bbr7 <joypad,.no_left
	; decw <scroll_x
; .no_left:

	jsr player_iterate
	
	lda #1
	sta <status
end_loop:
;loop until vsync function sets status to 0
	lda <status
	bne end_loop
	jmp main
	
my_vsync:	
	incw <frame
	stz <status

	;set scroll pos
	vreg #VDC_BXR
	lda <scroll_x
	stw <scroll_x,video_data
	vreg #VDC_BYR
	stw <scroll_y,video_data
	
	;copy SATB mirror
	vreg #VDC_MAWR
	stw #satb_vram,video_data
	vreg #VDC_VWR
	tia satb,video_data,512
	
	lda #1 ;read joypad 1
	jsr ex_joysns
	lda joy
	sta <joypad
	lda joytrg
	sta <joyedge
	rts
	
; ***************************************************************************
; ***************************************************************************
;
;


init_vdc:
	php
	sei
	cly
.loop:
	lda     [_ax],y
	beq     .done
	sta     VDC_CTRL
	iny
	lda     [_ax],y
	sta     VDC_DATA_LO
	iny
	lda     [_ax],y
	sta     VDC_DATA_HI
	iny
	bra     .loop
.done:
	plp
	rts


; ***************************************************************************
; ***************************************************************************
;
;

init_vce:
	php
	sei
	stz     VCE_ADDR_LO
	stz     VCE_ADDR_HI
	ldy     #$02
	clx
.loop:
	stz     VCE_DATA_LO
	stz     VCE_DATA_HI
	dex
	bne     .loop
	dey
	bne     .loop
	lda     #VCE_CR_5MHz
	sta     VCE_CTRL
	plp
	rts


; ***************************************************************************
; ***************************************************************************
;
;

copy_palette:   
	cly
.loop:
	lda     [_ax],y
	iny
	sta     VCE_DATA_LO
	lda     [_ax],y
	iny
	sta     VCE_DATA_HI
	cpy     #32
	bne     .loop
	rts


; ***************************************************************************
; ***************************************************************************

; VDC constants for 240 & 256 wide display.

VCE_CR_5MHz  = $00

VDC_HSR_240  = $0302
VDC_HDR_240  = $041D

VDC_HSR_256  = $0202
VDC_HDR_256  = $041F

; VDC constants for 320 & 336 wide display.

VCE_CR_7MHz  = $01

VDC_HSR_320  = $0502
VDC_HDR_320  = $0427

VDC_HSR_336  = $0402
VDC_HDR_336  = $0429

; VDC constants for 480 & 512 wide display.

VCE_CR_10MHz = $02

VDC_HSR_480  = $0C02
VDC_HDR_480  = $043C

VDC_HSR_512  = $0B02
VDC_HDR_512  = $043F

; VDC constants for 200, 224 & 240 high display.

VDC_VPR_200  = $2302
VDC_VDW_200  = $00C7
VDC_VCR_200  = $0018

VDC_VPR_224  = $1702
VDC_VDW_224  = $00DF
VDC_VCR_224  = $000C

VDC_VPR_240  = $0F02
VDC_VDW_240  = $00EF
VDC_VCR_240  = $0004 ; $00F6

; VDC constants for different BAT screen sizes.

VDC_MWR_32x32  = $0000
VDC_MWR_32x64  = $0040

VDC_MWR_64x32  = $0010
VDC_MWR_64x64  = $0050

VDC_MWR_128x32 = $0020
VDC_MWR_128x64 = $0060

; Table of VDC values to set on boot.

boot_video_mode:
	.db     VDC_CR                  ; Control Register
	.dw     $0000
	.db     VDC_RCR                 ; Raster Counter Register
	.dw     $0000
	.db     VDC_BXR                 ; Background X-Scroll Register
	.dw     $0000
	.db     VDC_BYR                 ; Background Y-Scroll Register
	.dw     $0000
	.db     VDC_MWR                 ; Memory-access Width Register
	.dw     VDC_MWR_64x64
	.db     VDC_HSR                 ; Horizontal Sync Register
	.dw     VDC_HSR_256
	.db     VDC_HDR                 ; Horizontal Display Register
	.dw     VDC_HDR_256
	.db     VDC_VPR                 ; Vertical Sync Register
	.dw     VDC_VPR_224
	.db     VDC_VDW                 ; Vertical Display Register
	.dw     VDC_VDW_224
	.db     VDC_VCR                 ; Vertical Display END position Register
	.dw     VDC_VCR_224
	.db     VDC_DCR                 ; DMA Control Register
	.dw     $0010
	.db     VDC_SATB                ; SATB  address of the SATB
	.dw     satb_vram
	.db     0

;block height arrays
	.include "blocks.asm"
	
