all:
	cd code && ./build-index > ../to.pm.org/index.html

critic:
	perlcritic --brutal code/build-index

clean:
	rm -f to.pm.org/index.html

install:
	scp to.pm.org/index.html to.pm.org/basic.css tpm@to.pm.org:httpdocs/
