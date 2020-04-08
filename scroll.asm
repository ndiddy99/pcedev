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
	.org cd_end

NUM_ROWS equ 14 ;14 rows (256x224 resolution, 224/16)
NUM_COLS equ 16 ;16 columns (256x224 resolution, 256/16)
MAP_WIDTH equ 64
MAP_HEIGHT equ 32

;writes the given coords to vram starting at scroll pos 0,0 and filling
;the whole screen
;x: x tile num
;y: y tile num
scroll_fill:
	;map location is (y * MAP_WIDTH * 2) + x * 2
	sty <_si+1
	lsrw <_si ;128 (MAP_WIDTH * 2) is 2^7 so copy to high byte and shift right once
	txa
	asl a
	clc
	adc <_si
	sta <_si
	lda <_si+1
	adc #0
	sta <_si+1

	;tilemap uses 16x16 tiles, so make it 8x8 like the vdc expects
	stwz <_di ;pointer to video start address
	addw #map_load,<_si
	lda #NUM_ROWS 
	sta <_dl
.col_loop:
;tile num = (num >> 3) * $20 + (num & 7) * 2
;         = ((num & $fff8) << 2) + ((num & 7) << 1)
	ldx #NUM_COLS
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
	addw #(MAP_WIDTH-NUM_COLS)*2,<_di ;skip every other row of the tilemap, plus the remainder
	jmp .col_loop  ;left over from this tilemap
.done:
	rts
	
;copies a single row into vram above the viewable area
scroll_uprow:
;map location is (((scroll_y >> 4) - 1) * MAP_WIDTH * 2) + (scroll_x >> 4) * 2
;             or (((scroll_y & $fff0) << 3) - 128) + ((scroll_x >> 3) & $fffe)
	stw <scroll_y,<_si
	andw <_si,#$fff0
	aslw <_si
	aslw <_si
	aslw <_si
	subw #128,<_si ;MAP_WIDTH * 2
	stw <scroll_x,<_ax
	lsrw <_ax
	lsrw <_ax
	lsrw <_ax
	andw <_ax,#$fffe
	addw <_ax,<_si
	addw #map_load,<_si
	
;destination in vram is (((scroll_y & $1f0) << 3) - $80) + ((scroll_x & $1f0) >> 3)
	stw <scroll_y,<_di
	andw <_di,#$1f0
	aslw <_di
	aslw <_di
	aslw <_di
	subw #$80,<_di
	stw <scroll_x,<_ax
	andw <_ax,#$1f0
	lsrw <_ax
	lsrw <_ax
	lsrw <_ax
	addw <_ax,<_di
	andw <_di,#$fff ;keep it in the tilemap range
	;column number in cx
	stw <_ax,<_cx
	lsrw <_cx
	;want to keep track of when we're on a 32 tile boundary
	lda <_cl
	and #$1f
	sta <_cl
	
;tile num = (num >> 3) * $20 + (num & 7) * 2
;         = ((num & $fff8) << 2) + ((num & 7) << 1)
	ldx #NUM_COLS
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
	lda <_cl
	cmp #$1f
	bne .normal_subtract
	subw #$7e,<_di ;subtract 1 extra row to compensate for the border
	stz <_cl
	bra .done_subtract
.normal_subtract:
	subw #$3e,<_di ;each row is $40, so subtracting $3e is like
.done_subtract:
	vreg #VDC_MAWR ;subtracting $40 and adding $2
	stw <_di,video_data
	vreg #VDC_VWR
	inc <_cl
	dex
	beq .done_row
	jmp .row_loop
.done_row:
	rts
	
;copies a single row into vram below the viewable area
scroll_downrow:
;map location is (((scroll_y >> 4) + NUM_ROWS + 1) * MAP_WIDTH * 2) + (scroll_x >> 4) * 2
;             or (((scroll_y & $fff0) << 3) + 1920) + ((scroll_x >> 3) & $fffe)
	stw <scroll_y,<_si
	andw <_si,#$fff0
	aslw <_si
	aslw <_si
	aslw <_si
	addw #1920,<_si ;MAP_WIDTH * 2 * (NUM_ROWS + 1)
	stw <scroll_x,<_ax
	lsrw <_ax
	lsrw <_ax
	lsrw <_ax
	andw <_ax,#$fffe
	addw <_ax,<_si
	addw #map_load,<_si
	
;destination in vram is (((scroll_y & $1f0) << 3) + $780) + ((scroll_x & $1f0) >> 3)
	stw <scroll_y,<_di
	andw <_di,#$1f0
	aslw <_di
	aslw <_di
	aslw <_di
	addw #$780,<_di ;(NUM_ROWS + 1) * #$80
	stw <scroll_x,<_ax
	andw <_ax,#$1f0
	lsrw <_ax
	lsrw <_ax
	lsrw <_ax
	addw <_ax,<_di
	andw <_di,#$fff ;keep it in the tilemap range
	;column number in cx
	stw <_ax,<_cx
	lsrw <_cx
	;want to keep track of when we're on a 32 tile boundary
	lda <_cl
	and #$1f
	sta <_cl
	
;tile num = (num >> 3) * $20 + (num & 7) * 2
;         = ((num & $fff8) << 2) + ((num & 7) << 1)
	ldx #NUM_COLS
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
	lda <_cl
	cmp #$1f
	bne .normal_subtract
	subw #$7e,<_di ;subtract 1 extra row to compensate for the border
	stz <_cl
	bra .done_subtract
.normal_subtract:
	subw #$3e,<_di ;each row is $40, so subtracting $3e is like
.done_subtract:
	vreg #VDC_MAWR ;subtracting $40 and adding $2
	stw <_di,video_data
	vreg #VDC_VWR
	inc <_cl
	dex
	beq .done_row
	jmp .row_loop
.done_row:
	rts
	
	