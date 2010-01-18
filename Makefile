all:
	cd code && ./build-index > ../to.pm.org/index.html

clean:
	rm -f to.pm.org/index.html
