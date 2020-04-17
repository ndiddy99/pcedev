; scroll.asm: Scrolling display helper functions.
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
	.list
	.mlist
	.bank 1
	.code

NUM_ROWS equ 14 ;14 rows (256x224 resolution, 224/16)
NUM_COLS equ 16 ;16 columns (256x224 resolution, 256/16)
MAP_WIDTH equ 32
MAP_HEIGHT equ 32

;load a level into vram
;_si: map pointer
scroll_fill:
	stwz <_di ;pointer to vram BAT address
	lda #MAP_HEIGHT
	sta <_dl
.col_loop:
;tile num = (num >> 3) * $20 + (num & 7) * 2
;         = ((num & $fff8) << 2) + ((num & 7) << 1)
	ldx #MAP_WIDTH
	cly
.row_loop:
	lda [<_si],y
	sta <_al ;_ax is the first "num"
	;((num & 7) << 1)
	and #$7
	asl a
	sta <_bl ;_bx is the second "num"

	iny
	lda [<_si],y
	sta <_ah
	stz <_bh
	iny
	;((num & #$fff8) << 2)
	andw <_ax,#$fff8
	aslw <_ax
	aslw <_ax
	addw <_ax,<_bx
	addw #$200,<_bx ;tile numbers start at $200
	;correct tile number for upper left corner of 16x16 tile now in _bx
	vreg #VDC_MAWR
	stw <_di,video_data
	vreg #VDC_VWR
	stw <_bx,video_data
	;upper right corner
	incw <_bx
	stw <_bx,video_data
	;lower left corner
	addw #$f,<_bx
	;screen is on next row (64x64 tilemap)
	addw #$40,<_di
	vreg #VDC_MAWR
	stw <_di,video_data
	vreg #VDC_VWR
	stw <_bx,video_data
	;lower right corner
	incw <_bx
	stw <_bx,video_data
	;restore vram address to where it should be for the next tile
	subw #$3e,<_di ;each row is $40, so subtracting $3e is like
	vreg #VDC_MAWR ;subtracting $40 and adding $2
	stw <_di,video_data
	vreg #VDC_VWR
	dex
	beq .done_row
	jmp .row_loop
.done_row:
	lda <_dl
	dec a
	beq .done
	sta <_dl
	addw #(MAP_WIDTH * 2),<_si ;map is 64x32, each tile index is 2 bytes
	addw #(MAP_WIDTH * 2),<_di ;skip every other row of the tilemap, plus the remainder
	jmp .col_loop  ;left over from this tilemap
.done:
	rts
	