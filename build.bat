cd C:\pce\project
set PCE_INCLUDE=include\pce

..\huc\bin\pceas -m -l 2 -S -cd main.asm
pause

start ..\mednafen\mednafen.exe main.cue
