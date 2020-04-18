; variables.asm: Variables
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

	.zp
start_vars:
	pad: .ds 8 ;scratchpad
	scroll_x: .ds 2
	scroll_y: .ds 2
	status: .ds 1
	frame: .ds 2
	joypad: .ds 1
	joyedge: .ds 1 ;1 when pad transitioned from 0 to 1
	;---player.asm---
	player_x: .ds 3
	player_y: .ds 3
	player_dx: .ds 2
	player_dy: .ds 2
	player_state: .ds 1
	player_frame: .ds 1
end_vars:	
	.bss
	;work ram variables
	.org	user_work_top
	satb: .ds 512