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

	.include "standard.inc"
	.include "system.inc"

	; CC65 hardware equates (because I prefer them).

	.include "pce.inc"
	.include "cd_labels.asm"

	.list
	.mlist
	.zp
	
string:
	.ds 2

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
				
	jsr     ex_dspon
	jsr     ex_rcron
	jsr     ex_irqon

	jsr     ex_vsync
	jsr     ex_vsync
	
	;load catgirl image and palette from CD
	stz <_cl ;sector number (bits 24-16)
	lda #HIGH(_ADDR_art) ;sector number (bits 15-8)
	sta <_ch
	lda #LOW(_ADDR_art) ;sector number (bits 7-0)
	sta <_dl
	lda #2 ;write to a bank
	sta <_dh
	lda #$81 ;write starting at bank $81
	sta <_bl
	lda #8 ;write 8 sectors
	sta <_al
	jsr cd_read
	
	;play track from CD
	lda #$80 ;play track number
	sta <_bh
	lda #2 ;track number to play
	sta <_al
	lda #$80 ;stop on track number
	sta <_dh
	lda #3 ;track number to stop on
	sta <_cl
	lda #1 ;infinite repeat play
	sta <_dh
	jsr cd_play

	;copy catgirl palette
	stw     #CatgirlPal,<_ax
	stw     #$0000,VCE_ADDR_LO
	jsr     copy_palette

	;clear tilemap
	vreg #VDC_MAWR
	stwz video_data
	vreg #VDC_VWR
	ldx #64 ;max tilemap size is 64x64
	ldy #64
.clr_loop:	
	stw #$200,video_data
	dex
	bne .clr_loop
	ldx #64
	dey
	bne .clr_loop
	;copy catgirl image
	vreg #VDC_MAWR
	stw #$2000,video_data
	vreg #VDC_VWR
	tia Catgirl,video_data,$2000
	;tilemap
	vreg #VDC_MAWR
	stw #8,video_data ;$0 is the tilemap address in vram
	vreg #VDC_VWR
	ldx #$10 ;image is 16x16 tiles
	ldy #$10
	stw #$200,<_si ;start of image in tiles
	stw #8,<_ax ;vram address to write to
.loop:
	stw <_si,video_data
	incw <_si
	dex
	bne .loop
	;32x32 tilemap
	addw #$20,<_ax
	vreg #VDC_MAWR
	stw <_ax,video_data
	vreg #VDC_VWR
	ldx #$10
	dey
	bne .loop
	
	;main loop
main:
	bra main
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
	.dw     VDC_MWR_32x32
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
	.dw     $007F
	.db     0
	
	.bank 1
	.org $6000
Catgirl:
	; .incchr "gfx\catgirl.pcx"
	
	.bank 2
	.org $8000
CatgirlPal:
	; .incpal "gfx\catgirl.pcx",0,1
