MISTERPASSWORD	= 1
MISTER			= root@mister

helloworld.dsk:	helloworld.bin
	-@iDSK -n helloworld.dsk
	-@iDSK helloworld.dsk -i helloworld.bin -f -e 1200 -c 1200 -t 2

helloworld.bin:	helloworld.z80
	-@vasmz80_oldstyle helloworld.z80 -z80asm -chklabels -nocase -L helloworld.lst -Fbin -o helloworld.bin

clean:
	-@rm -f *.dsk
	-@rm -f *.bin
	-@rm -f *.lst

deploy:
	@make
	-@sshpass -p 1 rsync --progress helloworld.dsk root@mister:/media/fat/games/Amstrad/Homebrew/

deploy-run:
	@make deploy
	sshpass -p ${MISTERPASSWORD} ssh ${MISTER} "echo load_core /media/fat/_Computer/Amstrad_*.rbf >/dev/MiSTer_cmd"

run:
	@make
	@retroarch -D -L /usr/lib64/libretro/crocods_libretro.so ./helloworld.dsk > /dev/null 2>&1 &

clean-run:
	@make clean
	@make run
