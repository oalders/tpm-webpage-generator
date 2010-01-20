all:
	cd code && ./build-index > ../to.pm.org/index.html

critic:
	perlcritic --brutal code/build-index

clean:
	rm -f to.pm.org/index.html
