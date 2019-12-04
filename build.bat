ca65 -g %1.asm -o %1.o
@if %errorlevel% neq 0 goto:EOF	
ld65 %1.o -o %1.nes --dbgfile %1.dbg -t nes
