	.code
	.bank 0
	.org 0
Tiles:
	.incchr "gfx\bg.pcx"
	
	.bank 1
TilePal:
	.incpal "gfx\bg.pcx",0,1
Map:
	.incbin "map\map1.bin"