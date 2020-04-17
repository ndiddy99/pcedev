	.code
	.bank 0
	.org 0
	.include "blocks.inc"
Tiles:
	.incchr "gfx\bg.pcx"
	
	.bank 1
TilePal:
	.incpal "gfx\bg.pcx",0,1
BlockDefs:
	.db HeightEmpty,HeightFull,Height45,Height45R,Height2251,Height2252,Height2252R,Height2251R
	.db HeightFull,HeightFull,HeightFull,HeightFull,HeightFull,HeightFull,HeightFull,HeightFull
	.db HeightFull,HeightFull,HeightFull,HeightFull,HeightFull,HeightFull,HeightFull,HeightFull
	.db HeightFull,HeightFull,HeightFull,HeightFull,HeightFull,HeightFull,HeightFull,HeightFull
	.db 0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0
	
Map:
	.incbin "map\map1.bin"
Block