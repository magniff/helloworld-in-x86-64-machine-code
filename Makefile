all:
	sed "s/#.*//" helloworld.hex | xxd -r -p > helloworld
	chmod +x helloworld

clean:
	rm helloworld