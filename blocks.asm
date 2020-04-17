; blocks.asm: Block height arrays
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

	.code
	.bank 0
block_arrs:
;empty block
HeightEmpty:
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
;full block
HeightFull:
	.db 16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16
	
;45 degree
Height45:
	.db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
	
;45 degree reversed
Height45R:
	.db 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0
	
;22.5 degree part 1
Height2251:
	.db 0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7
	
;22.5 degree part 1 reversed
Height2251R:
	.db 7,7,6,6,5,5,4,4,3,3,2,2,1,1,0,0
	
;22.5 degree part 2
Height2252:
	.db 8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15
	
;22.5 degree part 2 reversed
Height2252R:
	.db 15,15,14,14,13,13,12,12,11,11,10,10,9,9,8,8

	