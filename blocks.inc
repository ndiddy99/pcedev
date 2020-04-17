; blocks.inc: Block array positions
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

;empty block
HeightEmpty equ 0
	
;full block
HeightFull equ 1
	
;45 degree
Height45 equ 2
	
;45 degree reversed
Height45R equ 3
	
;22.5 degree part 1
Height2251 equ 4
	
;22.5 degree part 1 reversed
Height2251R equ 5
	
;22.5 degree part 2
Height2252 equ 6
	
;22.5 degree part 2 reversed
Height2252R equ 7

	