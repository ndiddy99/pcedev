; cd.asm: CD helper functions.
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

;usage: cd_load [cd sector number] [bank to write to] [number of 2kb sectors to write]
cd_load .macro
	stz <_cl ;sector number (bits 24-16)
	lda #HIGH(\1) ;sector number (bits 15-8)
	sta <_ch
	lda #LOW(\1) ;sector number (bits 7-0)
	sta <_dl
	lda #2 ;write to a bank
	sta <_dh
	lda \2 ;write starting at bank n
	sta <_bl
	lda \3 ;write n sectors
	sta <_al
	jsr cd_saferead
.endm

;-----cd functions-----

	.bank 1
	.org $6000

NUM_RETRIES equ 5

;retry reading the disc NUM_RETRIES times
cd_saferead:
	sei ;disable interrupts to stop them messing the cd loading up
	stz <_ah
.cd_loop:
	jsr cd_read
	; cmp #0
	beq .end ;if A isn't 0, it means there's been a read error
	lda <_ah
	inc a
	sta <_ah
	cmp #NUM_RETRIES
	bne .cd_loop
	cli ;enable interupts
	jsr cd_boot ;go to system card screen if loading screws up
.end:
	cli ;enable interupts
	rts

;plays cd track.
;A: track number
cd_track:
	ldx #$80 ;play track number
	stx <_bh
	sta <_al ;track number to play
	stz <_ah
	stz <_bl
	ldx #($80 | 1) ;stop on track, infinite repeat play
	stx <_dh
	inc a
	sta <_cl ;track number to stop on
	stz <_ch
	stz <_dl
	jmp cd_play ;rts from cd_play returns to where cd_track was called
	
cd_end:

	