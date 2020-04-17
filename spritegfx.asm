	.code
	.bank 0
	.org 0
PlayerPal:
	.incpal "gfx\player.pcx",0,1
PlayerChr:
	.incspr "gfx\player.pcx",0,0,1,1  ;top half- standing
	.incspr "gfx\player.pcx",16,0,1,1 ;top half- run 1
	.incspr "gfx\player.pcx",0,16,1,1 ;bottom half- standing	
	.incspr "gfx\player.pcx",16,16,1,1 ;bottom half- run 1
	.incspr "gfx\player.pcx",32,0,1,1 ;top half- run 2
	.incspr "gfx\player.pcx",48,0,1,1 ;top half- jump
	.incspr "gfx\player.pcx",32,16,1,1 ;bottom half- run 2
	.incspr "gfx\player.pcx",48,16,1,1 ;bottom half- jump